---
name: fix-findings
description: Implement triaged code-review findings with evidence-backed, project-aligned fixes and coherent local commits, then present the changes for review before pushing.
---

# Fix Findings

Implement the findings selected for action in the completed triage or explicitly selected by the user. Use the conversation and supplied triage to recover scope, evidence, proposed remedies, and verification needs. If the selected findings cannot be identified, ask for the missing scope before editing.

## Substantiate and implement

- Check the current branch, working tree, implicated code paths, and applicable repository guidance. Preserve unrelated work and keep it out of fix commits.
- Confirm that each selected finding and proposed remedy still apply to the current code. Revisit triage only when new evidence changes it; report stale, resolved, or unsupported findings instead of forcing a fix. Keep deferred and declined findings outside the implementation scope unless the user changes their disposition.
- Correct the root cause within the agreed scope. Follow the project's architecture, ownership, conventions, and test strategy; reuse established mechanisms and idiomatic, supported APIs for its actual language, framework, and library versions.
- Substantiate non-obvious technical choices with current primary documentation applicable to those versions, direct reproduction, focused tests, or representative observed output. Model recollection and reviewer assertions are not evidence. Research until the relevant uncertainty is resolved, without expanding into a general audit.
- Validate the changed behavior and relevant boundaries. For behavioral defects, prefer a focused regression test that demonstrates the failure before the fix and passes afterward when practical. Run applicable tests, static analysis, and build checks; investigate failures and distinguish pre-existing failures from regressions. State any verification gaps without claiming unobserved results.

## Commit locally and present for review

- Prefer one local commit per independent finding, including its implementation and relevant tests. Group findings when they share a root cause or must change together to form a coherent, verifiable fix; explain the grouping. Avoid splitting changes into commits that knowingly leave the code broken.
- Inspect each staged diff before committing and include only the intended fix. Follow repository commit conventions and describe the concrete problem and resulting behavior.
- Present the completed changes with commit hashes, the findings each addresses, supporting evidence, validation results, and any remaining uncertainty or unaddressed findings. Make the local result ready for the user's review.
- Do not push until the user has had the completed changes to review and explicitly approves pushing them. Invoking this skill authorizes local implementation and commits, not publication. Do not post review replies or resolve remote review threads without explicit authorization.
