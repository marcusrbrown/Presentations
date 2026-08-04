#!/usr/bin/env bash
set -euo pipefail

die() {
  printf 'run-preset.test: %s\n' "$*" >&2
  exit 1
}

assert_eq() {
  local name="$1" expected="$2" actual="$3"
  [[ "$expected" == "$actual" ]] || die "$name: expected [$expected], got [$actual]"
  printf '✓ %s\n' "$name"
}

assert_contains() {
  local name="$1" haystack="$2" needle="$3"
  [[ "$haystack" == *"$needle"* ]] || die "$name: missing [$needle]"
  printf '✓ %s\n' "$name"
}

assert_not_contains() {
  local name="$1" haystack="$2" needle="$3"
  [[ "$haystack" != *"$needle"* ]] || die "$name: found [$needle]"
  printf '✓ %s\n' "$name"
}

assert_file() {
  local name="$1" path="$2"
  [[ -f "$path" ]] || die "$name: missing file $path"
  printf '✓ %s\n' "$name"
}

assert_clean_repo() {
  local name="$1" porcelain
  porcelain="$(git -C "$ISOLATED_REPO" status --porcelain)"
  [[ -z "$porcelain" ]] || die "$name: repository is dirty: $porcelain"
  printf '✓ %s\n' "$name"
}

DEMO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
RUNNER="$DEMO_DIR/run-preset.sh"
RESETTER="$DEMO_DIR/reset-demo.sh"
BASELINE="bdd1b1b99fa630bb87472e2f714d6505c8eaf6ed"
EXPECTED_REMOTE="git@github.com:marcusrbrown/mothership.git"
DEMO_BRANCH="demo/cccc-aug-2026"
SOURCE_REPO="${SOURCE_MOTHERSHIP_REPO:-/Users/mrbrown/src/github.com/marcusrbrown/.demo-workspaces/cccc-aug-2026/mothership-base/.worktrees/demo/cccc-aug-2026}"
SOURCE_HOME="$HOME"
SOURCE_OMO_CONFIG="$SOURCE_HOME/.config/opencode/oh-my-opencode-slim.jsonc"

TEST_ROOT=""
CREATED_LOGS=""
cleanup_test() {
  if [[ -n "$CREATED_LOGS" ]]; then
    while IFS= read -r log_path; do
      [[ -z "$log_path" ]] || rm -f "$log_path"
    done <<EOF
$CREATED_LOGS
EOF
  fi
  [[ -z "$TEST_ROOT" || ! -d "$TEST_ROOT" ]] || rm -rf "$TEST_ROOT"
}
trap cleanup_test EXIT

remember_log() {
  if [[ -z "$CREATED_LOGS" ]]; then
    CREATED_LOGS="$1"
  else
    CREATED_LOGS="$CREATED_LOGS
$1"
  fi
}

TEST_ROOT="$(mktemp -d /tmp/run-preset-test.XXXXXX)" || die "could not create test root"
TEST_TMPDIR="$TEST_ROOT/tmp"
mkdir -p "$TEST_TMPDIR"
export TMPDIR="$TEST_TMPDIR"

ISOLATED_REPO="$TEST_ROOT/mothership"
git clone --local "$SOURCE_REPO" "$ISOLATED_REPO" >/dev/null 2>&1 ||
  die "could not clone local mothership source"
git -C "$ISOLATED_REPO" remote set-url origin "$EXPECTED_REMOTE"
git -C "$ISOLATED_REPO" checkout -B "$DEMO_BRANCH" "$BASELINE" >/dev/null 2>&1 ||
  die "could not create isolated demo branch"

FAKE_HOME="$TEST_ROOT/home"
FAKE_BIN="$TEST_ROOT/bin"
FAKE_MARKER="$TEST_ROOT/opencode-called"
FAKE_BUN_MARKER="$TEST_ROOT/bun-called"
FAKE_OPENCODE_PID_FILE="$TEST_ROOT/opencode.pid"
INHERITED_CONFIG="$TEST_ROOT/inherited-config"
INHERITED_WORKDIR="$TEST_ROOT/inherited-workdir"
INHERITED_TMPDIR_TEST="$TEST_ROOT/inherited-tmpdir-test"
UNRELATED_LOG="$TEST_ROOT/unrelated.log"
mkdir -p "$FAKE_HOME/.config/opencode" "$FAKE_BIN" "$INHERITED_CONFIG" \
  "$INHERITED_WORKDIR" "$INHERITED_TMPDIR_TEST"
touch "$INHERITED_CONFIG/sentinel.txt" "$INHERITED_WORKDIR/sentinel.txt" \
  "$INHERITED_TMPDIR_TEST/sentinel.txt" "$UNRELATED_LOG"

assert_file "source OMO config exists" "$SOURCE_OMO_CONFIG"
printf '{}\n' > "$FAKE_HOME/.config/opencode/opencode.json"
cp "$SOURCE_OMO_CONFIG" "$FAKE_HOME/.config/opencode/oh-my-opencode-slim.jsonc"

BROKEN_HOME="$TEST_ROOT/broken-home"
mkdir -p "$BROKEN_HOME/.config/opencode"
printf '{}\n' > "$BROKEN_HOME/.config/opencode/opencode.json"
awk '
  BEGIN { changed = 0 }
  !changed && /"variant"[[:space:]]*:[[:space:]]*"medium"/ {
    sub(/"medium"/, "\"wrong\"")
    changed = 1
  }
  { print }
' "$SOURCE_OMO_CONFIG" > "$BROKEN_HOME/.config/opencode/oh-my-opencode-slim.jsonc"

cat > "$FAKE_BIN/opencode" <<'EOF'
#!/bin/bash
repo="${MOTHERSHIP_DEMO_REPO:?}"
mode="${FAKE_OPENCODE_MODE:-noop}"

if [[ "$mode" != "noop" ]]; then
  printf '\n// fake agent change\n' >> "$repo/src/app/StartupHandshake.tsx"
fi
if [[ -n "${FAKE_UNTRACKED_FILE:-}" ]]; then
  printf 'untracked fake agent output\n' > "$repo/${FAKE_UNTRACKED_FILE}"
fi
if [[ "$mode" == "whitespace" ]]; then
  printf 'trailing whitespace   \n' >> "$repo/src/app/StartupHandshake.tsx"
fi
if [[ -n "${FAKE_MARKER:-}" ]]; then
  touch "$FAKE_MARKER"
fi
if [[ -n "${FAKE_OPENCODE_PID_FILE:-}" ]]; then
  printf '%s\n' "$$" > "$FAKE_OPENCODE_PID_FILE"
fi
if [[ "$mode" == "sleep" ]]; then
  trap 'exit 130' INT
  trap 'exit 143' TERM
  while :; do sleep 1; done
fi
if [[ "$mode" == "signal" ]]; then
  kill -"${FAKE_SIGNAL:?}" "$$"
fi
exit "${FAKE_OPENCODE_EXIT:-0}"
EOF

cat > "$FAKE_BIN/bun" <<'EOF'
#!/bin/bash
if [[ -n "${FAKE_BUN_MARKER:-}" ]]; then
  touch "$FAKE_BUN_MARKER"
fi
exit "${FAKE_BUN_EXIT:-0}"
EOF

cat > "$FAKE_BIN/tee" <<'EOF'
#!/bin/bash
if [[ "${FAKE_TEE_MODE:-pass}" == "fail" ]]; then
  /bin/cat >/dev/null
  exit "${FAKE_TEE_EXIT:-19}"
fi
exec /usr/bin/tee "$@"
EOF
chmod 700 "$FAKE_BIN/opencode" "$FAKE_BIN/bun" "$FAKE_BIN/tee"

export HOME="$FAKE_HOME"
export PATH="$FAKE_BIN:$PATH"
export MOTHERSHIP_DEMO_REPO="$ISOLATED_REPO"
export OPENCODE_CONFIG_DIR="$INHERITED_CONFIG"
export TEMP_WORKDIR="$INHERITED_WORKDIR"
export TMPDIR_TEST="$INHERITED_TMPDIR_TEST"
export FAKE_MARKER FAKE_BUN_MARKER FAKE_OPENCODE_PID_FILE

assert_eq "isolated mothership HEAD is baseline" "$BASELINE" \
  "$(git -C "$ISOLATED_REPO" rev-parse HEAD)"
assert_eq "isolated mothership branch is demo branch" "$DEMO_BRANCH" \
  "$(git -C "$ISOLATED_REPO" branch --show-current)"
assert_eq "isolated mothership origin is exact" "$EXPECTED_REMOTE" \
  "$(git -C "$ISOLATED_REPO" config --get remote.origin.url)"
assert_clean_repo "isolated mothership starts clean"

if /bin/bash -n "$RUNNER" && /bin/bash -n "$DEMO_DIR/run-preset.test.sh" &&
   /bin/bash -n "$RESETTER"; then
  printf '✓ Bash syntax is valid for all scripts\n'
else
  die "Bash syntax check failed"
fi
[[ -x "$RUNNER" ]] || die "run-preset.sh is not executable"
[[ -x "$DEMO_DIR/run-preset.test.sh" ]] || die "run-preset.test.sh is not executable"
[[ -x "$RESETTER" ]] || die "reset-demo.sh is not executable"
printf '✓ scripts are executable\n'

reset_fixture() {
  git -C "$ISOLATED_REPO" checkout "$DEMO_BRANCH" >/dev/null 2>&1
  git -C "$ISOLATED_REPO" reset --hard "$BASELINE" >/dev/null 2>&1
  rm -f "$ISOLATED_REPO/fake-agent-untracked.txt"
  rm -f "$FAKE_MARKER" "$FAKE_BUN_MARKER" "$FAKE_OPENCODE_PID_FILE"
  unset FAKE_OPENCODE_MODE FAKE_OPENCODE_EXIT FAKE_BUN_EXIT FAKE_UNTRACKED_FILE
  export FAKE_TEE_MODE=pass
  assert_clean_repo "fixture reset is clean"
}

run_dry() {
  local name="$1" expected_status="$2" expected_home="$3"
  shift 3
  local before_head before_porcelain after_head after_porcelain
  before_head="$(git -C "$ISOLATED_REPO" rev-parse HEAD)"
  before_porcelain="$(git -C "$ISOLATED_REPO" status --porcelain)"
  if HOME="$expected_home" output=$(/bin/bash "$RUNNER" "$@" 2>&1); then
    status=0
  else
    status=$?
  fi
  after_head="$(git -C "$ISOLATED_REPO" rev-parse HEAD)"
  after_porcelain="$(git -C "$ISOLATED_REPO" status --porcelain)"
  assert_eq "$name preserves HEAD" "$before_head" "$after_head"
  assert_eq "$name preserves porcelain" "$before_porcelain" "$after_porcelain"
  assert_eq "$name exit status" "$expected_status" "$status"
  LAST_OUTPUT="$output"
}

run_actual() {
  local expected_status="$1"
  shift
  if HOME="$FAKE_HOME" output=$(/bin/bash "$RUNNER" "$@" 2>&1); then
    status=0
  else
    status=$?
  fi
  if [[ "$status" != "$expected_status" ]]; then
    printf '%s\n' "$output" >&2
  fi
  assert_eq "actual run exit status" "$expected_status" "$status"
  LAST_OUTPUT="$output"
}

printf '\nTest 1: argument validation\n'
if /bin/bash "$RUNNER" >/dev/null 2>&1; then die "no args should fail"; fi
if /bin/bash "$RUNNER" invalid-preset >/dev/null 2>&1; then die "invalid preset should fail"; fi
if /bin/bash "$RUNNER" opencode-go --dry-run >/dev/null 2>&1; then
  die "opencode-go without --allow-go should fail"
fi
printf '✓ no, invalid, and disallowed Go args fail\n'

printf '\nTest 2: openai dry-run constructs config without logs\n'
run_dry "openai dry-run" 0 "$FAKE_HOME" openai --dry-run
assert_contains "openai config path is reported" "$LAST_OUTPUT" "  Config dir: $TEST_TMPDIR/"
assert_contains "openai routing comes from copied config" "$LAST_OUTPUT" \
  "orchestrator openai/gpt-5.6-sol medium"
assert_contains "openai explorer routing comes from copied config" "$LAST_OUTPUT" \
  "explorer github-copilot/gpt-5.4-mini low"
assert_contains "openai fixer is overridden in copied config" "$LAST_OUTPUT" \
  "fixer openai/gpt-5.6-luna low"
assert_contains "openai guard is disabled in copied config" "$LAST_OUTPUT" \
  "Guard mode: \"disabled\""
assert_contains "dry-run reports no created log" "$LAST_OUTPUT" \
  "Log path: not created during dry-run"
config_dir="$(printf '%s\n' "$LAST_OUTPUT" | awk -F': ' '/^  Config dir: / { print $2; exit }')"
[[ ! -d "$config_dir" ]] || die "owned config dir survived dry-run: $config_dir"
[[ ! -e "$FAKE_MARKER" ]] || die "dry-run invoked fake opencode"
assert_clean_repo "dry-run preserves isolated repo"

printf '\nTest 3: mixed-fable and opencode-go dry-run routing\n'
run_dry "mixed-fable dry-run" 0 "$FAKE_HOME" mixed-fable --dry-run
assert_contains "mixed-fable orchestrator routing" "$LAST_OUTPUT" \
  "orchestrator anthropic/claude-fable-5 high"
assert_contains "mixed-fable explorer routing" "$LAST_OUTPUT" \
  "explorer github-copilot/gpt-5.4-mini low"
assert_contains "mixed-fable fixer override" "$LAST_OUTPUT" \
  "fixer openai/gpt-5.6-luna low"
assert_contains "mixed-fable guard is disabled" "$LAST_OUTPUT" \
  "Guard mode: \"disabled\""
run_dry "opencode-go dry-run" 0 "$FAKE_HOME" opencode-go --allow-go --dry-run
assert_contains "opencode-go fixer remains unchanged" "$LAST_OUTPUT" \
  "fixer opencode-go/deepseek-v4-flash high"
assert_not_contains "opencode-go has no Luna override" "$LAST_OUTPUT" \
  "Luna fixer override"

printf '\nTest 4: copied-config routing validation rejects mismatches\n'
run_dry "broken copied config dry-run" 1 "$BROKEN_HOME" openai --dry-run
assert_contains "broken config fails validation" "$LAST_OUTPUT" "config validation failed"

printf '\nTest 5: fake successful agent with untracked output is rejected\n'
reset_fixture
export FAKE_OPENCODE_MODE=modify-success FAKE_UNTRACKED_FILE=fake-agent-untracked.txt
export FAKE_BUN_EXIT=0
run_actual 1 openai
assert_contains "untracked scope failure is reported" "$LAST_OUTPUT" \
  "expected exact post-run porcelain"
assert_not_contains "untracked scope failure does not report GREEN" "$LAST_OUTPUT" \
  "completed GREEN"
assert_file "untracked fake output remains for inspection" \
  "$ISOLATED_REPO/fake-agent-untracked.txt"
assert_not_contains "runner does not use git clean" "$(< "$RUNNER")" 'git clean'

printf '\nTest 6: reset-after restores OpenCode failure and preserves status\n'
reset_fixture
export FAKE_OPENCODE_MODE=modify-failure FAKE_OPENCODE_EXIT=7
run_actual 7 openai --reset-after
assert_contains "OpenCode failure triggers reset" "$LAST_OUTPUT" "Executing reset-demo.sh"
assert_clean_repo "OpenCode failure reset leaves repo clean"
assert_eq "OpenCode failure reset restores HEAD" "$BASELINE" \
  "$(git -C "$ISOLATED_REPO" rev-parse HEAD)"

printf '\nTest 7: reset-after restores post-run test failure\n'
reset_fixture
export FAKE_OPENCODE_MODE=modify-success FAKE_BUN_EXIT=23
run_actual 23 openai --reset-after
assert_contains "post-run test failure triggers reset" "$LAST_OUTPUT" "Executing reset-demo.sh"
assert_clean_repo "post-run test failure reset leaves repo clean"

printf '\nTest 8: reset-after restores diff failure\n'
reset_fixture
export FAKE_OPENCODE_MODE=whitespace FAKE_BUN_EXIT=0
run_actual 2 openai --reset-after
assert_contains "diff failure triggers reset" "$LAST_OUTPUT" "Executing reset-demo.sh"
assert_clean_repo "diff failure reset leaves repo clean"

printf '\nTest 9: reset-after reports dirty reset without deleting untracked files\n'
reset_fixture
export FAKE_OPENCODE_MODE=modify-success FAKE_BUN_EXIT=0 \
  FAKE_UNTRACKED_FILE=fake-agent-untracked.txt
run_actual 1 openai --reset-after
assert_contains "dirty reset is explicit" "$LAST_OUTPUT" \
  "reset left repository dirty"
assert_file "dirty reset preserves untracked output" \
  "$ISOLATED_REPO/fake-agent-untracked.txt"
rm -f "$ISOLATED_REPO/fake-agent-untracked.txt"
assert_clean_repo "test cleanup removes only test-owned untracked output"

printf '\nTest 10: successful reset occurs before GREEN and logs are durable\n'
reset_fixture
export FAKE_OPENCODE_MODE=modify-success FAKE_BUN_EXIT=0
run_actual 0 openai --reset-after
assert_contains "successful reset occurs before GREEN" "$LAST_OUTPUT" \
  "Executing reset-demo.sh"
assert_contains "successful run reports GREEN" "$LAST_OUTPUT" "completed GREEN"
actual_log="$(printf '%s\n' "$LAST_OUTPUT" | awk -F': ' '/^Log path: / { print $2; exit }')"
[[ -n "$actual_log" ]] || die "actual run did not report log path"
[[ "$actual_log" =~ ^/tmp/demo-preset-openai\.[A-Za-z0-9]+$ ]] || \
  die "log path is not mktemp-shaped: $actual_log"
[[ "$actual_log" != "$TEST_TMPDIR"/* ]] || die "log path is beneath test TMPDIR/config: $actual_log"
assert_file "actual log survives config cleanup" "$actual_log"
assert_eq "actual log mode is 600" "600" "$(stat -f '%Lp' "$actual_log")"
remember_log "$actual_log"
first_log="$actual_log"

reset_fixture
export FAKE_OPENCODE_MODE=modify-success FAKE_BUN_EXIT=0
run_actual 0 openai
second_log="$(printf '%s\n' "$LAST_OUTPUT" | awk -F': ' '/^Log path: / { print $2; exit }')"
[[ "$first_log" != "$second_log" ]] || die "log names are predictable/reused"
assert_file "second actual log exists" "$second_log"
assert_eq "second actual log mode is 600" "600" "$(stat -f '%Lp' "$second_log")"
remember_log "$second_log"

printf '\nTest 11: tee failure propagates after successful OpenCode\n'
reset_fixture
export FAKE_OPENCODE_MODE=modify-success FAKE_BUN_EXIT=0 \
  FAKE_TEE_MODE=fail FAKE_TEE_EXIT=19
run_actual 19 openai
assert_not_contains "tee failure does not report GREEN" "$LAST_OUTPUT" "completed GREEN"
reset_fixture

run_signal_test() {
  local signal_name="$1" expected_status="$2" signal_number="$3"
  reset_fixture
  export FAKE_OPENCODE_MODE=signal FAKE_SIGNAL="$signal_number" FAKE_BUN_EXIT=0
  run_actual "$expected_status" openai --reset-after
  assert_contains "$signal_name triggers reset" "$LAST_OUTPUT" "Executing reset-demo.sh"
  assert_clean_repo "$signal_name reset leaves repo clean"
}

printf '\nTest 12: reset-after handles SIGINT and SIGTERM\n'
run_signal_test SIGINT 130 INT
run_signal_test SIGTERM 143 TERM

printf '\nTest 13: prompt contract remains covered\n'
prompt_content="$(< "$DEMO_DIR/prompt.txt")"
assert_contains "prompt has exact onClick prop" "$prompt_content" 'onClick={onRetry}'
assert_contains "prompt has exact literal test command" "$prompt_content" \
  'bun test src/app/StartupHandshake.test.ts -t LiveServerStatus'
assert_contains "prompt requires RED 1/1" "$prompt_content" 'RED 1/1'
assert_contains "prompt requires GREEN 2/0" "$prompt_content" 'GREEN 2/0'
assert_contains "prompt requires first only foreground batch" "$prompt_content" \
  'first and only foreground parallel batch'
assert_contains "prompt scopes change to StartupHandshake.tsx" "$prompt_content" \
  'ONLY StartupHandshake.tsx'
assert_contains "prompt keeps tests untouched" "$prompt_content" 'test file untouched'
assert_contains "prompt forbids stage commit push" "$prompt_content" 'staging, commit, or push'
assert_contains "prompt requires immediate final summary" "$prompt_content" \
  'immediately return the final summary'
assert_contains "prompt forbids nested verification" "$prompt_content" 'nested verification'

printf '\nTest 14: source-level regression assertions\n'
runner_source="$(< "$RUNNER")"
reset_source="$(< "$RESETTER")"
assert_contains "runner compares current HEAD to BASELINE" "$runner_source" \
  "current_head\" == \"\$BASELINE"
assert_contains "runner captures PIPESTATUS directly" "$runner_source" 'PIPESTATUS'
assert_contains "runner captures tee status" "$runner_source" 'tee_exit'
assert_not_contains "runner has no orphan exit-code path" "$runner_source" \
  '/tmp/opencode_exit_code.$$'
assert_contains "runner writes disabled workflow guard" "$runner_source" \
  '"mode": "disabled"'
assert_contains "runner enforces exact post-run porcelain" "$runner_source" \
  ' M src/app/StartupHandshake.tsx'
assert_contains "runner uses exclusive mktemp logs" "$runner_source" \
  'mktemp "/tmp/demo-preset-${preset}.XXXXXX"'
assert_contains "runner protects logs" "$runner_source" 'chmod 600 "$log_path"'
assert_contains "runner traps SIGINT" "$runner_source" 'trap on_sigint INT'
assert_contains "runner traps SIGTERM" "$runner_source" 'trap on_sigterm TERM'
assert_contains "reset checks final porcelain" "$reset_source" \
  'reset left repository dirty'
assert_not_contains "reset never uses git clean" "$reset_source" 'git clean'

printf '\n✅ All tests GREEN\n'
