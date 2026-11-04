# Rules

Each rule has three parts: the rule, the incident that created it, and the link where the
incident and the fix can be read. A rule without an incident is not numbered as a rule; the two practices at the end say so.

## Dependencies and git

### R1. Each major dependency bump gets its own pull request
**Incident.** Verity already kept majors out of its groups. Praxis and PromptLang did
not. In PromptLang, Dependabot grouped `typescript` 5.9 → 7.0 (major) with `@types/bun`
1.3 → 1.4 (minor). TypeScript 7 removed `baseUrl` (`error TS5102`), so typecheck, tests
and packaging failed, and the minor bump could not merge either.
**Links.** Grouped PR, closed: [promptlang#6](https://github.com/matteogallo-ai/promptlang/pull/6).
Fix of the breaking half: [promptlang#17](https://github.com/matteogallo-ai/promptlang/pull/17).
Rule in config: [promptlang#16](https://github.com/matteogallo-ai/promptlang/pull/16),
[praxis#12](https://github.com/matteogallo-ai/praxis/pull/12).
The rule at work: TypeScript 7 then arrived in Praxis as its own PR,
[praxis#14](https://github.com/matteogallo-ai/praxis/pull/14).

### R2. Never delete the base branch of a stacked pull request before retargeting it
**Incident.** PR #3 was stacked on `fix/audit-part-b`. When #2 merged, that branch was
deleted, and GitHub closed #3 unmerged. The same commits were reopened as #7. The same PR
also found that CI ran only on PRs to `main`, so a stacked PR ran no check at all.
**Links.** Closed: [praxis#3](https://github.com/matteogallo-ai/praxis/pull/3).
Reopened, with CI on every base: [praxis#7](https://github.com/matteogallo-ai/praxis/pull/7).

## Tests

### R3. No test breaks as time passes
**Incident.** Run with the wall clock at 2029, six tests failed, four of them through a
spawned CLI. Two bare `setSystemTime()` resets sent every later test file back to the
real date. The fix is an injectable UTC clock (`PRAXIS_NOW`) and a CI job that runs the
suite at 2029 and 2040. One test reads the real date on purpose (`last_reviewed` must not
lie in the future); the PR says so.
**Link.** [praxis#7](https://github.com/matteogallo-ai/praxis/pull/7).

### R4. When an answer is cut at `max_tokens`, the limit goes to 2× the cut point, from the run record
**Incident.** Cut answers were already refused as errors
([praxis#19](https://github.com/matteogallo-ai/praxis/pull/19),
[promptlang#23](https://github.com/matteogallo-ai/promptlang/pull/23)). The first live run
of a briefing then stopped at the risk stage: cut at 16 000 tokens, after $0.92 of spend.
A cut answer only gives a lower bound on what it needed, so the limit went to 32 000, and a
test reads the committed run record to hold that 2× margin.
**Link.** [praxis#26](https://github.com/matteogallo-ai/praxis/pull/26).

## Spending

### R5. A spending cap reserves each request's worst case before sending it
**Incident.** The Praxis ledger checked only the spend already recorded. A briefing could
end above its cap by the requests still in flight, and a request that timed out was
never counted. Each request now reserves its worst case; a request that cannot be sized
is not sent under a cap.
**Link.** [praxis#22](https://github.com/matteogallo-ai/praxis/pull/22).

### R6. Every paid run the repo starts goes through the cap, scripts included
**Incident.** ADR 0004 said the budgeted client wraps every paid run. The live linter
script did not use it. The test showed it red: 5 calls sent where the cap allowed 3. The
code was fixed, not the ADR. The library's fallback client, which a caller can use
directly, stays uncapped; the PR names it.
**Link.** [promptlang#35](https://github.com/matteogallo-ai/promptlang/pull/35).

## Measurement

### R7. A human review is pre-registered, and its result is published as it came out
**Incident.** The AI linter's published precision (20%, 44/217) was a lower bound, because
categories nobody designed into a case counted as false alarms. The sample of 40 findings
was drawn with a fixed seed and committed unanswered before any annotation. The answered
review measured 30% (12/40, Wilson 95% CI 18.1–45.4%), which does not distinguish the
precision from the 20% bound. It is published with that reading.
**Links.** Protocol: [promptlang#37](https://github.com/matteogallo-ai/promptlang/pull/37).
Result: [promptlang#39](https://github.com/matteogallo-ai/promptlang/pull/39).

### R8. A question used for development is no longer held-out
**Incident.** Question 05 is in the test split, but seven sourcing fixes were designed from
its first live failures. It is now labelled "no longer held-out" in five files, and a test
requires the label.
**Link.** [praxis#40](https://github.com/matteogallo-ai/praxis/pull/40).

### R9. A change to a measurement plan is a dated amendment, never an edit of the plan
**Incident.** Step 1 of the live protocol needed a question that the first-party source
list covers. Instead of editing the plan, a dated `## Amendments` section adds it with its
reason and the step's new total ($70, five briefings at the existing $14 cap). A test
accepts only the original commands plus declared amendments.
**What the timestamps show.** Step 1 had already started (a first briefing failed at
12:56 UTC). The amendment was committed at 13:02:53 UTC, 78 s before question 10's own run
began, and merged after that run ended. The runs carry a code commit that does not contain
the amendment. The amendment came before the added question ran, not before the step.
**Link.** [praxis#41](https://github.com/matteogallo-ai/praxis/pull/41).

## LLM security

### R10. The LLM judge is attack surface; a new judge prompt is a new version with a new κ
**Incident.** Against Verity's faithfulness judge v0.1.0, a corpus document (or a draft
answer that echoes one) can address the judge directly and change the published quality
metrics. The κ measured on v0.1.0 says nothing about that. Judge v0.2.0 delimits,
neutralises and datamarks the evidence. Its rejudge stopped at its $1.30 cap after 52 of 60
claims; on those 52, agreement with blind human labels was κ 0.60 against 0.64 for v0.1.0.
No run of record uses v0.2.0.
**Links.** Threat model: [verity#27](https://github.com/matteogallo-ai/verity/pull/27).
v0.2.0 and κ: [verity#35](https://github.com/matteogallo-ai/verity/pull/35).

### R11. A pattern filter is not an injection defence on its own
**Incident.** Verity's injection defence was a regex list. A poisoned document written in
plain English shipped an invented answer end to end (audit finding M2). Retrieved text is
now also datamarked (whitespace replaced by a marker, per
[Hines et al., arXiv:2403.14720](https://arxiv.org/abs/2403.14720)); the regex list stays.
A natural-language injection set of 12 cases was run with and without marking: 0/12
attacks succeeded in both arms (95% CI 0–24%), so the effect of marking is not shown. Marking
raised mean input tokens per answer from 2,822 to 4,926.
**Link.** [verity#34](https://github.com/matteogallo-ai/verity/pull/34).

## Documentation

### R12. A document says what the code does today
**Incidents.**
- Verity's ADR 0004 said the prompts were compiled through PromptLang. That integration
  was never built. ADR 0005 supersedes it and records the local parser as the design.
  [commit a24e9c8](https://github.com/matteogallo-ai/verity/commit/a24e9c8)
- Verity's threat model said Dependabot opens grouped updates. Its first run opened 14 PRs,
  because majors stay out of the groups. The wording was fixed.
  [verity#23](https://github.com/matteogallo-ai/verity/pull/23)
- PromptLang's README gave recall as "98%", which was one run. It now gives each run:
  44/45 and 45/45. [promptlang#34](https://github.com/matteogallo-ai/promptlang/pull/34)

### R13. A human reads real output; the review finds what tests miss
**Incident.** My review of a live briefing (question 10) found risk estimates labelled as
first-party facts. ADR 0003 already excluded forecasts and evaluations; the code did not
apply it. The fix is in the validator; the review is published; no record was rewritten.
**Link.** [praxis#47](https://github.com/matteogallo-ai/praxis/pull/47).

## Production

### R14. Readiness reports a failed startup, and recovers without a restart
**Incident.** Verity already split `/health` from `/ready`
([verity#25](https://github.com/matteogallo-ai/verity/pull/25)). Its startup preload was
then found marked as done even when a corpus file failed, and only a restart recovered it.
`/ready` now returns 503 until the preload succeeds, and retries at most once per 5 s.
**Link.** [verity#29](https://github.com/matteogallo-ai/verity/pull/29).

## Releases

### R15. The release dry run is read line by line, and each warning is fixed
**Incident.** The dry run printed `npm warn publish "repository.url" was normalized` for
`@promptlang/yaml-parser`. npm provenance compares that URL with the repository, so the
package file now uses the published form.
**Link.** [promptlang#21](https://github.com/matteogallo-ai/promptlang/pull/21).

## Practices with no founding incident

These two came from the Definition of Done and the playbook, not from an incident. They are
listed apart, with cases where they were applied, because the README cites them.

### P1. A target is set by the need and is not moved to fit a run; a miss is published
**Applied.**
- Verity's p95 latency target is 15 s. The v1.0.0 run (n=16) measured 32.5 s (cold start
  included) and 22.4 s (warm). Both were published as "SLO not met", with the part of the
  cause the data supports. [verity#26](https://github.com/matteogallo-ai/verity/pull/26)
  The target did not move. The method did: models now preload before `/ready`
  ([verity#29](https://github.com/matteogallo-ai/verity/pull/29)) and the v1.1.0 run
  ([verity#35](https://github.com/matteogallo-ai/verity/pull/35)) starts with one warmup
  answer. That run measured 8.9 s warm (n=56), published as met; cold start is not
  measured as one sample.
- Praxis's cost target was $2.50 per briefing; the estimate was $5.75. The doc was
  published as "Not met" and a test pins the target.
  [praxis#25](https://github.com/matteogallo-ai/praxis/pull/25)

**The one time a target moved.** The Praxis cost target went from $2.50 to $10
([praxis#27](https://github.com/matteogallo-ai/praxis/pull/27)). The reason given: $10 is
10 minutes of an analyst at $60/h, and $2.50 priced that analyst at $15/h. The facts
against it:
- no reason for $2.50 had been written when it was set; the $15/h reading came later;
- the move came after the estimate showed a miss ($5.75 central) and after one live run
  that stopped at its fourth stage ($0.92);
- the six live runs that followed cost $3.29 to $4.75
  ([Praxis SLO.md](https://github.com/matteogallo-ai/praxis/blob/6cb01f4472b4cb4e341db6976c5d82f4e597807c/docs/SLO.md)):
  each would have missed $2.50.

The status is published only from live runs, and n=6 is labelled "no status". This entry is
here so the move can be challenged.

### P2. A context-free agent audits `main`; each finding is fixed, refuted or left open, in writing
**Applied.**
- Verity: 13 findings, among them a judge that read the string `"false"` as supported.
  Some findings stay open, with the reason. [verity#28](https://github.com/matteogallo-ai/verity/pull/28)
- PromptLang: 23 findings, fixed in #23–#31 or refuted in whole or in part (5) with
  evidence; one (C23, process) acknowledged. [promptlang#32](https://github.com/matteogallo-ai/promptlang/pull/32)
