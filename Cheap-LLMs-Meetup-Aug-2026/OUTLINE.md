# $200 Intelligence on a $10 Budget: Kimi Models & More

*(title as posted by Jon on Meetup; internal hook: "I Pay $343/mo for AI So You Don't Have To")*

**Cracked Claude Cowork and Codex Club — Aug 4 & 5, 2026 (same talk, two nights)**
**Aug 4: Workuity, 2390 E Camelback Rd, Phoenix — 5:30–7:00 PM MST (guest slot within)**
**Format: 30 minutes (~15 slides / ~12 demo), + Q&A overflow · Deck: Slidev (`slides/`)**
**Speaker: Marcus R. Brown**

> Thesis: You don't pick *a* model, you pick a *mix*. One harness (OpenCode),
> preset-switchable model sets, budgets from $0 to maxed out — and even on Max,
> the cheap models earn their keep. Fallbacks come from provider diversity and
> multiple accounts you own, never shared logins.

---

## Timing map (30 min)

| Segment | Time | Mode |
|---|---|---|
| 1. Hook: the $343/mo confession | 3 min | slides |
| 2. State of the gap (benchmarks, honestly) | 3 min | slides |
| 3. The three budgets: $0 / $10 / Max | 6 min | slides |
| 4. Demo: one harness, every budget | 12 min | live |
| 5. Multiple accounts, one human: CLIProxyAPI + the crackdown | 4 min | slides + config |
| 6. Decision tree, privacy rule, takeaways | 2 min | slides |
| Q&A | overflow | — |

30-min compression notes: §6 (privacy) collapses to one rule on the closing
slide with the three-postures detail moved to speaker notes / Q&A ammo; demo
drops from 4 beats to 3 (Pantheon intro merges into the first preset switch);
crackdown timeline becomes one slide + scar-tissue slide. Everything cut stays
in speaker notes — the club runs 30–45 min discussion after, so Q&A depth matters
more than slide count.

---

## 1. Hook: the $343/mo confession (3 min)

- Receipts slide — what I actually pay, monthly-normalized:
  - Claude Max 20x — $200
  - ChatGPT Pro 5x — $100
  - GitHub Copilot annual — ~$33 (**barely touched since the June billing switch** — see §3)
  - OpenCode Go — $10
  - OpenCode Zen free models — $0 (available, currently unrouted)
- Punchline: the $10 line item does a shocking share of the work, and the $33 one
  does almost none. Price and value stopped correlating in 2026.
- Jon's framing vs mine: yes, the cheap tier is mostly Chinese labs (Kimi, GLM,
  DeepSeek, Qwen, MiniMax) — but the skill being taught tonight is *portfolio
  construction*, not model nationality. Even Max subscribers leave money on the
  table by not mixing.
- Tonight's promise: leave with a working $0 stack, a $10 stack, or a smarter
  version of the $200 stack you already pay for.

## 2. State of the gap — benchmarks, honestly (3 min)

- **Opening visual**: Artificial Analysis "Intelligence vs. Cost per Intelligence
  Index Task" scatter (Index v4.1, Aug 2026, `slides/images/`). DeepSeek V4 Flash
  hits index 50 at ~$0.03/task — GPT-5.6 Terra (high) needs ~$0.30 for the same
  score; Kimi K3 (max) lands 2 points under GPT-5.6 Sol (max) at a third of the
  price; effort variants of one model span 5–10x cost. ~100x cost range buys ~9
  index points. Caveats on stage: blended index (not coding-specific), API
  token costs (not subscription economics), filtered view without Anthropic
  models, log scale.

- SWE-bench Verified (July 2026): DeepSeek V4-Pro-Max, MiniMax M3, Qwen3.7 Max,
  Kimi K2.6 cluster at ~0.80; GLM-5 ~0.78 — roughly GPT-5.1 / Sonnet 4.6 class.
  Frontier (Opus 4.7/4.8, Fable-tier) sits 0.85–0.95.
- **The honesty slide**: vendor-reported vs independently-administered results
  diverge 10–30 points (SWE-bench Pro: Qwen3-Coder 38.7% on Scale AI's set vs
  ~60% self-reported). Heuristic: treat cheap models as *last year's frontier*.
- The escalation rule, from the field (HN, K3 launch thread): cheap model as
  default, escalate only when it *stops making forward progress* — not when it's
  merely slow. ("K3 struggles with things Opus breezes through… for simpler
  stuff even K2.7 does just fine.")
- Counterpoint receipt: GLM-5.2 beat Claude on Semgrep's IDOR-detection benchmark
  at ~1/6 the cost — role fit beats raw rank.

## 3. The three budgets (6 min)

### Tier $0 — completely free
- **OpenCode Zen free models**: Big Pickle (stealth), DeepSeek V4 Flash Free,
  Nemotron 3 Ultra Free (550B/55B MoE), MiMo-V2.5 Free — all "limited time,"
  logged, trial-only terms. Real models, zero dollars, zero promises.
- **Gemini CLI** free tier (~1,000 req/day) — strongest standalone free agent.
- **GitHub Copilot Free** — 2,000 completions + ~50 chat/agent per month.
- **OpenRouter `:free`** — incl. Nemotron 3 Super/Ultra; 50 req/day, or 1,000/day
  forever after a one-time $10 credit purchase.
- **Local**: Qwen3-Coder-30B on 24GB GPU / 32GB Apple Silicon; Devstral-24B
  (46.8% SWE-bench Verified); gpt-oss-20b on 16GB.
- Reality check: free tiers shrank in 2026 (Qwen Code OAuth tier dead in April,
  OpenRouter roster rotated) and rate limits bite mid-task.

### Tier ~$10/mo — the sweet spot
- **OpenCode Go — the headliner**: $5 first month, then $10/mo. Dollar-metered
  caps ($12/5hr, $30/wk, $60/mo). 17 models as of Aug 1: Kimi K3 + K2.7-Code,
  GLM-5.2, DeepSeek V4, MiniMax M3, Qwen3.7, Grok 4.5 — and now GPT-5.6 Luna.
  No Claude — that's what the caps buy you. My `opencode-go` preset runs the
  entire 7-agent Pantheon on this plan alone.
- **GLM Coding Plan (Z.ai)** Lite ~$18/mo — Anthropic-compatible endpoint, works
  under Claude Code or OpenCode. Watch the 2–3x peak-hour quota multipliers.
- **DeepSeek pay-as-you-go** — V4-Flash $0.14/$0.28 per 1M; side projects land
  in single-digit dollars with no subscription at all.
- **Cautionary tale — my $400 Copilot annual**: June 1, 2026 Copilot moved to
  usage-based AI Credits and cranked legacy request multipliers; annual
  subscribers got the worse rates with none of the transition credits. Locked-in
  ≠ safe. Lesson: in this market, never prepay a year.

### Tier Max — $100–200/mo, and why the mix still matters there
- Max 20x / Pro 5x buy the frontier *ceiling* and higher rate walls — not
  exclusivity. Weekly caps are real.
- My `mixed-fable` preset: frontier orchestrator, GPT-5.6 Luna workers,
  Copilot-carried Gemini Flash for design — the premium window is spent only
  where escalation earns it.

## 4. Demo: one harness, every budget (12 min, live)

Stack under demo: **OpenCode + oh-my-opencode-slim (OMO Slim) + Systematic**
(compound engineering loops). Pre-recorded backup clips for every segment.

1. **`/preset` = changing your budget live** (~5 min): open on the Pantheon
   (7 role agents — roles stable, models swappable; budget is a config value),
   then run the same real task (repo with tests) under:
   - `openai` preset — GPT-5.6 Terra orchestrator, Sonnet 5 oracle (Pro 5x)
   - `opencode-go` preset — Kimi K2.6 orchestrator, DeepSeek V4 Pro oracle,
     MiniMax M3 explorers: **the whole team on $10/mo**
   - `mixed-fable` preset — frontier orchestrator, cheap everything else
   Same harness, same skills, same MCPs — one line changed.
2. **Cheap models where they're strong** (~4 min): Systematic category routing —
   research/document-review on Copilot's gpt-5.4-mini, design on Gemini Flash,
   implementation on Luna xhigh @ temp 0.1; `fast-generic` agent running
   lint/test/commit chores on codex-spark low. Grunt work never touches the
   premium window.
3. **Fallback firing** (~3 min): exhaust/kill the Go plan's 5-hour window
   mid-task, `/preset` to a paid set, resume from the same session. Provider
   diversity *is* the fallback strategy.

## 5. Multiple accounts, one human: CLIProxyAPI + the crackdown (4 min)

Framing up front: **multiple accounts owned by one person — never shared
logins.** Anthropic and OpenAI ToS both flatly prohibit credential sharing;
the Feb 2026 ban wave was for "sharing and reselling."

- **My deployment**: CLIProxyAPI (router-for-me, 39k★, Go) on a DigitalOcean
  droplet behind Caddy — OAuth tokens upstream (Claude, Codex), per-project
  bearer API keys downstream, serving my CI across repos. OpenCode Go rides
  alongside on plain API keys.
- **The 2026 crackdown timeline** (this is the segment the room came for):
  - Jan 9 — silent server-side blocks: "credential only authorized for Claude Code"
  - Feb 18 — ToS updated: subscription OAuth tokens outside Claude Code prohibited
  - Apr 4 — full enforcement; OpenClaw/OpenCode/harness ecosystem cut off;
    Steinberger decamps to Codex ("12 parallel agents for $200/mo")
  - Jun 15 — Agent SDK credit scheme ($20/$100/$200 by tier) announced and
    **walked back the same day**; not live as of Aug 1
  - Today — OAuth access works as normal plan usage (CLIProxyAPI ships client
    cloaking; same mechanism class as `@cortexkit/opencode-anthropic-auth`
    doing OAuth locally in OpenCode). The gray area is ToS language, not
    function — firsthand from my deployment.
- **Scar tissue slide (live incident history)**: my upstream Claude OAuth
  credential died 2026-06-20 and again 2026-07-21. I now run a 15-minute
  auth-monitor workflow with Discord alerts and a canonical GitHub tracking
  issue. If your fallback needs its own monitoring, it's not free — it's cheap.
- **Honest status**: Claude over OAuth works in practice — normal plan usage,
  no separate metering (firsthand; cloaking handles client identification).
  The Feb 18 ToS language is the actual risk surface, and my two outages were
  OAuth refresh fragility, not enforcement. Decide your own risk posture — I
  show mine, timeline included, and let the room judge.
- The sanctioned splits: Team plans (per-seat), Agent SDK credits, or just
  provider diversity — a $10 Go plan as overflow beats any gray-area setup.

## 6. Where your code goes (folded into closing slide + speaker notes)

- Three postures for the cheap tier: (1) Chinese-jurisdiction endpoint —
  cheapest, PRC National Intelligence Law applies regardless of privacy policy;
  (2) international mirrors (Z.ai vs BigModel, Alibaba Singapore) — better,
  same corporate jurisdiction; (3) **open weights on your infra or a US host**
  (GLM, Kimi K2.7-Code, Qwen3-Coder, DeepSeek, MiniMax all ship weights) —
  same model, your jurisdiction. The cheap tier's strongest privacy play.
- Free tiers log by default: Zen free models say so explicitly; AI Studio free
  trains on prompts outside EU/UK.
- Rule: match tier to codebase sensitivity. OSS → anything. NDA/client code →
  open weights on trusted infra, or pay up.

## 7. Decision tree + takeaways (2 min)

- **$0**: Gemini CLI + Zen free models + local Qwen3-Coder for private code.
- **$10**: OpenCode Go + OMO Slim preset. The sweet spot for this room.
- **$100–343**: frontier plans for the ceiling, cheap presets for the volume,
  proxy + monitoring only if you enjoy operating infrastructure.
- One-liner: **budget buys ceiling, routing buys leverage.**
- QR → repo: these slides, my dotfiles (presets), infra (CLIProxyAPI deploy).

---

## Appendix A — re-verify pass results (run 2026-08-01)

- [x] OpenCode Go — $5→$10/mo and caps unchanged; roster now **17 models incl.
      GPT-5.6 Luna** (still no Claude). Slides updated.
- [x] OpenCode Zen free roster — now 7 models (+Ling-3.0-flash). Slides updated.
- [x] CLIProxyAPI × Claude — corrected against firsthand operation (Marcus,
      Aug 1): OAuth access draws from the plan as normal usage, no extra
      metering; cloaking exists in-project. Web-sourced "#2599 metering"
      claims were wrong. Day-of check reduces to `cliproxy status` green.
- [x] GLM Lite confirmed **$18/mo** (docs.z.ai). Pro/Max dollar figures still
      unverifiable from primary (SPA) — quote quotas, not prices, on stage.
- [x] Kimi K3 signups **still paused** as of Aug 1 (batch reopening, membership
      splitting into two tiers). Kimi Code CLI tier prices remain unconfirmed —
      don't quote them.
- [x] Claude Pro $20 / Max $100 / $200 unchanged. **Agent SDK credits: announced
      Jun 15, walked back same day — NOT live.** Timeline slide corrected.
- [x] ChatGPT: Free $0 / Go $8 / Plus $20 / Pro $100 (5x) / $200 (20x) unchanged.
- [x] Copilot resolved from official page: Free 2,000 completions + 50 chat;
      Pro $10 + $15 credits; Pro+ $39 + $70; Max $100 + $200.
- [x] Gemini CLI free tier confirmed from Google docs: **1,000 req/day, 60/min**.
- [x] SWE-bench Verified snapshot unchanged (cheap cluster 0.78–0.81; Opus
      4.7/4.8 0.876/0.886; Fable 5 0.950).
- [ ] Still open: lmarena coding sub-arena pull (optional slide garnish);
      day-of `cliproxy status` check.

## Appendix B — demo prep checklist

- [ ] Demo repo: small, real, with tests (not hello-world)
- [ ] OMO Slim presets verified working: `openai`, `opencode-go`, `mixed-fable`
- [ ] OpenCode Go quota headroom reserved for both nights (don't burn the $12/5hr window rehearsing day-of)
- [ ] Systematic config demo-ready; `fast-generic` commit flow rehearsed
- [ ] Zen free model routed into one preset slot for the $0 beat (currently unrouted)
- [ ] CLIProxyAPI: `cliproxy status` green day-of; screenshot of auth-monitor Discord alert + tracking issue for the scar-tissue slide
- [ ] Pre-recorded backup clips: preset switch, fallback firing, CLIProxyAPI status
- [ ] Offline fallback: local Qwen3-Coder-30B via Ollama (doubles as a talking point)
- [ ] Sanitize on screen: no API keys, no management URLs, no OAuth tokens (terminal scrollback included)

## Appendix C — community receipts (speaker-notes fodder)

- vidarh (HN, K3 thread): Kimi default, Opus escalation on stalled compiler bug
- mark_l_watson (HN): $20 Anthropic sub + Claude Code pointed at DeepSeek V4/GLM-5.2
- Steinberger/OpenClaw: post-crackdown exit to Codex, 12 parallel agents @ $200/mo
- Semgrep: GLM-5.2 beats Claude on IDOR F1 at ~1/6 cost ($0.17/vuln)
- Fireworks "oracle router": Kimi K3 picked over frontier in 72–96% of categories (hindsight router — caveat on stage)
- GLM plan complaint pattern: 2–3x peak quota multipliers, hard stop, no overflow
- OpenCode Go complaint pattern: 5-hour window rate-limit collisions ("can you guys get off it for a second")

## Appendix D — source notes

Verified 2026-07-22 against primary sources where possible: opencode.ai/docs/go +
/docs/zen, github.com/alvinunreal/oh-my-opencode-slim (v2.2.0), github.com/router-for-me/CLIProxyAPI
(v7.2.51 + issues #2599/#3467), marcusrbrown/.dotfiles + /infra (actual configs),
docs.github.com Copilot billing, claude.com/pricing, anthropic.com/legal ToS +
AUP, developer.nvidia.com (Nemotron 3), llm-stats.com, HN threads 48937376 /
48999291 / 49004920. Reddit/X were unreachable from the research environment —
community examples are HN/blog-sourced; worth a manual skim of r/LocalLLaMA and
X before the talk for fresher setups.
