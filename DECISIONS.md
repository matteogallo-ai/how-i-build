# Decisions

A register inspired by [Oxide's RFDs](https://rfd.shared.oxide.computer/rfd/0001): one
line per decision, a state, and the link where it is argued. The states are:

- **accepted** — in force today;
- **superseded** — replaced by a later decision or by a measurement, which is named;
- **partly superseded** — part of it is replaced, and the part is named; the rest is in force;
- **abandoned** — stopped; the reason is given.

A superseded or abandoned entry is never deleted.

## Register

| # | Decision | State | Where |
|---|---|---|---|
| 1 | Verity stores vectors in Postgres (pgvector), not in a dedicated vector database. | accepted · 2026-09 | [Verity ADR 0002](https://github.com/matteogallo-ai/verity/blob/1146e3429366df6bee0f6770326198c2c41f6fae/docs/adr/0002-pgvector-over-qdrant.md) |
| 2 | Verity refuses when evidence is weak, and refusal is measured like any other answer. | partly superseded · 2026-11-02, by measurement: refusals come from deterministic checks, not from the calibrated confidence threshold, which is 0 by default; refusal is still measured ([results, Open issues](https://github.com/matteogallo-ai/verity/blob/0ef7e9f380ba6d180e2c0e88ff8ee51e1ead4ad9/docs/results.md#open-issues-what-the-numbers-do-not-say)) | [Verity ADR 0003](https://github.com/matteogallo-ai/verity/blob/1146e3429366df6bee0f6770326198c2c41f6fae/docs/adr/0003-refusal-as-headline-feature.md) |
| 3 | Verity's prompts are authored in PromptLang and compiled through it. | superseded by #4 · 2026-11 | [Verity ADR 0004](https://github.com/matteogallo-ai/verity/blob/1146e3429366df6bee0f6770326198c2c41f6fae/docs/adr/0004-promptlang-dogfooding.md) |
| 4 | Verity's prompts are parsed by a local parser; #3 was never built. | accepted · 2026-11 | [Verity ADR 0005](https://github.com/matteogallo-ai/verity/blob/1146e3429366df6bee0f6770326198c2c41f6fae/docs/adr/0005-prompt-files-without-promptlang.md) |
| 5 | Retrieved text is datamarked; rejected: instruction hierarchy (needs a trained model), CaMeL-style patterns (Verity takes no action). The regex list stays. | accepted · 2026-11 | [verity#34](https://github.com/matteogallo-ai/verity/pull/34) |
| 6 | The approved cost estimate is a spending cap, enforced per call in code. | accepted · 2026-11 | [PromptLang ADR 0004](https://github.com/matteogallo-ai/promptlang/blob/ef910ff7f00d2c2a235cd607ac671512d557ffd3/docs/adr/0004-spending-cap.md) |
| 7 | PromptLang publishes to npm through trusted publishing (OIDC), without a token in the job. | accepted · 2026-11 | [promptlang#33](https://github.com/matteogallo-ai/promptlang/pull/33) |
| 8 | Praxis trusts a first-party source only through an explicit, reviewed, versioned organisation-to-domains list. | accepted · 2026-11, on that condition | [Praxis ADR 0003](https://github.com/matteogallo-ai/praxis/blob/6cb01f4472b4cb4e341db6976c5d82f4e597807c/docs/adr/0003-source-trust-criteria.md) |
| 9 | Praxis and PromptLang: Dependabot groups every update, majors included. | superseded by #10 · 2026-11 | the grouped PR it produced: [promptlang#6](https://github.com/matteogallo-ai/promptlang/pull/6) |
| 10 | Dependabot groups minor and patch updates; each major gets its own PR. | accepted · 2026-11 | [praxis#12](https://github.com/matteogallo-ai/praxis/pull/12) |
| 11 | Praxis cost target: p95 ≤ $2.50 per briefing. | superseded by #12 · 2026-11 | [praxis#25](https://github.com/matteogallo-ai/praxis/pull/25) |
| 12 | Praxis cost target: p95 ≤ $10 per briefing; met or not met only from live runs. | accepted · 2026-11 | [praxis#27](https://github.com/matteogallo-ai/praxis/pull/27) |
