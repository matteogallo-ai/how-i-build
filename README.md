# How I build

Two systems and one experiment, the rules I build them by, and the pull request behind each rule.

The two systems are [Verity](https://github.com/matteogallo-ai/verity) (question answering
over documents that cites the exact passage or refuses) and [PromptLang](https://github.com/matteogallo-ai/promptlang) (a typed
language for LLM prompts, published on npm). The experiment is
[Praxis](https://github.com/matteogallo-ai/praxis), a 7-stage analysis pipeline: on one question,
the blind reviewer preferred a single model call 9.8× cheaper
([result](https://github.com/matteogallo-ai/praxis/blob/bfad47e21f0d191d5c7cf57993932a640c3453d2/README.md#status)). I decide what gets built and how it is
judged: the architecture and its trade-offs, the definition of done, the evaluation
protocols and the cost caps.

Built with coding agents: I write the specs, review the pull requests and their tests, and answer for what gets merged.

## If you have two minutes

- [promptlang#39](https://github.com/matteogallo-ai/promptlang/pull/39): the AI linter measured at 30% precision, not distinguishable from the 20% bound, published unchanged.
- [promptlang#32](https://github.com/matteogallo-ai/promptlang/pull/32): an audit by a context-free agent, 23 findings, each fixed, refuted or left open.
- [RULES.md P1](RULES.md#p1-a-target-is-set-by-the-need-and-is-not-moved-to-fit-a-run-a-miss-is-published): the one target that moved, with the facts against it, set out to be challenged.

## The method in five principles

Each principle links to [RULES.md](RULES.md), and each proof is a pull request whose
claim can be checked from GitHub.

1. **A result is published unchanged** ([R7](RULES.md#r7-a-human-review-is-pre-registered-and-its-result-is-published-unchanged)). The review plan is committed before the
   review.
   Proof: [promptlang#39](https://github.com/matteogallo-ai/promptlang/pull/39) — the
   pre-registered human review measured the AI linter's precision at 30% (12 correct flags out of 40),
   which does not distinguish it from the 20% lower bound already published.

2. **No agent report is trusted until a context-free agent checks it** ([P2](RULES.md#p2-a-context-free-agent-audits-main-each-finding-is-fixed-refuted-or-left-open-in-writing)).
   That agent audits `main`; each finding is fixed, refuted or left open, in writing.
   Proof: [promptlang#32](https://github.com/matteogallo-ai/promptlang/pull/32) — 23
   findings, fixes in #23–#31, 5 refuted in whole or in part, with evidence.

3. **Spending is capped in code** ([R5](RULES.md#r5-a-spending-cap-reserves-each-requests-worst-case-before-sending-it)). Each request reserves its worst-case cost before it
   is sent.
   Proof: [praxis#22](https://github.com/matteogallo-ai/praxis/pull/22) — the old cap
   counted only recorded spend, so requests in flight and timeouts could exceed it. The
   PR states the gap it leaves.

4. **No test breaks as time passes** ([R3](RULES.md#r3-no-test-breaks-as-time-passes)).
   Proof: [praxis#7](https://github.com/matteogallo-ai/praxis/pull/7) — a CI job runs the
   whole suite with the clock at 2029 and at 2040 on every pull request. The red run before
   the fix (six tests failing at 2029) is reported in the PR; its log was not kept.

5. **A numbered rule (R1–R15) exists only because something went wrong** ([R13](RULES.md#r13-a-human-reads-real-output-the-review-finds-what-tests-miss)). Each numbered rule in
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

The three repos have been built since August 2026. In early November (2026-11-02 to 2026-11-04)
I had a context-free agent audit Verity and PromptLang, and hardened all three; the linked
pull requests come from that pass, and the numbered rules are what it taught me. The repos
show how far each rule is applied today. One target moved during that pass;
[RULES.md P1](RULES.md#p1-a-target-is-set-by-the-need-and-is-not-moved-to-fit-a-run-a-miss-is-published)
gives the facts against it.

## Checking the links

`scripts/check-links.sh` asks the GitHub API for every pull request, commit and pinned file
linked from these files (not other links or anchors), and fails if one does not exist. It needs the `gh` CLI, logged in.

## FAQ

**Why do some PRs merge in minutes?** Most are opened once the tests and a fresh-context
agent review have run on the branch; then CI (1 to 10 minutes) and my review. Small docs
PRs such as [praxis#27](https://github.com/matteogallo-ai/praxis/pull/27) skip the agent review.
Example: [praxis#22](https://github.com/matteogallo-ai/praxis/pull/22), open 7 minutes, lists its branch fixes and four rejected findings.

## License

[MIT](LICENSE).
