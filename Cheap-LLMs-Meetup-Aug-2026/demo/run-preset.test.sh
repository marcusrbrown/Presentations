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

DEMO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
RUNNER="$DEMO_DIR/run-preset.sh"
REPO="${MOTHERSHIP_DEMO_REPO:-/Users/mrbrown/src/github.com/marcusrbrown/.demo-workspaces/cccc-aug-2026/mothership-base/.worktrees/demo/cccc-aug-2026}"
SOURCE_HOME="$HOME"
SOURCE_OPENCODE_DIR="$SOURCE_HOME/.config/opencode"
SOURCE_OMO_CONFIG="$SOURCE_OPENCODE_DIR/oh-my-opencode-slim.jsonc"

TEST_ROOT=""
cleanup_test() {
  [[ -z "$TEST_ROOT" || ! -d "$TEST_ROOT" ]] || rm -rf "$TEST_ROOT"
}
trap cleanup_test EXIT

TEST_ROOT="$(mktemp -d /tmp/run-preset-test.XXXXXX)" || die "could not create test root"
TEST_TMPDIR="$TEST_ROOT/tmp"
mkdir -p "$TEST_TMPDIR"
export TMPDIR="$TEST_TMPDIR"

FAKE_HOME="$TEST_ROOT/home"
FAKE_BIN="$TEST_ROOT/bin"
FAKE_MARKER="$TEST_ROOT/opencode-called"
INHERITED_CONFIG="$TEST_ROOT/inherited-config"
INHERITED_WORKDIR="$TEST_ROOT/inherited-workdir"
INHERITED_TMPDIR_TEST="$TEST_ROOT/inherited-tmpdir-test"
UNRELATED_LOG="$TEST_ROOT/unrelated.log"
readonly DURABLE_LOG_SENTINEL="$TEST_TMPDIR/mothership-unrelated-durable.log"
mkdir -p "$FAKE_HOME/.config/opencode" "$FAKE_BIN" "$INHERITED_CONFIG" \
  "$INHERITED_WORKDIR" "$INHERITED_TMPDIR_TEST"
touch "$INHERITED_CONFIG/sentinel.txt" "$INHERITED_WORKDIR/sentinel.txt" \
  "$INHERITED_TMPDIR_TEST/sentinel.txt" "$UNRELATED_LOG" "$DURABLE_LOG_SENTINEL"

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
printf 'called\n' >> "$FAKE_MARKER"
exit "${FAKE_OPENCODE_EXIT:-0}"
EOF
chmod 700 "$FAKE_BIN/opencode"

export HOME="$FAKE_HOME"
export PATH="$FAKE_BIN:$PATH"
export MOTHERSHIP_DEMO_REPO="$REPO"
export OPENCODE_CONFIG_DIR="$INHERITED_CONFIG"
export TEMP_WORKDIR="$INHERITED_WORKDIR"
export TMPDIR_TEST="$INHERITED_TMPDIR_TEST"
export FAKE_MARKER

[[ -d "$REPO" ]] || die "mothership worktree does not exist: $REPO"
assert_eq "mothership HEAD is the declared baseline" \
  "bdd1b1b99fa630bb87472e2f714d6505c8eaf6ed" \
  "$(git -C "$REPO" rev-parse HEAD)"

if /bin/bash -n "$RUNNER" && /bin/bash -n "$DEMO_DIR/run-preset.test.sh"; then
  printf '✓ Bash syntax is valid\n'
else
  die "Bash syntax check failed"
fi

[[ -x "$RUNNER" ]] || die "run-preset.sh is not executable"
[[ -x "$DEMO_DIR/run-preset.test.sh" ]] || die "run-preset.test.sh is not executable"
printf '✓ scripts are executable\n'

printf '\nTest 1: argument validation\n'
if /bin/bash "$RUNNER" >/dev/null 2>&1; then die "no args should fail"; fi
if /bin/bash "$RUNNER" invalid-preset >/dev/null 2>&1; then die "invalid preset should fail"; fi
if /bin/bash "$RUNNER" opencode-go --dry-run >/dev/null 2>&1; then
  die "opencode-go without --allow-go should fail"
fi
printf '✓ no, invalid, and disallowed Go args fail\n'

run_dry() {
  local name="$1" expected_status="$2" expected_home="$3"
  shift 3

  local before_head before_porcelain after_head after_porcelain
  before_head="$(git -C "$REPO" rev-parse HEAD)"
  before_porcelain="$(git -C "$REPO" status --porcelain)"

  if HOME="$expected_home" output=$(/bin/bash "$RUNNER" "$@" 2>&1); then
    status=0
  else
    status=$?
  fi

  after_head="$(git -C "$REPO" rev-parse HEAD)"
  after_porcelain="$(git -C "$REPO" status --porcelain)"
  assert_eq "$name preserves HEAD" "$before_head" "$after_head"
  assert_eq "$name preserves porcelain" "$before_porcelain" "$after_porcelain"
  assert_eq "$name exit status" "$expected_status" "$status"
  LAST_OUTPUT="$output"
}

printf '\nTest 2: openai dry-run constructs and validates owned config\n'
run_dry "openai dry-run" 0 "$FAKE_HOME" openai --dry-run
assert_contains "openai config path is reported" "$LAST_OUTPUT" "  Config dir: $TEST_TMPDIR/"
assert_contains "openai routing comes from copied config" "$LAST_OUTPUT" \
  "orchestrator openai/gpt-5.6-sol medium"
assert_contains "openai explorer routing comes from copied config" "$LAST_OUTPUT" \
  "explorer github-copilot/gpt-5.4-mini low"
assert_contains "openai fixer is overridden in copied config" "$LAST_OUTPUT" \
  "fixer openai/gpt-5.6-luna low"
assert_contains "openai reports exactly one Luna replacement" "$LAST_OUTPUT" \
  "Luna fixer override: xhigh -> low (1 replacement)"
assert_contains "openai guard is disabled in copied config" "$LAST_OUTPUT" \
  "Guard mode: \"disabled\""
assert_contains "openai dry-run reports config validation" "$LAST_OUTPUT" \
  "Config validation: OK"
config_dir="$(printf '%s\n' "$LAST_OUTPUT" | awk -F': ' '/^  Config dir: / { print $2; exit }')"
log_path="$(printf '%s\n' "$LAST_OUTPUT" | awk -F': ' '/^  Log path: / { print $2; exit }')"
[[ "$log_path" =~ ^/tmp/mothership-openai-[0-9]{8}-[0-9]{6}\.log$ ]] ||
  die "openai dry-run did not report durable /tmp log path: $log_path"
[[ "$log_path" != "$config_dir/"* ]] ||
  die "openai log path is beneath owned config dir: $log_path"
[[ ! -d "$config_dir" ]] || die "owned config dir survived dry-run: $config_dir"
[[ ! -e "$FAKE_MARKER" ]] || die "dry-run invoked fake opencode"
assert_file "dry-run preserves inherited config sentinel" "$INHERITED_CONFIG/sentinel.txt"
assert_file "dry-run preserves inherited workdir sentinel" "$INHERITED_WORKDIR/sentinel.txt"
assert_file "dry-run preserves inherited TMPDIR_TEST sentinel" "$INHERITED_TMPDIR_TEST/sentinel.txt"
assert_file "dry-run preserves unrelated log" "$UNRELATED_LOG"
assert_file "config cleanup preserves durable log sentinel" "$DURABLE_LOG_SENTINEL"

printf '\nTest 3: mixed-fable dry-run routing and cleanup\n'
run_dry "mixed-fable dry-run" 0 "$FAKE_HOME" mixed-fable --dry-run
assert_contains "mixed-fable orchestrator routing" "$LAST_OUTPUT" \
  "orchestrator anthropic/claude-fable-5 high"
assert_contains "mixed-fable explorer routing" "$LAST_OUTPUT" \
  "explorer github-copilot/gpt-5.4-mini low"
assert_contains "mixed-fable fixer override" "$LAST_OUTPUT" \
  "fixer openai/gpt-5.6-luna low"
assert_contains "mixed-fable guard is disabled" "$LAST_OUTPUT" \
  "Guard mode: \"disabled\""
assert_not_contains "mixed-fable dry-run does not call opencode" "$LAST_OUTPUT" \
  "opencode run"

printf '\nTest 4: opencode-go dry-run leaves Go fixer unchanged\n'
run_dry "opencode-go dry-run" 0 "$FAKE_HOME" opencode-go --allow-go --dry-run
assert_contains "opencode-go orchestrator routing" "$LAST_OUTPUT" \
  "orchestrator opencode-go/minimax-m3 thinking"
assert_contains "opencode-go explorer routing" "$LAST_OUTPUT" \
  "explorer opencode-go/deepseek-v4-flash high"
assert_contains "opencode-go fixer remains unchanged" "$LAST_OUTPUT" \
  "fixer opencode-go/deepseek-v4-flash high"
assert_not_contains "opencode-go has no Luna override" "$LAST_OUTPUT" \
  "Luna fixer override"
assert_contains "opencode-go guard is disabled" "$LAST_OUTPUT" \
  "Guard mode: \"disabled\""

printf '\nTest 5: copied-config routing validation rejects mismatches\n'
run_dry "broken copied config dry-run" 1 "$BROKEN_HOME" openai --dry-run
assert_contains "broken config fails validation" "$LAST_OUTPUT" "config validation failed"
[[ ! -e "$FAKE_MARKER" ]] || die "broken dry-run invoked fake opencode"

printf '\nTest 6: actual mode preserves fake opencode nonzero status\n'
rm -f "$FAKE_MARKER"
export FAKE_OPENCODE_EXIT=7
if HOME="$FAKE_HOME" output=$(/bin/bash "$RUNNER" openai 2>&1); then
  die "actual mode unexpectedly succeeded"
else
  status=$?
fi
assert_eq "actual mode preserves opencode exit status" "7" "$status"
assert_file "actual mode invoked only the fake opencode" "$FAKE_MARKER"
assert_file "inherited config sentinel survives" "$INHERITED_CONFIG/sentinel.txt"
assert_file "inherited workdir sentinel survives" "$INHERITED_WORKDIR/sentinel.txt"
assert_file "inherited TMPDIR_TEST sentinel survives" "$INHERITED_TMPDIR_TEST/sentinel.txt"
assert_file "unrelated log survives" "$UNRELATED_LOG"
assert_not_contains "runner no longer uses orphan exit-code temp file" \
  "$(printf '%s\n' "$(< "$RUNNER")")" "/tmp/opencode_exit_code.\$\$"

printf '\nTest 7: prompt contract\n'
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
assert_contains "prompt forbids nested verification" "$prompt_content" \
  'nested verification'
assert_contains "prompt requires background style" "$prompt_content" 'background: "var(--color-error)"'
assert_contains "prompt requires color style" "$prompt_content" 'color: "var(--color-bg)"'
assert_contains "prompt requires border style" "$prompt_content" 'border: "1px solid var(--color-bg)"'
assert_contains "prompt requires borderRadius style" "$prompt_content" 'borderRadius: "var(--radius-sm)"'
assert_contains "prompt requires padding style" "$prompt_content" 'padding: "2px var(--space-2)"'
assert_contains "prompt requires font style" "$prompt_content" 'font: "inherit"'
assert_contains "prompt requires fontWeight style" "$prompt_content" 'fontWeight: 700'
assert_contains "prompt requires cursor style" "$prompt_content" 'cursor: "pointer"'
assert_contains "prompt requires outlineOffset style" "$prompt_content" 'outlineOffset: 2'
assert_contains "prompt forbids outline: none" "$prompt_content" 'forbid outline: "none"'
assert_contains "prompt forbids focus/blur scripting" "$prompt_content" 'forbid onFocus, onBlur, or box-shadow focus scripting'
assert_contains "prompt forbids transition styling" "$prompt_content" 'forbid transition styling'
assert_contains "prompt forbids adding margin" "$prompt_content" 'do not add margin'

printf '\nTest 8: source-level regression assertions\n'
runner_source="$(< "$RUNNER")"
assert_contains "runner compares current HEAD to BASELINE" "$runner_source" \
  "current_head\" == \"\$BASELINE"
assert_contains "runner captures PIPESTATUS directly" "$runner_source" 'PIPESTATUS'
assert_not_contains "runner has no orphan exit-code path" "$runner_source" \
  '/tmp/opencode_exit_code.$$'
assert_contains "runner writes disabled workflow guard" "$runner_source" \
  '"mode": "disabled"'

printf '\n✅ All tests GREEN\n'
