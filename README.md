# How I build

I own three small systems end to end, and everything about them is clickable.

The three systems are [Verity](https://github.com/matteogallo-ai/verity) (a RAG agent
that cites or refuses), [Praxis](https://github.com/matteogallo-ai/praxis) (a multi-stage
briefing pipeline) and [PromptLang](https://github.com/matteogallo-ai/promptlang) (a typed
language for LLM prompts, published on npm). I decide what gets built and how it is
judged: the specs, the architecture and its trade-offs, the definition of done, the
evaluation protocols and the cost caps. Coding agents write most of the code, independent
agents review it, and I read the result and merge.

## If you have two minutes

- [promptlang#39](https://github.com/matteogallo-ai/promptlang/pull/39): the AI linter measured at 30% precision, not distinguishable from the 20% bound, published as it came out.
- [promptlang#32](https://github.com/matteogallo-ai/promptlang/pull/32): an independent audit, 23 findings, each fixed, refuted or acknowledged.
- [RULES.md P1](RULES.md#p1-a-target-is-set-by-the-need-and-is-not-moved-to-fit-a-run-a-miss-is-published): the one target that moved, with the facts against it, set out to be challenged.

## The method in five principles

1. **A result is published as it came out.** The review plan is committed before the
   review.
   Proof: [promptlang#39](https://github.com/matteogallo-ai/promptlang/pull/39) — the
   pre-registered human review measured the AI linter's precision at 30% (12/40, 95% CI
   18–45%), which does not distinguish it from the 20% lower bound already published.

2. **No agent report is trusted until something independent checks it.** A context-free
   agent audits `main`; each finding is fixed, refuted or left open, in writing.
   Proof: [promptlang#32](https://github.com/matteogallo-ai/promptlang/pull/32) — 23
   findings, fixes in #23–#31, 5 refuted in whole or in part, with evidence.

3. **Spending is capped in code.** Each request reserves its worst-case cost before it
   is sent.
   Proof: [praxis#22](https://github.com/matteogallo-ai/praxis/pull/22) — the old cap
   counted only recorded spend, so requests in flight and timeouts could exceed it. The
   PR states the gap it leaves.

4. **A bug is shown red before it is fixed.**
   Proof: [praxis#7](https://github.com/matteogallo-ai/praxis/pull/7) — with the clock
   set to 2029, six tests failed; after the fix the suite passes at today, 2029 and 2040.

5. **A rule exists only because something went wrong.** Each numbered rule in
   [RULES.md](RULES.md) links to the incident that created it.
   Proof: my review of a live Praxis briefing found risk estimates labelled as
   first-party facts, which no test had caught; the validator was fixed and the review
   published ([praxis#47](https://github.com/matteogallo-ai/praxis/pull/47)). That
   incident is rule R13: a human reads real output.

## What is in this repo

| File | Content |
|---|---|
| [RULES.md](RULES.md) | Each rule, the incident behind it, and the link. |
| [DEFINITION_OF_DONE.md](DEFINITION_OF_DONE.md) | The checklist a repo must pass before I call it done. |
| [DECISIONS.md](DECISIONS.md) | Decisions and their state: accepted, superseded, abandoned. |

## Dates

The three repos were built from August 2026. In early November (2026-11-02 to 2026-11-04)
I had an independent agent audit Verity and PromptLang, and hardened all three; the linked
pull requests come from that pass, and the numbered rules are what it taught me. The repos
show how far each rule is applied today. One target moved during that pass;
[RULES.md P1](RULES.md#p1-a-target-is-set-by-the-need-and-is-not-moved-to-fit-a-run-a-miss-is-published)
gives the facts against it.

## Checking the links

`scripts/check-links.sh` asks the GitHub API for every pull request, commit and pinned file
linked from these files (not other links or anchors), and fails if one does not exist. It needs the `gh` CLI, logged in.

## FAQ

**Why do some PRs merge in minutes?** Most are opened once the tests and a fresh-context
review have run on the branch; then CI (1 to 10 minutes) and my read. Not all: small docs
PRs such as [praxis#27](https://github.com/matteogallo-ai/praxis/pull/27) carry no review.
Example: [praxis#22](https://github.com/matteogallo-ai/praxis/pull/22), open 7 minutes, lists its branch fixes and four rejected findings.

## License

[MIT](LICENSE).
