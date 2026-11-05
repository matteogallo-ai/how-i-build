# how-i-build

Docs-only repo: how I build and own Verity, Praxis and PromptLang, with each claim linked
to the pull request, commit or file that proves it. Global standards: `~/.claude/CLAUDE.md`.

- `README.md`: the method and its proofs. `RULES.md`: rules and their incidents.
  `DECISIONS.md`: technical decisions and their state. `DEFINITION_OF_DONE.md`.
- Check: `scripts/check-links.sh` (needs `gh`, logged in). CI runs it as the `check-links`
  job on each push; each pull request to `main` is gated on it.

## Appendix A — How coding agents must work in my repos

Every repo's `CLAUDE.md` reproduces this appendix verbatim, below a short repo-specific
section (what it is, layout, exact commands). Its purpose: make the agent engineer, not
generate.

### Engineer, don't generate
1. **Read before you write.** Find the existing module, contract and test for what you are
   changing. Extend it; never create a parallel version.
2. **Smallest change that meets the acceptance criteria.** No speculative abstractions, no
   "for future use" parameters, no options nobody asked for.
3. **Second copy = extract.** About to paste a helper? Move it to a shared module and test it once.
4. **Failing test first** for every bug: show it red, then fix, then show it green.
5. **Name the failure modes** of what you write (timeout, empty input, malformed model output,
   provider down, oversized input, hostile content) and test the ones that matter.
6. **Comments explain why — never what, never when.** No sprint IDs, no "will be added later",
   no restating the code.
7. **Deterministic code over model calls** whenever the answer is computable. The model
   proposes; code validates.
8. **Never report success without the command output that proves it.**
9. **Challenge with evidence.** If an instruction, finding or ADR looks wrong, say so with file,
   line and output — do not comply silently, do not "fix" something that is not broken.
10. **Explain trade-offs** in the PR: what you chose, what you rejected, why.
11. **Independent review before handing back**: a fresh-context reviewer subagent checks the
    diff against these standards; report what it found, what you fixed, what you rejected and why.

### Forbidden
- Claiming in README/docs a feature that has no passing test listed in `docs/CLAIMS.md`.
- Future tense or sprint references in source code or docs.
- Presenting any score computed on a stub, mock or fixture as a quality measure.
- Concatenating untrusted content (retrieved, ingested, scraped, tool output) into a prompt
  without delimiters and an explicit untrusted-content instruction.
- Catch-all exception handlers without a justifying comment and a typed re-raise or log.
- Secrets held in plain strings where the framework offers a secret type
  (e.g. pydantic `SecretStr`).
- Any paid model call without a cost estimate and explicit approval.
- Commits over ~400 changed lines (lockfiles and generated artefacts excluded).
- Pushing to main, force-pushing, tagging or publishing: the human does that. Pushing a work
  branch and opening a PR is allowed; GitHub rulesets protect main and release tags.

### Report format (end of every work unit, in French for Matteo)
1. What changed, point by point. 2. Evidence: commands + outputs. 3. Audit findings disproved,
with proof. 4. Reviewer findings: fixed / rejected + why. 5. Open items. 6. Walkthrough per
changed module — what it does, why this design, how it is verified, how it breaks — written
for someone who pilots agents well but did not hand-write the code. 7. Five comprehension
questions Matteo must answer before merging (expected answers folded at the end).
