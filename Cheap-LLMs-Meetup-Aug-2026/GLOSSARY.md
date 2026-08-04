# Glossary

Terms used in "$200 Intelligence on a $10 Budget," in plain language, for a
mixed technical audience. Alphabetical.

**Agentic coding** — Letting an AI model drive a multi-step coding loop: read
the repo, edit files, run tests, react to failures. Distinct from autocomplete
or one-shot chat answers.

**API key vs. OAuth** — Two ways a tool proves who you are to a provider. An
API key is a plain per-app secret billed by usage. OAuth is a browser sign-in
that issues tokens tied to your subscription account; some proxies reuse those
tokens to reach subscription models from other tools.

**BYOK (bring your own key)** — A tool or gateway that lets you plug in your
own provider API keys instead of buying inference through them.

**Context window** — How much text (code, conversation, docs) a model can hold
in one request, measured in tokens. "1M context" ≈ several large codebases'
worth.

**Effort / variant** — A per-request dial (low → xhigh/max) for how much
reasoning a model spends before answering. Same model, higher effort: better
answers, multiplied cost and latency. In OMO Slim configs this is the
`variant` field.

**Fallback / failover** — A pre-configured alternate model or provider that
takes over when the primary hits a rate limit or dies mid-task.

**5-hour window / weekly cap** — How subscription plans meter usage: a rolling
short-window allowance (e.g. $12 of usage per 5 hours on OpenCode Go) plus a
longer weekly or monthly ceiling. You can be under one and blocked by the
other.

**Harness** — The tool wrapped around the model: terminal agent, editor
plugin, CI bot. Claude Code, OpenCode, and Codex CLI are harnesses. Much of
this talk is "keep the harness, swap the model."

**Intelligence Index (Artificial Analysis)** — A blended score across ~9
benchmarks (reasoning, agentic tasks, knowledge) published by Artificial
Analysis. Useful for cross-model comparison; not coding-specific.

**MCP (Model Context Protocol)** — A standard for plugging external tools
(web search, docs lookup, browsers) into AI agents. In the demo configs, MCPs
are granted per-agent.

**MoE (mixture of experts)** — Model architecture where only a fraction of
parameters activate per token ("550B total / 55B active"). How open models get
big capability at low inference cost.

**Open weights** — The model's parameters are downloadable, so anyone can host
it: your GPU, a US cloud, or the vendor's own API. Same model, your choice of
jurisdiction — the cheap tier's strongest privacy option.

**Orchestrator / subagents** — The division of labor inside a multi-agent
harness: one model plans and delegates (orchestrator); specialized workers
(explorer, librarian, fixer, etc.) execute narrower tasks, each routable to a
different model. OMO Slim calls its seven-role set "the Pantheon."

**Pareto line / frontier** — On a cost-vs-capability chart, the set of models
where you can't get a better score without paying more. Anything right of the
line is dominated: same score available cheaper.

**PAYG (pay-as-you-go)** — Per-token API billing with no subscription.
DeepSeek's API is the canonical cheap example.

**Preset** — In OMO Slim: a named mapping of every agent role to a model +
effort. Switching presets (`/preset opencode-go`) re-points the whole team —
the mechanism that makes budget a config value.

**Proxy (CLIProxyAPI)** — A server that holds provider credentials (often
OAuth) and re-exposes the models behind a standard API with its own keys. Used
to share one person's subscriptions across their own tools and CI.

**Quantization** — Compressing model weights to lower precision so they fit on
consumer hardware, trading a little quality for a lot of memory.

**Rate limit** — Provider-enforced ceiling on requests or tokens per
minute/day. On free tiers, the thing you hit mid-task.

**SWE-bench Verified** — Benchmark of real GitHub issues a model must fix,
human-validated. The standard agentic-coding yardstick. Scores vary by test
harness — the same model can differ 10+ points between leaderboards.

**Token** — The unit models read and bill in; roughly ¾ of a word, or a few
characters of code. API prices quote dollars per million tokens.

**ToS (terms of service)** — The provider contract. Relevant tonight:
credential sharing between people is prohibited everywhere; subscription-OAuth
reuse outside first-party tools is contractually gray even where it works.

**Vendor-reported vs. independent (benchmarks)** — Scores measured by the
model's maker vs. a third party running its own harness. Vendor numbers run
10–30 points hotter; trust the referee, not the athlete.

**Vibe coding** — Loosely-specified, conversation-driven development where you
describe intent and let the agent implement. Cheap models made it affordable;
routing makes it sustainable.
