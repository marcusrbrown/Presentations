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
- Local implementation/reset verification only; not a timed preset/orchestrator rehearsal.
- No Go quota used.

## 2026-08-04 — button-only baseline

- Commit `bdd1b1b99fa630bb87472e2f714d6505c8eaf6ed` (`refactor(app): extract live server status`).
  The behavior-preserving extraction is staged to reduce implementation scope.
- **Unresolved config/deck drift:** actual `openai` is Sol/Opus while the deck
  says Terra/Sonnet; Systematic review routes to GPT-5.5 low while the deck says
  Terra; OMO schema URL is `1.1.2` while `v2.2.x` is expected.
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

- Fresh OpenCode `1.18.5` run under the active `openai` preset, with no model or
  agent override. Wall-clock: `857.35s` (`14m 17.35s`); user: `92.62s`; sys:
  `39.50s`. Log: `/tmp/mothership-openai-rehearsal-20260803T191641Z.log`.
- Agents visibly used: `explorer`, `designer`, and `fast-generic`.
- Successful temporary commit `83c6b54dcf4de2146a8bac9cc3fa25b3e521ab9d`
  (`fix(app): refactor live server status indicator`); only
  `StartupHandshake.tsx` changed.
- Independent verification passed: focused tests `2` passed, full suite `435`
  passed, and typecheck/lint passed. Reset restored clean RED baseline
  `805d6c1e6714c143610695e0e9cdf3a40ff903b0`; post-reset RED focused test:
  `0.17s`, lint: `0.19s`, typecheck: `1.75s`.
- The 90-second target **failed**. Timestamp evidence: explorer serial phase
  about `54.5s`, designer phase about `339.0s`, and fast-generic phase about
  `368.6s`; local checks take only a few seconds, so subagent/model/harness
  latency and serial orchestration dominate.
- No Go quota used.

**Proposed next run (not verified):** run `explorer` read-only and `fixer`
implementation concurrently; omit `designer` and `fast-generic` from Beat 1;
then have the orchestrator run only the focused test and local commit. Reserve
`fast-generic`/full gates for Beat 2 or pre-demo verification.

## 2026-08-03 — valid optimized openai rehearsal

- Direct log: `/tmp/mothership-openai-optimized-direct-20260803T230543Z.log`.
  Wall-clock: `184.80s` (`3m 4.80s`); user: `30.28s`; sys: `11.07s`.
- `explorer` and `fixer` were dispatched concurrently in the first execution
  batch. Explorer completed about `20.6s` after dispatch commentary; the
  fixer/parallel batch completed about `117.7s` after commentary. Startup and
  required skills took about `24.4s` to commentary; focused
  verification/commit/finalization took about `30.1s` post-batch.
- Temporary commit `1b32cc97083046ecdf45db92383937e689fc64c5`
  (`fix(app): expose failed-server retry action`); only `StartupHandshake.tsx`
  changed. Independent focused verification: `2` passed in `0.06s`.
- The 90-second target still **failed**, although runtime improved by
  `672.55s` (`~78.4%`) from `857.35s`.
- Worktree restored to the clean RED baseline. No Go quota used.

Invalid measurement: `/tmp/mothership-openai-optimized-20260803T230444Z.log` reported `0.25s` but is excluded because its delegated runner performed agent/edit work before starting the timer.

**Proposed next step (not verified):** re-stage the baseline with the
behavior-preserving `LiveServerStatus` extraction already committed, leaving
only the failed-state `Retry` button/wiring as the RED implementation task,
then rerun parallel `explorer`+`fixer`; fixer/model latency may still keep it
above 90s.

## 2026-08-04 — button-only openai rehearsal

- Log: `/tmp/mothership-openai-button-only-20260804T055322Z.log`. Wall-clock:
  `247.19s` (`4m 7.19s`); user: `36.23s`; sys: `18.17s`.
- Active `openai` preset with `explorer`+`fixer` concurrent. Only
  `StartupHandshake.tsx` changed: `26` insertions / `2` deletions. Temporary
  commit `a798e6293c4f46f61c11af283374ea986db78197`
  (`fix(app): expose failed-server retry action`). Focused verification: `2`
  pass in `0.09s`.
- Timing evidence: required skill loading took about `10.5s` and first
  commentary appeared around `16.3s`; the parallel lane completed around
  `120.2s` after commentary, dominated by `fixer`; post-lane
  verification/commit/guard/finalization took about `96.7s`.
- The protected workflow guard repeatedly rejected or blocked transitions
  (`forbidden-field`, `unit-active`, then missing verification evidence) and
  added substantial post-commit overhead. This run used Systematic `3.5.9`.
- The 90-second target failed, and scope reduction did not improve runtime
  versus the prior `184.80s` run, disproving code size as the primary
  bottleneck.
- Reset restored the exact clean RED baseline
  `bdd1b1b99fa630bb87472e2f714d6505c8eaf6ed`. No Go quota used.

**Conclusion:** do not spend Go quota until routing/control overhead is changed
or the demo format changes.

## 2026-08-04 — fast demo config research

- OpenCode is `1.18.5`; the global plugin list pins
  `oh-my-opencode-slim@1.1.2` and `@fro.bot/systematic@3.5.9`. OMO's managed
  skills manifest reports `2.2.8`, so runtime package versus managed-skill
  versioning remains ambiguous. The required agent fields and
  `OH_MY_OPENCODE_SLIM_PRESET` exist in both inspected OMO versions.
- The current `openai` fixer is `openai/gpt-5.6-luna` at `xhigh`. Luna supports
  `none`, `low`, `medium`, `high`, `xhigh`, and `max`; `gpt-5.4-mini` at `low`
  is also available.
- OMO user and project config deep-merge. A partial
  `presets.openai.fixer.variant` override is valid for the existing preset; a
  new preset cannot inherit and must define every role.
- Systematic `3.5.9` supports workflow-guard modes `observe`, `protected`, and
  `disabled`. The current user config is `protected`; project config cannot
  override that protected field, but trusted config under
  `OPENCODE_CONFIG_DIR` can.
- Do not inject `workflow_guard` through `OPENCODE_CONFIG_CONTENT`; it is not an
  OpenCode top-level config key.
- **Recommended reversible experiment:** use a temporary
  `OPENCODE_CONFIG_DIR` containing a copied full OMO config with only the
  `openai` fixer changed from `xhigh` to `low`, plus `systematic.jsonc` with
  `workflow_guard.mode` set to `disabled`. Point `OPENCODE_CONFIG` at the
  existing global `opencode.json`, set `OH_MY_OPENCODE_SLIM_PRESET=openai`, run
  a fresh process, then delete the temporary files.
- The timed prompt should stop at focused GREEN and omit commit/git-commit work;
  commit choreography belongs to Beat 2. The verified terminal-results-only run
  below confirms this configuration meets the timing target.
- Research changed no configuration and invoked no model rehearsal.

## 2026-08-04 — Luna-low, guard-disabled rehearsal

- Valid foreground log:
  `/tmp/mothership-openai-luna-low-foreground-20260804T165627Z.log`.
  Wall-clock: `106.02s` (`1m 46.02s`); user: `22.35s`; sys: `7.54s`.
- The process-local config routed `fixer` to `openai/gpt-5.6-luna` at `low`,
  disabled the Systematic workflow guard, preserved the normal global plugin
  config, and was deleted after the process exited.
- `explorer` and `fixer` ran concurrently as blocking foreground tasks. Explorer
  completed in about `35.8s`; fixer completed in about `49.3s`. The terminal
  parallel batch ended about `70.2s` after the first OpenCode event.
- Nested post-agent verification/finalization added about `26.8s`; the actual
  focused test and diff check took only `0.101s`.
- Fixer changed only `StartupHandshake.tsx`: `17` insertions / `2` deletions.
  Independent focused verification passed `2` tests in `0.05s`; the temporary
  configuration was removed; reset restored the exact clean RED baseline
  `bdd1b1b99fa630bb87472e2f714d6505c8eaf6ed`.
- Runtime improved by `141.17s` (`~57.1%`) versus the prior `247.19s` run, but
  still missed the 90-second target by `16.02s`.
- Visual caveat: the minimal Luna-low implementation used an unstyled native
  button. Browser rendering was not validated.
- Invalid launch-only measurement:
  `/tmp/mothership-openai-luna-low-20260804T165447Z.log` reported `48.35s`, but
  is excluded because the orchestrator launched both agents in the background
  and exited before either terminal result.
- No Go quota used.

**Recommended next measurement:** keep Luna `low` and the disabled guard, but
end the timed nested run immediately after both terminal agent results. Perform
the independent focused test outside the timed agent session. The measured
parallel batch completed with enough margin that this should approach or beat
90 seconds without changing model identity again.

## 2026-08-04 — successful OpenAI timing

- Log: `/tmp/mothership-openai-luna-low-terminal-20260804T170818Z.log`.
  Wall-clock: `76.53s`; user: `16.92s`; sys: `5.99s`.
- Process-local routing used `openai/gpt-5.6-luna` at `low` for `fixer` and
  disabled the Systematic workflow guard. Both temporary overrides were removed
  after the process exited; global and repository config were unchanged.
- `explorer` and `fixer` ran concurrently as blocking foreground tasks.
  Explorer completed in about `21.5s`; fixer completed in about `42.6s`; the
  terminal agent batch ended about `54.0s` after the first OpenCode event.
- The nested orchestrator immediately summarized the terminal results without a
  duplicate verification turn. Finalization after the agent batch took about
  `7.4s`.
- Fixer reported RED `1` pass / `1` fail and GREEN `2` pass / `0` fail. Only
  `StartupHandshake.tsx` changed (`17` insertions / `2` deletions).
- Independent post-timer verification passed the focused tests in `0.07s` and
  `git diff --check`; reset restored exact clean RED baseline
  `bdd1b1b99fa630bb87472e2f714d6505c8eaf6ed`.
- The 90-second target **passed with `13.47s` margin**. No Go quota used.
- Visual caveat remains: this minimal implementation renders an unstyled native
  button; browser rendering is not yet validated.

## 2026-08-04 — live OpenCode Go headroom

- Checked the authenticated Go workspace at `2026-08-04 10:33 PDT` without
  invoking a model.
- Rolling usage: `3%` used / `97%` remaining, resetting around
  `2026-08-04 15:10 PDT`. Against the stated `$12` rolling limit, that is about
  `$11.64` remaining; percentages are rounded by the console.
- Weekly usage: `5%` used / `95%` remaining, resetting around
  `2026-08-09 16:33 PDT`. Against `$30`, that is about `$28.50` remaining.
- Monthly usage: `61%` used / `39%` remaining, resetting around
  `2026-08-11 19:33 PDT`. Against `$60`, that is about `$23.40` remaining and is
  the binding window.
- Workspace Zen balance: `$35.34`. The console currently has “Use your available
  balance after reaching the usage limits” enabled, so exceeding Go limits can
  consume paid balance.
- Conclusion: sufficient headroom exists for the single measured Go rehearsal;
  do not run additional real Go rehearsals afterward. The quota check itself
  consumed no model quota.

## 2026-08-04 — OpenCode Go rehearsal

- Initial log: `/tmp/mothership-opencode-go-terminal-20260804T173512Z.log`.
  Wall-clock: `31.87s`; no code changed. Both `deepseek-v4-flash` subagents
  returned non-retryable `403 RegionError` responses because the workspace had
  China-hosted models disabled. Exact failed-attempt cost: `$0.02177004`.
- The user explicitly enabled China-hosted models in the Go workspace and
  authorized one retry. This account-level routing/privacy setting is now on.
- Successful log: `/tmp/mothership-opencode-go-retry-20260804T173823Z.log`.
  Wall-clock: `80.49s`; user: `21.37s`; sys: `6.28s`.
- Routing: orchestrator `opencode-go/minimax-m3` (`thinking`); explorer and
  fixer `opencode-go/deepseek-v4-flash` (`high`); Systematic workflow guard
  disabled in the temporary process config.
- Explorer and fixer ran concurrently. Their terminal batch completed about
  `64.8s` after the first OpenCode event; the final event arrived at `67.6s`.
- Fixer reported RED `1` pass / `1` fail and GREEN `2` pass / `0` fail. Only
  `StartupHandshake.tsx` changed (`17` insertions / `2` deletions).
- Independent post-timer verification passed the focused tests in `0.06s` and
  `git diff --check`; temporary config was removed and reset restored exact
  clean RED baseline `bdd1b1b99fa630bb87472e2f714d6505c8eaf6ed`.
- Successful-run cost across parent and subagent sessions: `$0.03578999`.
  Combined failed attempt plus successful retry: `$0.05756003`—about `0.48%`
  of the `$12` rolling limit.
- The 90-second target **passed with `9.51s` margin**. Do not run another real Go
  rehearsal; use simulated fallback only.

## 2026-08-04 — mixed-fable rehearsal

- Log: `/tmp/mothership-mixed-fable-terminal-20260804T174702Z.log`.
  Wall-clock: `82.82s`; user: `15.57s`; sys: `7.28s`.
- Routing: orchestrator `anthropic/claude-fable-5` (`high`), explorer
  `github-copilot/gpt-5.4-mini` (`low`), fixer `openai/gpt-5.6-luna` (`low`),
  and Systematic workflow guard disabled in the temporary process config.
- Explorer and fixer ran concurrently. The terminal agent batch ended about
  `61.1s` after the first OpenCode event; the final event arrived around
  `66.7s`.
- Fixer executed the whole `StartupHandshake.test.ts` file instead of the exact
  two-test filter, reporting RED `4` pass / `1` fail and GREEN `5` pass / `0`
  fail. It still failed and fixed the intended missing `type="button"`
  assertion. The live prompt should provide the literal command
  `bun test src/app/StartupHandshake.test.ts -t LiveServerStatus`.
- Only `StartupHandshake.tsx` changed (`17` insertions / `2` deletions).
  Independent exact-filter verification passed `2` tests in `0.06s` and
  `git diff --check`; temporary config was removed and reset restored exact
  clean RED baseline `bdd1b1b99fa630bb87472e2f714d6505c8eaf6ed`.
- The 90-second target **passed with `7.18s` margin**. This preset consumed no Go
  quota.

## Pre-styling verified three-preset timing matrix

| Preset | Wall-clock | Margin under 90s |
| --- | ---: | ---: |
| `openai` | `76.53s` | `13.47s` |
| `opencode-go` | `80.49s` | `9.51s` |
| `mixed-fable` | `82.82s` | `7.18s` |

- Mean: `79.95s`; spread: `6.29s`.
- Shared successful shape: exact RED baseline, guard-disabled temporary config,
  concurrent foreground explorer+fixer, terminal-results-only timing, no commit
  choreography, then independent verification and reset outside the timer.
- OpenAI and mixed-fable override Luna fixer from `xhigh` to `low`; Go keeps its
  configured DeepSeek V4 Flash `high` workers and requires China-hosted models
  enabled.

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
- Durable log: `/tmp/mothership-mixed-fable-20260804-191731.log`.
- Wall-clock: `84.35s`; user: `18.80s`; sys: `5.71s`.
- The final styled prompt passed the 90-second target with `5.65s` margin. This
  is `1.53s` slower than the pre-styling mixed-fable run (`82.82s`).
- Explorer and fixer ran in the required first/only foreground parallel batch.
  Fixer reported RED `1` pass / `1` fail and GREEN `2` pass / `0` fail, with
  only `StartupHandshake.tsx` changed and the exact token-style contract applied.
- The runner independently passed the exact focused test (`2` pass / `0` fail),
  `git diff --check`, and the one-file scope check, then `--reset-after`
  restored exact clean RED baseline
  `bdd1b1b99fa630bb87472e2f714d6505c8eaf6ed`.
- This end-to-end run also verified actual-mode copied config, Luna `low`
  override, durable `/tmp` logging, exit propagation, post-timer verification,
  and automatic reset. It consumed no Go quota.
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
- Temporary config is removed on every exit; rehearsal logs persist at
  `/tmp/mothership-<preset>-<UTC timestamp>.log`.
- Real runs independently execute the exact focused test, `git diff --check`,
  and the one-file scope check after timing. The default leaves GREEN for live
  inspection; `--reset-after` calls `reset-demo.sh` only after verification.
- `/bin/bash` 3.2 contract tests cover routing, Luna overrides, disabled guard,
  cleanup ownership, baseline preservation, prompt constraints, and nonzero
  OpenCode exit propagation.
