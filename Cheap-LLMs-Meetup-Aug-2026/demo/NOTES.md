# Demo notes

- **Selected repo/task:** `marcusrbrown/mothership`; `LiveServerStatus` is already
  extracted. Add the visible, accessible `Retry` button, require an `onRetry`
  prop, and wire it to the existing retry callback only for failed status.
- **Reset target:**
  `/Users/mrbrown/src/github.com/marcusrbrown/.demo-workspaces/cccc-aug-2026/mothership-base/.worktrees/demo/cccc-aug-2026`
  on `demo/cccc-aug-2026`, baseline
  `bdd1b1b99fa630bb87472e2f714d6505c8eaf6ed`.
- **Root cause:** after a terminal post-connect supervisor failure, the
  connected shell remains mounted and the failed live-status chip exposes no
  retry action; recovery already exists via `retry()`/`attempt()` but is
  inaccessible in that state.
- **RED:** `bun test src/app/StartupHandshake.test.ts -t 'LiveServerStatus'` — focused
  tests at the new baseline: `1` pass / `1` fail in `0.21s`, failing specifically
  on missing `type="button"`; lint and typecheck pass.
- Disposable GREEN probe passed focused `LiveServerStatus` tests, the full Bun suite,
  typecheck, and lint after formatting correction.
- `reset-demo.sh` is configured to restore clean branch `demo/cccc-aug-2026` at
  exact baseline `bdd1b1b99fa630bb87472e2f714d6505c8eaf6ed`.
- At the new baseline, the focused `LiveServerStatus` tests are `1` pass / `1` fail
  in `0.21s`, failing specifically on missing `type="button"`; lint and typecheck pass.
- Local implementation/reset verification only; not a timed preset rehearsal.

## 2026-08-04 — button-only baseline

- Commit `bdd1b1b99fa630bb87472e2f714d6505c8eaf6ed` (`refactor(app): extract live server status`).
  The behavior-preserving extraction is staged to reduce implementation scope.
- **Unresolved config/deck drift:** actual `openai` is Sol/Opus while the deck
  says Terra/Sonnet; the deck's low-variant route differs from the current
  configuration; OMO schema URL is `1.1.2` while `v2.2.x` is expected.
- The pre-styling functional prompt measured OpenAI `76.53s`, `opencode-go`
  `80.49s`, and `mixed-fable` `82.82s`; all met the 90-second target. The prompt
  now includes an exact minimal token-style contract, so timing needs a spot
  recheck before claiming those numbers for the final prompt.
- Disposable GREEN implementation changed only `StartupHandshake.tsx`: `26` insertions / `2` deletions.
- Focused GREEN verification: `2` pass / `0` fail in `0.04s`; lint `0.08s`; typecheck `1.56s`.
- `reset-demo.sh` restored the exact clean baseline `bdd1b1b99fa630bb87472e2f714d6505c8eaf6ed`.
- Post-reset button-only RED verification: `1` pass / `1` fail on missing `type="button"` in `0.05s`; lint `0.11s` and typecheck `1.46s` passed.
- This staging proof used no Go quota and is not yet a timed preset rehearsal.

## 2026-08-03 — openai-preset rehearsal

- Fresh OpenCode `1.18.5` run under the active `openai` preset with default model
  routing. Wall-clock: `857.35s` (`14m 17.35s`); user: `92.62s`; sys: `39.50s`.
- Successful temporary commit `83c6b54dcf4de2146a8bac9cc3fa25b3e521ab9d`
  (`fix(app): refactor live server status indicator`); only
  `StartupHandshake.tsx` changed.
- Independent verification passed: focused tests `2` passed, full suite `435`
  passed, and typecheck/lint passed. Reset restored clean RED baseline
  `805d6c1e6714c143610695e0e9cdf3a40ff903b0`; post-reset RED focused test:
  `0.17s`, lint: `0.19s`, typecheck: `1.75s`.
- The 90-second target **failed**. Phase timing was about `54.5s`, `339.0s`, and
  `368.6s`; local checks take only a few seconds, so execution and harness
  latency plus serial orchestration dominate.

## 2026-08-03 — valid optimized openai rehearsal

- Wall-clock: `184.80s` (`3m 4.80s`); user: `30.28s`; sys: `11.07s`.
- Concurrent implementation work completed about `117.7s` after commentary.
  Startup and required skills took about `24.4s` to commentary; focused
  verification/commit/finalization took about `30.1s` post-work.
- Temporary commit `1b32cc97083046ecdf45db92383937e689fc64c5`
  (`fix(app): expose failed-server retry action`); only `StartupHandshake.tsx`
  changed. Independent focused verification: `2` passed in `0.06s`.
- The 90-second target still **failed**, although runtime improved by
  `672.55s` (`~78.4%`) from `857.35s`.
- Worktree restored to the clean RED baseline.

## 2026-08-04 — button-only openai rehearsal

- Wall-clock: `247.19s` (`4m 7.19s`); user: `36.23s`; sys: `18.17s`.
- Active `openai` preset with concurrent implementation work. Only
  `StartupHandshake.tsx` changed: `26` insertions / `2` deletions. Temporary
  commit `a798e6293c4f46f61c11af283374ea986db78197`
  (`fix(app): expose failed-server retry action`). Focused verification: `2`
  pass in `0.09s`.
- Timing evidence: required skill loading took about `10.5s` and first
  commentary appeared around `16.3s`; the parallel work completed around
  `120.2s` after commentary; post-work verification/commit/finalization took
  about `96.7s`.
- The 90-second target failed, and scope reduction did not improve runtime
  versus the prior `184.80s` run, disproving code size as the primary
  bottleneck.
- Reset restored the exact clean RED baseline
  `bdd1b1b99fa630bb87472e2f714d6505c8eaf6ed`.

**Conclusion:** the demo format should avoid routing/control overhead that
dominates the measured implementation work.

## 2026-08-04 — Luna-low rehearsal

- Valid foreground rehearsal. Wall-clock: `106.02s` (`1m 46.02s`); user:
  `22.35s`; sys: `7.54s`.
- The process-local config routed `openai/gpt-5.6-luna` at `low`, preserved the
  normal global plugin config, and was deleted after the process exited.
- Concurrent foreground implementation work completed about `70.2s` after the
  first OpenCode event.
- Post-work verification/finalization added about `26.8s`; the actual focused
  test and diff check took only `0.101s`.
- The implementation changed only `StartupHandshake.tsx`: `17` insertions /
  `2` deletions.
  Independent focused verification passed `2` tests in `0.05s`; the temporary
  configuration was removed; reset restored the exact clean RED baseline
  `bdd1b1b99fa630bb87472e2f714d6505c8eaf6ed`.
- Runtime improved by `141.17s` (`~57.1%`) versus the prior `247.19s` run, but
  still missed the 90-second target by `16.02s`.
- Visual caveat: the minimal Luna-low implementation used an unstyled native
  button. Browser rendering was not validated.

## 2026-08-04 — successful OpenAI timing

- Wall-clock: `76.53s`; user: `16.92s`; sys: `5.99s`.
- Process-local routing used `openai/gpt-5.6-luna` at `low`. Both temporary
  overrides were removed after the process exited; global and repository config
  were unchanged.
- Concurrent foreground implementation work completed about `54.0s` after the
  first OpenCode event; finalization took about `7.4s`.
- RED was `1` pass / `1` fail and GREEN was `2` pass / `0` fail. Only
  `StartupHandshake.tsx` changed (`17` insertions / `2` deletions).
- Independent post-timer verification passed the focused tests in `0.07s` and
  `git diff --check`; reset restored exact clean RED baseline
  `bdd1b1b99fa630bb87472e2f714d6505c8eaf6ed`.
- The 90-second target **passed with `13.47s` margin**.
- Visual caveat remains: this minimal implementation renders an unstyled native
  button; browser rendering is not yet validated.

## 2026-08-04 — Go rehearsal policy

- Published Go plan limits used in the talk: `$12/5h`, `$30/week`, `$60/month`.
- Rehearsal policy: run one real Go rehearsal, then use simulated fallbacks.

## 2026-08-04 — OpenCode Go rehearsal

- Initial Go rehearsal: Wall-clock: `31.87s`; no code changed. The selected
  DeepSeek worker model/family was not enabled for the workspace, so the worker
  attempts returned non-retryable `403` responses.
- The selected Go worker model/family was enabled in the workspace before the
  authorized retry.
- Successful authorized retry: Wall-clock: `80.49s`; user: `21.37s`; sys:
  `6.28s`.
- Model routing: primary `opencode-go/minimax-m3` (`thinking`); selected worker
  model `opencode-go/deepseek-v4-flash` (`high`).
- Concurrent work completed about `64.8s` after the first OpenCode event; the
  final event arrived at `67.6s`.
- RED was `1` pass / `1` fail and GREEN was `2` pass / `0` fail. Only
  `StartupHandshake.tsx` changed (`17` insertions / `2` deletions).
- Independent post-timer verification passed the focused tests in `0.06s` and
  `git diff --check`; temporary config was removed and reset restored exact
  clean RED baseline `bdd1b1b99fa630bb87472e2f714d6505c8eaf6ed`.
- The 90-second target **passed with `9.51s` margin**.

## 2026-08-04 — mixed-fable rehearsal

- Wall-clock: `82.82s`; user: `15.57s`; sys: `7.28s`.
- Model routing: primary `anthropic/claude-fable-5` (`high`), worker models
  `github-copilot/gpt-5.4-mini` (`low`) and
  `openai/gpt-5.6-luna` (`low`).
- Concurrent work ended about `61.1s` after the first OpenCode event; the final
  event arrived around `66.7s`.
- The full `StartupHandshake.test.ts` file ran instead of the exact two-test
  filter, reporting RED `4` pass / `1` fail and GREEN `5` pass / `0` fail. It
  still failed and fixed the intended missing `type="button"` assertion. The
  live prompt should provide the literal command
  `bun test src/app/StartupHandshake.test.ts -t LiveServerStatus`.
- Only `StartupHandshake.tsx` changed (`17` insertions / `2` deletions).
  Independent exact-filter verification passed `2` tests in `0.06s` and
  `git diff --check`; temporary config was removed and reset restored exact
  clean RED baseline `bdd1b1b99fa630bb87472e2f714d6505c8eaf6ed`.
- The 90-second target **passed with `7.18s` margin**.

## Pre-styling verified three-preset timing matrix

| Preset | Wall-clock | Margin under 90s |
| --- | ---: | ---: |
| `openai` | `76.53s` | `13.47s` |
| `opencode-go` | `80.49s` | `9.51s` |
| `mixed-fable` | `82.82s` | `7.18s` |

- Mean: `79.95s`; spread: `6.29s`.
- Shared successful shape: exact RED baseline, temporary config, concurrent
  foreground work, terminal-results-only timing, no commit choreography, then
  independent verification and reset outside the timer.
- OpenAI and mixed-fable use `openai/gpt-5.6-luna` at `low`; Go keeps its
  configured DeepSeek V4 Flash `high` worker model, which must be enabled in the
  workspace.

## 2026-08-04 — prompt-faithful visual verification

- The first visual pass was rejected because the fixture temporarily added
  styling that the live prompt did not require. Those screenshots were not
  accepted as evidence.
- `prompt.txt` now requires one exact minimal inline style object using existing
  tokens: error background, dark text, dark one-pixel border, existing radius
  and spacing, inherited font, bold weight, pointer cursor, and `2px` native
  outline offset. It explicitly forbids margin, `outline: none`, focus/blur
  scripting, box-shadow focus scripting, and transitions.
- `run-preset.test.sh` was updated test-first: the new prompt assertions failed
  before the prompt change, then the complete Bash 3.2 suite passed GREEN.
- Headless verification rendered the exact updated prompt output with the real
  component and global design tokens at `1280x577`; the final headless
  screenshots were retained as local, git-excluded verification artifacts and
  are not part of the repository or PR.
- Visual verdict: **PASS**. The button fits the failed chip, preserves the
  existing flex gap, has approximately `10.4:1` text contrast, and shows a
  visible native keyboard-focus outline. Browser console: zero errors/warnings.
- Temporary spike files and the Vite process were removed. Reset restored exact
  clean RED baseline `bdd1b1b99fa630bb87472e2f714d6505c8eaf6ed`.

## 2026-08-04 — final styled mixed-fable spot check

- Ran the final prompt through the durable runner itself:
  `run-preset.sh mixed-fable --reset-after`.
- Wall-clock: `84.35s`; user: `18.80s`; sys: `5.71s`.
- The final styled prompt passed the 90-second target with `5.65s` margin. This
  is `1.53s` slower than the pre-styling mixed-fable run (`82.82s`).
- The required first/only foreground parallel batch reported RED `1` pass / `1`
  fail and GREEN `2` pass / `0` fail, with only `StartupHandshake.tsx` changed
  and the exact token-style contract applied.
- The runner independently passed the exact focused test (`2` pass / `0` fail),
  `git diff --check`, and the one-file scope check, then `--reset-after`
  restored exact clean RED baseline
  `bdd1b1b99fa630bb87472e2f714d6505c8eaf6ed`.
- This end-to-end run also verified actual-mode copied config, Luna `low`
  override, persistent logging, exit propagation, post-timer verification, and
  automatic reset.
- OpenAI and Go retain their pre-styling measurements (`76.53s` and `80.49s`).
  They were not rerun; the final styled prompt has direct timing evidence under
  the previously slowest preset only.

## Preset runner

```bash
# Validate routing and config without invoking a model
./Cheap-LLMs-Meetup-Aug-2026/demo/run-preset.sh openai --dry-run
./Cheap-LLMs-Meetup-Aug-2026/demo/run-preset.sh mixed-fable --dry-run
./Cheap-LLMs-Meetup-Aug-2026/demo/run-preset.sh opencode-go --allow-go --dry-run

# Run and leave the GREEN diff for inspection
./Cheap-LLMs-Meetup-Aug-2026/demo/run-preset.sh openai
./Cheap-LLMs-Meetup-Aug-2026/demo/run-preset.sh mixed-fable
./Cheap-LLMs-Meetup-Aug-2026/demo/run-preset.sh opencode-go --allow-go

# Rehearsal mode: verify, then restore RED automatically
./Cheap-LLMs-Meetup-Aug-2026/demo/run-preset.sh openai --reset-after
```

- `run-preset.sh` refuses the wrong repository, remote, branch, HEAD, dirty
  state, or Go run without explicit `--allow-go`.
- Dry-run constructs and validates the same temporary copied config as a real
  run, but a fake-opencode regression test proves it invokes no model.
- Temporary config is removed on every exit; rehearsal logs persist after
  cleanup.
- Real runs independently execute the exact focused test, `git diff --check`,
  and the one-file scope check after timing. The default leaves GREEN for live
  inspection; `--reset-after` calls `reset-demo.sh` only after verification.
- `/bin/bash` 3.2 contract tests cover routing, Luna overrides, cleanup
  ownership, baseline preservation, prompt constraints, and nonzero
  OpenCode exit propagation.
