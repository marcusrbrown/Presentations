#!/usr/bin/env bash
set -euo pipefail

DEMO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
readonly DEMO_DIR
readonly DEFAULT_REPO="/Users/mrbrown/src/github.com/marcusrbrown/.demo-workspaces/cccc-aug-2026/mothership-base/.worktrees/demo/cccc-aug-2026"
readonly EXPECTED_REMOTE="git@github.com:marcusrbrown/mothership.git"
readonly DEMO_BRANCH="demo/cccc-aug-2026"
readonly BASELINE="bdd1b1b99fa630bb87472e2f714d6505c8eaf6ed"

GLOBAL_OPENCODE_CONFIG="${HOME}/.config/opencode/opencode.json"
GLOBAL_OPENCODE_DIR="${HOME}/.config/opencode"
RUN_PRESET_OWN_OPENCODE_CONFIG_DIR=""
RUN_PRESET_EXECUTION_STARTED=0
RUN_PRESET_RESET_DONE=0
RUN_PRESET_FINAL_STATUS=0
reset_after=0

die() {
  printf 'run-preset: %s\n' "$*" >&2
  exit 1
}

cleanup_temp() {
  if [[ -n "$RUN_PRESET_OWN_OPENCODE_CONFIG_DIR" && -d "$RUN_PRESET_OWN_OPENCODE_CONFIG_DIR" ]]; then
    rm -rf "$RUN_PRESET_OWN_OPENCODE_CONFIG_DIR"
  fi
}

perform_reset_after() {
  local original_status="$1" reset_status=0 reset_porcelain

  if [[ "$RUN_PRESET_EXECUTION_STARTED" -eq 1 && "$reset_after" -eq 1 &&
        "$RUN_PRESET_RESET_DONE" -eq 0 ]]; then
    RUN_PRESET_RESET_DONE=1
    printf '\nExecuting reset-demo.sh...\n'
    if "$DEMO_DIR/reset-demo.sh"; then
      reset_status=0
    else
      reset_status=$?
    fi
    reset_porcelain="$(git -C "$repo" status --porcelain 2>/dev/null || true)"
    if [[ -n "$reset_porcelain" ]]; then
      printf 'run-preset: reset-after failed; repository remains dirty:\n%s\n' \
        "$reset_porcelain" >&2
      reset_status=1
    fi
    if [[ "$original_status" -ne 0 ]]; then
      RUN_PRESET_FINAL_STATUS="$original_status"
    else
      RUN_PRESET_FINAL_STATUS="$reset_status"
    fi
  else
    RUN_PRESET_FINAL_STATUS="$original_status"
  fi
}

on_exit() {
  local original_status="$?"
  trap - EXIT INT TERM
  perform_reset_after "$original_status"
  cleanup_temp
  exit "$RUN_PRESET_FINAL_STATUS"
}

on_sigint() {
  exit 130
}

on_sigterm() {
  exit 143
}

trap on_exit EXIT
trap on_sigint INT
trap on_sigterm TERM

override_luna_variant() {
  local config_file="$1" selected_preset="$2" temp_file
  temp_file="$RUN_PRESET_OWN_OPENCODE_CONFIG_DIR/.oh-my-opencode-slim.override.tmp"

  if ! awk -v selected_preset="$selected_preset" '
    function brace_delta(text, opens, closes) {
      opens = text
      closes = text
      return gsub(/\{/, "", opens) - gsub(/\}/, "", closes)
    }
    BEGIN {
      depth = 0
      in_presets = 0
      in_selected = 0
      in_fixer = 0
      replacements = 0
    }
    {
      line = $0

      if (!in_presets && line ~ /"presets"[[:space:]]*:[[:space:]]*\{/) {
        in_presets = 1
        presets_depth = depth + 1
      }
      if (in_presets && !in_selected && depth == presets_depth &&
          index(line, "\"" selected_preset "\"") && line ~ /:[[:space:]]*\{/) {
        in_selected = 1
        selected_depth = depth + 1
      }
      if (in_selected && !in_fixer && depth == selected_depth &&
          line ~ /"fixer"[[:space:]]*:[[:space:]]*\{/) {
        in_fixer = 1
        fixer_depth = depth + 1
      }
      if (in_fixer && depth == fixer_depth &&
          line ~ /"variant"[[:space:]]*:[[:space:]]*"xhigh"/) {
        sub(/"xhigh"/, "\"low\"", line)
        replacements++
      }

      print line
      depth += brace_delta(line)

      if (in_fixer && depth < fixer_depth) {
        in_fixer = 0
      }
      if (in_selected && depth < selected_depth) {
        in_selected = 0
        in_fixer = 0
      }
      if (in_presets && depth < presets_depth) {
        in_presets = 0
        in_selected = 0
        in_fixer = 0
      }
    }
    END {
      if (replacements != 1) {
        exit 42
      }
    }
  ' "$config_file" > "$temp_file"; then
    rm -f "$temp_file"
    die "expected exactly one xhigh Luna fixer variant in $selected_preset preset"
  fi

  mv "$temp_file" "$config_file"
}

read_role_config() {
  local config_file="$1" selected_preset="$2" role="$3"
  awk -v selected_preset="$selected_preset" -v role="$role" '
    function brace_delta(text, opens, closes) {
      opens = text
      closes = text
      return gsub(/\{/, "", opens) - gsub(/\}/, "", closes)
    }
    function json_value(line, value) {
      value = line
      sub(/^[^:]*:[[:space:]]*"/, "", value)
      sub(/".*$/, "", value)
      return value
    }
    BEGIN {
      depth = 0
      in_presets = 0
      in_selected = 0
      in_role = 0
      model_count = 0
      variant_count = 0
    }
    {
      line = $0

      if (!in_presets && line ~ /"presets"[[:space:]]*:[[:space:]]*\{/) {
        in_presets = 1
        presets_depth = depth + 1
      }
      if (in_presets && !in_selected && depth == presets_depth &&
          index(line, "\"" selected_preset "\"") && line ~ /:[[:space:]]*\{/) {
        in_selected = 1
        selected_depth = depth + 1
      }
      if (in_selected && !in_role && depth == selected_depth &&
          index(line, "\"" role "\"") && line ~ /:[[:space:]]*\{/) {
        in_role = 1
        role_depth = depth + 1
      }
      if (in_role && depth == role_depth && line ~ /"model"[[:space:]]*:/) {
        model = json_value(line)
        model_count++
      }
      if (in_role && depth == role_depth && line ~ /"variant"[[:space:]]*:/) {
        variant = json_value(line)
        variant_count++
      }

      depth += brace_delta(line)

      if (in_role && depth < role_depth) {
        in_role = 0
      }
      if (in_selected && depth < selected_depth) {
        in_selected = 0
        in_role = 0
      }
      if (in_presets && depth < presets_depth) {
        in_presets = 0
        in_selected = 0
        in_role = 0
      }
    }
    END {
      if (model_count != 1 || variant_count != 1) {
        exit 42
      }
      print model "|" variant
    }
  ' "$config_file"
}

read_guard_mode() {
  local config_file="$1"
  awk '
    function brace_delta(text, opens, closes) {
      opens = text
      closes = text
      return gsub(/\{/, "", opens) - gsub(/\}/, "", closes)
    }
    function json_value(line, value) {
      value = line
      sub(/^[^:]*:[[:space:]]*"/, "", value)
      sub(/".*$/, "", value)
      return value
    }
    BEGIN {
      depth = 0
      in_guard = 0
      mode_count = 0
    }
    {
      line = $0
      if (!in_guard && line ~ /"workflow_guard"[[:space:]]*:[[:space:]]*\{/) {
        in_guard = 1
        guard_depth = depth + 1
      }
      if (in_guard && depth == guard_depth && line ~ /"mode"[[:space:]]*:/) {
        mode = json_value(line)
        mode_count++
      }
      depth += brace_delta(line)
      if (in_guard && depth < guard_depth) {
        in_guard = 0
      }
    }
    END {
      if (mode_count != 1) {
        exit 42
      }
      print mode
    }
  ' "$config_file"
}

validate_config() {
  local config_file="$1" guard_file="$2"
  local route_data actual_model actual_variant actual_guard

  if ! route_data="$(read_role_config "$config_file" "$preset" orchestrator)"; then
    die "config validation failed: orchestrator route missing or duplicated"
  fi
  actual_model="${route_data%%|*}"
  actual_variant="${route_data#*|}"
  [[ "$actual_model" == "$orch_model" && "$actual_variant" == "$orch_variant" ]] ||
    die "config validation failed: orchestrator is $actual_model $actual_variant"
  orch_model_actual="$actual_model"
  orch_variant_actual="$actual_variant"

  if ! route_data="$(read_role_config "$config_file" "$preset" explorer)"; then
    die "config validation failed: explorer route missing or duplicated"
  fi
  actual_model="${route_data%%|*}"
  actual_variant="${route_data#*|}"
  [[ "$actual_model" == "$explorer_model" && "$actual_variant" == "$explorer_variant" ]] ||
    die "config validation failed: explorer is $actual_model $actual_variant"
  explorer_model_actual="$actual_model"
  explorer_variant_actual="$actual_variant"

  if ! route_data="$(read_role_config "$config_file" "$preset" fixer)"; then
    die "config validation failed: fixer route missing or duplicated"
  fi
  actual_model="${route_data%%|*}"
  actual_variant="${route_data#*|}"
  [[ "$actual_model" == "$fixer_model" && "$actual_variant" == "$fixer_variant" ]] ||
    die "config validation failed: fixer is $actual_model $actual_variant"
  fixer_model_actual="$actual_model"
  fixer_variant_actual="$actual_variant"

  if ! actual_guard="$(read_guard_mode "$guard_file")"; then
    die "config validation failed: workflow_guard.mode missing or duplicated"
  fi
  [[ "$actual_guard" == "disabled" ]] ||
    die "config validation failed: workflow_guard.mode is $actual_guard"
  guard_mode_actual="$actual_guard"
}

# Parse arguments.
preset=""
dry_run=0
allow_go=0
reset_after=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    openai|opencode-go|mixed-fable)
      [[ -z "$preset" ]] || die "preset specified more than once"
      preset="$1"
      shift
      ;;
    --dry-run)
      dry_run=1
      shift
      ;;
    --allow-go)
      allow_go=1
      shift
      ;;
    --reset-after)
      reset_after=1
      shift
      ;;
    *)
      die "unknown option: $1"
      ;;
  esac
done

[[ -n "$preset" ]] || die "preset required: openai | opencode-go | mixed-fable"
if [[ "$preset" == "opencode-go" && $allow_go -eq 0 ]]; then
  die "opencode-go preset requires --allow-go flag (uses Go quota)"
fi

# Resolve and validate the mothership worktree.
repo="${MOTHERSHIP_DEMO_REPO:-$DEFAULT_REPO}"
[[ -d "$repo" ]] || die "worktree does not exist: $repo"
repo="$(cd "$repo" && pwd -P)"
actual_root="$(git -C "$repo" rev-parse --show-toplevel 2>/dev/null)" ||
  die "not a git worktree: $repo"
actual_root="$(cd "$actual_root" && pwd -P)"
[[ "$actual_root" == "$repo" ]] || die "path is not the repository root: $repo"

fetch_remote="$(git -C "$repo" config --get remote.origin.url || true)"
push_remote="$(git -C "$repo" config --get remote.origin.pushurl || true)"
[[ -n "$push_remote" ]] || push_remote="$fetch_remote"
[[ "$fetch_remote" == "$EXPECTED_REMOTE" && "$push_remote" == "$EXPECTED_REMOTE" ]] ||
  die "unexpected origin remote for $repo"

[[ "$(git -C "$repo" cat-file -t "$BASELINE" 2>/dev/null || true)" == "commit" ]] ||
  die "baseline commit does not exist: $BASELINE"
git -C "$repo" show-ref --verify --quiet "refs/heads/$DEMO_BRANCH" ||
  die "demo branch does not exist: $DEMO_BRANCH"

git -C "$repo" diff --quiet || die "repo has uncommitted changes"
git -C "$repo" diff --cached --quiet || die "repo has staged changes"
[[ -z "$(git -C "$repo" status --porcelain)" ]] || die "repo has untracked changes"

current_branch="$(git -C "$repo" branch --show-current)"
current_head="$(git -C "$repo" rev-parse HEAD)"
[[ "$current_branch" == "$DEMO_BRANCH" ]] || die "not on $DEMO_BRANCH, on $current_branch"
[[ "$current_head" == "$BASELINE" ]] || die "not at exact baseline $BASELINE (at $current_head)"

# Intended routes are used only as validation expectations. Displayed routes are
# read back from the copied config after construction and overrides.
orch_model=""
orch_variant=""
explorer_model=""
explorer_variant=""
fixer_model=""
fixer_variant=""
case "$preset" in
  openai)
    orch_model="openai/gpt-5.6-sol"
    orch_variant="medium"
    explorer_model="github-copilot/gpt-5.4-mini"
    explorer_variant="low"
    fixer_model="openai/gpt-5.6-luna"
    fixer_variant="low"
    ;;
  opencode-go)
    orch_model="opencode-go/minimax-m3"
    orch_variant="thinking"
    explorer_model="opencode-go/deepseek-v4-flash"
    explorer_variant="high"
    fixer_model="opencode-go/deepseek-v4-flash"
    fixer_variant="high"
    ;;
  mixed-fable)
    orch_model="anthropic/claude-fable-5"
    orch_variant="high"
    explorer_model="github-copilot/gpt-5.4-mini"
    explorer_variant="low"
    fixer_model="openai/gpt-5.6-luna"
    fixer_variant="low"
    ;;
esac

[[ -f "$DEMO_DIR/prompt.txt" ]] || die "prompt.txt not found"
prompt_content="$(< "$DEMO_DIR/prompt.txt")"
[[ -f "$GLOBAL_OPENCODE_CONFIG" ]] || die "global opencode.json not found: $GLOBAL_OPENCODE_CONFIG"
[[ -d "$GLOBAL_OPENCODE_DIR" ]] || die "global opencode config dir not found: $GLOBAL_OPENCODE_DIR"
[[ -f "$GLOBAL_OPENCODE_DIR/oh-my-opencode-slim.jsonc" ]] ||
  die "global OMO config not found: $GLOBAL_OPENCODE_DIR/oh-my-opencode-slim.jsonc"

# Construct the same owned config for both dry-run and actual mode.
tmp_root="${TMPDIR:-/tmp}"
[[ -d "$tmp_root" ]] || die "TMPDIR does not exist: $tmp_root"
tmp_root="${tmp_root%/}"
[[ -n "$tmp_root" ]] || tmp_root="/"
RUN_PRESET_OWN_OPENCODE_CONFIG_DIR="$(mktemp -d "$tmp_root/run-preset.XXXXXX")" ||
  die "could not create owned config directory under $tmp_root"
chmod 700 "$RUN_PRESET_OWN_OPENCODE_CONFIG_DIR"

for config_file in "$GLOBAL_OPENCODE_DIR"/*; do
  [[ -e "$config_file" || -L "$config_file" ]] || continue
  filename="$(basename "$config_file")"
  case "$filename" in
    oh-my-opencode-slim.jsonc|systematic.jsonc) continue ;;
  esac
  ln -s "$config_file" "$RUN_PRESET_OWN_OPENCODE_CONFIG_DIR/$filename"
done

OMO_CONFIG="$RUN_PRESET_OWN_OPENCODE_CONFIG_DIR/oh-my-opencode-slim.jsonc"
cp "$GLOBAL_OPENCODE_DIR/oh-my-opencode-slim.jsonc" "$OMO_CONFIG"
cat > "$RUN_PRESET_OWN_OPENCODE_CONFIG_DIR/systematic.jsonc" <<EOF
{
  "workflow_guard": {
    "mode": "disabled"
  }
}
EOF

luna_override_message=""
if [[ "$preset" == "openai" || "$preset" == "mixed-fable" ]]; then
  override_luna_variant "$OMO_CONFIG" "$preset"
  luna_override_message="Luna fixer override: xhigh -> low (1 replacement)"
fi

export OPENCODE_CONFIG="$GLOBAL_OPENCODE_CONFIG"
export OPENCODE_CONFIG_DIR="$RUN_PRESET_OWN_OPENCODE_CONFIG_DIR"
export OH_MY_OPENCODE_SLIM_PRESET="$preset"

validate_config "$OMO_CONFIG" "$RUN_PRESET_OWN_OPENCODE_CONFIG_DIR/systematic.jsonc"

if [[ $dry_run -eq 1 ]]; then
  printf 'DRY-RUN: %s\n' "$preset"
  printf '  Config dir: %s\n' "$RUN_PRESET_OWN_OPENCODE_CONFIG_DIR"
  printf '  OMO config: %s\n' "$OMO_CONFIG"
  printf '  orchestrator %s %s\n' "$orch_model_actual" "$orch_variant_actual"
  printf '  explorer %s %s\n' "$explorer_model_actual" "$explorer_variant_actual"
  printf '  fixer %s %s\n' "$fixer_model_actual" "$fixer_variant_actual"
  [[ -z "$luna_override_message" ]] || printf '  %s\n' "$luna_override_message"
  printf '  Guard mode: "%s"\n' "$guard_mode_actual"
  printf '  Config validation: OK\n'
  printf '  Repo: %s\n' "$repo"
  printf '  Branch: %s\n' "$current_branch"
  printf '  HEAD: %s\n' "$current_head"
  printf '  Prompt path: %s/prompt.txt\n' "$DEMO_DIR"
  printf '  Log path: not created during dry-run\n'
  exit 0
fi

log_path="$(mktemp "/tmp/demo-preset-${preset}.XXXXXX")" ||
  die "could not create durable log"
chmod 600 "$log_path" || die "could not protect durable log: $log_path"
printf 'Config dir: %s\n' "$RUN_PRESET_OWN_OPENCODE_CONFIG_DIR"
printf 'Log path: %s\n' "$log_path"
RUN_PRESET_EXECUTION_STARTED=1
printf 'Running preset %s with validated copied config\n' "$preset"
set +e
(
  cd "$repo"
  /usr/bin/time -p opencode run \
    --format json \
    --title "Cheap LLMs ($preset)" \
    "$prompt_content" 2>&1 | tee "$log_path"
  pipeline_status=("${PIPESTATUS[@]}")
  opencode_exit="${pipeline_status[0]}"
  tee_exit="${pipeline_status[1]}"
  if [[ "$opencode_exit" -ne 0 ]]; then
    exit "$opencode_exit"
  fi
  exit "$tee_exit"
)
pipeline_exit="$?"
set -e
[[ "$pipeline_exit" == "0" ]] || exit "$pipeline_exit"

printf '\n\nVerifying: bun test src/app/StartupHandshake.test.ts -t LiveServerStatus\n'
(
  cd "$repo"
  bun test src/app/StartupHandshake.test.ts -t LiveServerStatus
)

(
  cd "$repo"
  git diff --check
)

post_run_porcelain="$(git -C "$repo" status --porcelain)"
[[ "$post_run_porcelain" == " M src/app/StartupHandshake.tsx" ]] ||
  die "expected exact post-run porcelain [ M src/app/StartupHandshake.tsx], got: $post_run_porcelain"

if [[ $reset_after -eq 1 ]]; then
  perform_reset_after 0
  RUN_PRESET_EXECUTION_STARTED=0
  [[ "$RUN_PRESET_FINAL_STATUS" -eq 0 ]] || exit "$RUN_PRESET_FINAL_STATUS"
fi

printf '\n✅ Preset %s completed GREEN\n' "$preset"
