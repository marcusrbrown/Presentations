---
theme: seriph
title: '$200 Intelligence on a $10 Budget'
titleTemplate: '%s — Marcus R. Brown'
info: |
  Cracked Claude Cowork and Codex Club — Aug 4 & 5, 2026.
  One harness, preset-switchable model sets, budgets from $0 to maxed out.
class: text-center
highlighter: shiki
drawings:
  persist: false
transition: fade
mdc: true
---

# $200 Intelligence on a $10 Budget

## Kimi Models & More

Marcus R. Brown · Cracked Claude Cowork and Codex Club · Aug 2026

<!--
Title matches the Meetup listing so the room knows they're in the right talk.
30-minute slot. Demo is ~12 of it. Q&A rolls into the club discussion block.
-->

---
layout: statement
---

# I pay <span v-mark.red>$343/mo</span> for AI

### so you don't have to

<!--
The confession. Let it sit for a beat before the receipts.
-->

---

# The receipts

| Subscription | $/mo | Verdict |
|---|---:|---|
| Claude Max 20x | $200 | the ceiling |
| ChatGPT Pro 5x | $100 | the workhorse |
| GitHub Copilot (annual ÷ 12) | ~$33 | **barely touched since June** |
| OpenCode Go | $10 | shocking share of the work |
| OpenCode Zen free models | $0 | on the bench, ready |

<v-click>

**Price and value stopped correlating in 2026.**

</v-click>

<!--
Copilot line is the cautionary tale — comes back in the budgets section.
Jon's framing vs mine: yes, the cheap tier is mostly Chinese labs (Kimi, GLM,
DeepSeek, Qwen, MiniMax). But tonight's skill is portfolio construction, not
model nationality. Even Max subscribers leave money on the table by not mixing.
Promise: leave with a $0 stack, a $10 stack, or a smarter $200 stack.
-->

---
layout: image-right
image: /images/aa-intelligence-vs-cost.png
backgroundSize: contain
---

# Intelligence vs. cost per task

Artificial Analysis Intelligence Index v4.1, Aug 2026

- DeepSeek V4 Flash: index **50** at **~$0.03**/task
- GPT-5.6 Terra (high): index 50 at ~$0.3 — **10x the cost, same score**
- Kimi K3 (max): **57** at ~$0.85 vs GPT-5.6 Sol (max): 59 at ~$2.5
- Same model, different effort = 5–10x cost spread → **`variant` is a budget knob too**

<v-click>

Across this filter: ~100x in cost, ~9 index points.

</v-click>

<!--
Source: artificialanalysis.ai/models — "Intelligence vs. Cost per Intelligence
Index Task," Intelligence Index v4.1 (blended: agentic + reasoning + knowledge —
NOT coding-specific; SWE-bench next slide covers that). Log scale — say so.
Caveats to say out loud: (1) filtered view, 22 of 589 models, no Anthropic
models in this cut — re-filter with Claude added if you want the ceiling
visible; (2) cost-per-task = API token prices, so this supports the API story,
not subscription economics — the receipts slide covers plans. Attribution on
slide per AA's usage terms.
-->

---

# The gap, honestly

SWE-bench Verified, July 2026:

- Cheap tier — DeepSeek V4-Pro-Max, MiniMax M3, Qwen3.7 Max, Kimi K2.6: **~0.80** · GLM-5: ~0.78
- That's roughly GPT-5.1 / Sonnet 4.6 class — *last year's frontier*
- Actual frontier (Opus 4.7/4.8, Fable-tier): **0.85–0.95**

<v-click>

**The honesty caveat:** vendor-reported vs independent runs diverge 10–30 points
(Qwen3-Coder: 38.7% on Scale AI's SWE-bench Pro set vs ~60% self-reported)

</v-click>

<!--
Heuristic to say out loud: trust the cheap model to be last year's frontier,
not this year's. Re-pull llm-stats + lmarena coding sub-arena Aug 1-3 and
refresh these numbers.
-->

---

# When cheap wins, when it doesn't

<div class="grid grid-cols-2 gap-8">
<div>

**Escalation rule (from the field)**

Cheap model as default.
Escalate when it stops making
**forward progress** — not when
it's merely slow.

</div>
<div>

**Role fit beats raw rank**

GLM-5.2 beat Claude on Semgrep's
IDOR-detection benchmark
at ~1/6 the cost ($0.17/vuln)

</div>
</div>

<!--
HN K3-thread quote (vidarh): "K3 struggles with things Opus breezes through…
two days of struggle… will have Opus redo its work. For simpler stuff even
K2.7 does just fine." That's the whole model-selection algorithm in one anecdote.
-->

---
layout: section
---

# The three budgets

## $0 · $10 · Max

---

# Tier $0 — completely free

- **OpenCode Zen free models** — 7 today: Big Pickle (stealth), DeepSeek V4 Flash Free, Nemotron 3 Ultra Free (550B MoE), Ling-3.0-flash, MiMo-V2.5… — "limited time," logged, trial terms
- **Gemini CLI** — 1,000 req/day, 60/min (Google-documented); strongest standalone free agent
- **Copilot Free** — 2,000 completions + ~50 chat/agent per month
- **OpenRouter `:free`** — 50 req/day → 1,000/day forever after a one-time $10 credit
- **Local** — Qwen3-Coder-30B (24GB GPU / 32GB Apple Silicon), Devstral-24B, gpt-oss-20b

<v-click>

⚠ Free shrank in 2026: Qwen Code's OAuth tier died in April; rosters rotate; limits bite mid-task

</v-click>

<!--
Zen free models are real models at zero dollars with zero promises — logged,
trial-only. Fine for OSS, not for client code (privacy rule at the end).
-->

---

# Tier $10 — the sweet spot

**OpenCode Go**: $5 first month, then $10/mo · $12/5hr, $30/wk, $60/mo caps

17 models: Kimi K3 + K2.7-Code · GLM-5.2 · DeepSeek V4 · MiniMax M3 · Qwen3.7 · Grok 4.5 · even GPT-5.6 Luna now

No Claude. *That's what the caps buy you.*

<v-clicks>

- My `opencode-go` preset runs the **entire 7-agent Pantheon** on this plan alone
- Alternatives: GLM Coding Plan Lite (~$18, watch 2–3x peak multipliers) · DeepSeek PAYG ($0.14/$0.28 per 1M — side projects land in single digits)

</v-clicks>

<!--
This is the slide the Meetup title promised. Demo proves it in a minute.
-->

---

# Cautionary tale: my $400 Copilot annual

- June 1, 2026: Copilot moves to usage-based **AI Credits**
- Legacy annual plans: request multipliers cranked, **zero transition credits**
- Result: locked-in for a year of the worst rates in the lineup

<v-click>

### In this market, **never prepay a year.**

</v-click>

<!--
"Barely used since June" — my own receipt from slide 3. Business/Enterprise got
$30-70 bonus credits during the transition; individual annual holders got nothing.
-->

---

# Tier Max — what $200 still buys

- The frontier **ceiling** + higher rate walls — not exclusivity
- Weekly caps are real, even on Max 20x
- So spend the premium window only where escalation earns it:

```jsonc
// oh-my-opencode-slim.jsonc — "mixed-fable" preset
"orchestrator": { "model": "anthropic/claude-fable-5", "variant": "high" },
"oracle":       { "model": "openai/gpt-5.6-sol", "variant": "xhigh" },
"librarian":    { "model": "openai/gpt-5.6-luna", "variant": "low" },
"designer":     { "model": "github-copilot/gemini-3.5-flash" }
```

<!--
Frontier orchestrator, cheap everything else. The $200 plan is a scalpel,
not a firehose.
-->

---
layout: section
---

# Demo

## One harness, every budget

### OpenCode + OMO Slim + Systematic

<!--
~12 minutes. Backup clips ready for every beat. Quota headroom reserved on Go.
-->

---

# Demo 1 · `/preset` = changing your budget live

The Pantheon: 7 roles, stable · models, swappable

| Preset | Orchestrator | Oracle | Workers | Plan |
|---|---|---|---|---|
| `openai` | GPT-5.6 Terra | Sonnet 5 | Luna | Pro 5x |
| `opencode-go` | Kimi K2.6 | DeepSeek V4 Pro | MiniMax M3 | **$10/mo** |
| `mixed-fable` | Fable 5 | GPT-5.6 Sol | Luna | Max 20x |

Same task. Same skills. Same MCPs. One line changed.

<!--
LIVE: run the demo-repo task under openai, /preset to opencode-go, rerun,
/preset to mixed-fable. Emphasize: budget is a config value.
-->

---

# Demo 2 · Cheap models where they're strong

```jsonc
// systematic.jsonc — category routing
"research":        { "model": "github-copilot/gpt-5.4-mini", "variant": "low" },
"design":          { "model": "github-copilot/gemini-3.5-flash" },
"review":          { "model": "openai/gpt-5.6-terra", "variant": "medium" },
// implementer: gpt-5.6-luna, xhigh, temp 0.1
```

Plus `fast-generic` on codex-spark low: lint · test · commit chores

**Grunt work never touches the premium window.**

<!--
LIVE: kick off a Systematic loop; show fast-generic doing the commit flow
while the orchestrator stays idle.
-->

---

# Demo 3 · Fallback firing

1. Burn out the Go plan's 5-hour window mid-task
2. `/preset` to a paid set
3. Resume the same session

### Provider diversity **is** the fallback strategy

<!--
LIVE (or clip): the rate-limit error, the one-command recovery. Community
receipt in notes: "I keep getting blocked by rate limit (opencode go). Can you
guys get off it for a second" — HN, July 2026.
-->

---
layout: section
---

# Multiple accounts, one human

## (never shared logins)

<!--
Framing before anyone asks: multiple accounts you own and pay for — not
credential sharing. Anthropic + OpenAI ToS both flatly prohibit sharing;
the Feb 2026 ban wave was for "sharing and reselling."
-->

---

# My proxy: CLIProxyAPI

**cliproxy.fro.bot** — CLIProxyAPI (39k★, Go) · Caddy · DigitalOcean droplet

- Upstream: OAuth (Claude, Codex) · Downstream: per-project bearer keys for CI
- OpenCode Go rides alongside on plain API keys

<v-click>

**The 2026 crackdown, one line each:**

- Jan 9 — silent blocks: "credential only authorized for Claude Code"
- Feb 18 — ToS: subscription OAuth outside Claude Code prohibited
- Apr 4 — enforcement wave; named harnesses (OpenClaw et al.) cut off
- Jun 15 — Agent SDK credit scheme announced… and walked back *the same day*
- Today — **OAuth access works as normal plan usage** (client cloaking); the gray area is ToS, not function

</v-click>

<!--
Steinberger/OpenClaw decamped to Codex post-crackdown ("12 parallel agents for
$200/mo"). Firsthand status, my deployment: Claude via OAuth through CLIProxyAPI
draws from the plan like any Claude Code session — no extra usage, no separate
metering. Same mechanism class as @cortexkit/opencode-anthropic-auth doing OAuth
locally in OpenCode (it's in my opencode.json — mention the symmetry: proxy for
CI, plugin for local). What Anthropic enforced in spring was aimed at specific
third-party harnesses; cloaking exists in CLIProxyAPI and the ToS language from
Feb 18 still reads how it reads. Present it straight: works today, ToS-gray,
your risk call.
-->

---

# Scar tissue

My upstream Claude OAuth credential died **2026-06-20** and **2026-07-21**

So now I run:

- a 15-minute auth-monitor workflow (probe → canonical GitHub issue → Discord alert)
- transition-only alerting, secret-free messages, manual OAuth re-login runbook

<v-click>

### If your fallback needs its own monitoring, it isn't free — it's *cheap*.

</v-click>

<!--
Screenshot slots: auth-monitor Discord alert + the tracking issue. SANITIZE.
Point to make: these outages were OAuth token refresh fragility, not Anthropic
enforcement — the route works day-to-day; the operational cost is keeping the
credential alive. My deployment, my risk call — decide yours. Sanctioned
alternatives: Team plans, or plain provider diversity.
-->

---

# Decision tree

| You | Run this |
|---|---|
| $0 | Gemini CLI + Zen free models + local Qwen3-Coder for private code |
| $10 | **OpenCode Go + OMO Slim preset** ← most of this room |
| $100–343 | Frontier for the ceiling, cheap presets for the volume |

<v-click>

**Privacy rule:** match the tier to the codebase — OSS → anything ·
NDA code → open weights on trusted infra, or pay up

</v-click>

<!--
Three postures if asked: (1) Chinese-jurisdiction endpoint — cheapest, PRC
National Intelligence Law applies regardless of privacy policy; (2) intl
mirrors (Z.ai vs BigModel, Alibaba SG) — better, same corporate jurisdiction;
(3) open weights on your infra / US host — same model, your jurisdiction.
Free tiers log by default (Zen says so explicitly; AI Studio trains on prompts
outside EU/UK).
-->

---
layout: statement
---

# Pick a mix, not a model.

<v-click>

<img src="/images/repo-qr.png" class="w-36 mx-auto mt-6 rounded" alt="QR: talk repo" />

`marcusrbrown/Presentations` — presets · configs · outline with sources

</v-click>

<!--
QR → github.com/marcusrbrown/Presentations/tree/main/Cheap-LLMs-Meetup-Aug-2026
Closing line is in TALK-TRACK.md. Stop talking after it; Q&A flows into the
club discussion block.
-->
