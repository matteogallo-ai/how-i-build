# How I build

I'm not senior. I own three small systems end to end. Everything about these three systems is clickable.

The three systems are [Verity](https://github.com/matteogallo-ai/verity) (a RAG agent
that cites or refuses), [Praxis](https://github.com/matteogallo-ai/praxis) (a multi-stage
briefing pipeline) and [PromptLang](https://github.com/matteogallo-ai/promptlang) (a typed
language for LLM prompts, published on npm). Coding agents write most of the code. I set
the rules, approve the spend, review the output and merge.

## The method in five principles

1. **A rule exists only because something went wrong.** Each rule in
   [RULES.md](RULES.md) links to the incident that created it.
   Proof: TypeScript 7 arrived grouped with a minor bump and blocked it
   ([promptlang#6](https://github.com/matteogallo-ai/promptlang/pull/6)); each major bump
   now gets its own pull request
   ([praxis#12](https://github.com/matteogallo-ai/praxis/pull/12)).

2. **Spending is capped in code.** Each request reserves its worst-case cost before it
   is sent.
   Proof: [praxis#22](https://github.com/matteogallo-ai/praxis/pull/22) — the old cap
   counted only recorded spend, so requests in flight and timeouts could exceed it. The
   PR states the gap it leaves.

3. **A result is published as it came out.** The review plan is committed before the
   review.
   Proof: [promptlang#39](https://github.com/matteogallo-ai/promptlang/pull/39) — the
   pre-registered human review measured the AI linter's precision at 30% (12/40, 95% CI
   18–45%), which does not distinguish it from the 20% lower bound already published.

4. **A bug is shown red before it is fixed.**
   Proof: [praxis#7](https://github.com/matteogallo-ai/praxis/pull/7) — with the clock
   set to 2029, six tests failed; after the fix the suite passes at today, 2029 and 2040.

5. **No agent report is trusted until something independent checks it.** A context-free
   agent audits `main`; each finding is fixed, refuted or left open, in writing.
   Proof: [promptlang#32](https://github.com/matteogallo-ai/promptlang/pull/32) — 23
   findings, fixes in #23–#31, 5 refuted in whole or in part, with evidence.

## Why some PRs merge in minutes

Most pull requests are opened when their work is finished. Before that, on the branch, the
agent runs the test suite and, for code changes, a fresh-context reviewer agent reads the
diff; its findings are fixed on the branch and listed in the PR description. GitHub CI runs
once the PR is open and has to pass before the merge: about 1 minute in PromptLang, 1 to
2.5 in Praxis, 7 to 10 in Verity. Then I read the description and the diff, and merge.

Not every PR follows this. Small config and docs PRs often carry no review section, among
them [praxis#27](https://github.com/matteogallo-ai/praxis/pull/27), the one target move
(RULES.md P1). Some PRs gain commits after they open, with fixes from a second review.

Example: [praxis#22](https://github.com/matteogallo-ai/praxis/pull/22) was open for 7
minutes (13:59 to 14:07 UTC). Its section "Reviewer (fresh context)" lists the fixes made on the branch before the
PR opened (a changelog commit followed 8 s after) and four findings rejected with a reason.
The blocking one:
the cap reserved $0.74 for a request that could spend $0.82. CI ran on the PR from 14:00 to 14:02 and passed.

## What is in this repo

| File | Content |
|---|---|
| [RULES.md](RULES.md) | Each rule, the incident behind it, and the link. |
| [DEFINITION_OF_DONE.md](DEFINITION_OF_DONE.md) | The checklist a repo must pass before I call it done. |
| [DECISIONS.md](DECISIONS.md) | Decisions and their state: accepted, superseded, abandoned. |

## Dates

The three repos started between August and September 2026. Every linked pull request
comes from one audit-and-hardening pass on all three, from 2026-11-02 to 2026-11-04. The
rules are days old; the repos show how far each one is applied today. One target moved
during that pass; [RULES.md P1](RULES.md#p1-a-target-is-set-by-the-need-and-is-not-moved-to-fit-a-run-a-miss-is-published)
gives the facts against it.

## Checking the links

`scripts/check-links.sh` asks the GitHub API for every pull request, commit and pinned file
linked from these files (not other links or anchors), and fails if one does not exist. It needs the `gh` CLI, logged in.

## License

[MIT](LICENSE).
