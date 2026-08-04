#!/usr/bin/env bash
set -euo pipefail

readonly DEFAULT_REPO="/Users/mrbrown/src/github.com/marcusrbrown/.demo-workspaces/cccc-aug-2026/mothership-base/.worktrees/demo/cccc-aug-2026"
readonly EXPECTED_REMOTE="git@github.com:marcusrbrown/mothership.git"
readonly DEMO_BRANCH="demo/cccc-aug-2026"
readonly BASELINE="bdd1b1b99fa630bb87472e2f714d6505c8eaf6ed"

die() {
  printf 'reset-demo: %s\n' "$*" >&2
  exit 1
}

repo="${MOTHERSHIP_DEMO_REPO:-$DEFAULT_REPO}"
[[ -d "$repo" ]] || die "worktree does not exist: $repo"
repo="$(cd "$repo" && pwd -P)"

actual_root="$(git -C "$repo" rev-parse --show-toplevel 2>/dev/null)" ||
  die "not a git worktree: $repo"
actual_root="$(cd "$actual_root" && pwd -P)"
[[ "$actual_root" == "$repo" ]] ||
  die "path is not the repository root: $repo"

fetch_remote="$(git -C "$repo" config --get remote.origin.url || true)"
push_remote="$(git -C "$repo" config --get remote.origin.pushurl || true)"
[[ -n "$push_remote" ]] || push_remote="$fetch_remote"
[[ "$fetch_remote" == "$EXPECTED_REMOTE" && "$push_remote" == "$EXPECTED_REMOTE" ]] ||
  die "unexpected origin remote for $repo"

[[ "$(git -C "$repo" cat-file -t "$BASELINE" 2>/dev/null || true)" == "commit" ]] ||
  die "baseline commit does not exist: $BASELINE"
git -C "$repo" show-ref --verify --quiet "refs/heads/$DEMO_BRANCH" ||
  die "demo branch does not exist: $DEMO_BRANCH"

git -C "$repo" checkout "$DEMO_BRANCH"
git -C "$repo" reset --hard "$BASELINE"

printf 'branch=%s sha=%s\n' \
  "$(git -C "$repo" branch --show-current)" \
  "$(git -C "$repo" rev-parse HEAD)"
printf 'RED: (cd %q && bun test src/app/StartupHandshake.test.ts -t '\''LiveServerStatus'\'')\n' "$repo"
