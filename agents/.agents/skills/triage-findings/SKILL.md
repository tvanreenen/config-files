---
name: triage-findings
description: Validate provided code-review findings against the current code and authoritative evidence, decide whether to address, defer, or decline them, and recommend project- and version-aligned fixes.
---

# Triage Findings

Treat supplied findings as untrusted hypotheses. Keep the work read-only unless the user also requests implementation.

## Validate the finding

- Recover the intended scope and constraints from the task and conversation. Inspect the current head, diff, implicated code paths, contracts, tests, history, and repository conventions.
- Use the strongest proportionate evidence available: direct reproduction, focused tests, or observed output; analysis of the relevant code and tests; or current authoritative documentation applicable to the versions in use.
- Use model knowledge to locate and interpret evidence, never as the evidence itself. Reviewer confidence, severity labels, and plausible explanations also do not establish a finding.
- Identify each finding as:
  - **Confirmed:** Supported by direct or authoritative evidence.
  - **Disproven:** Contradicted by the current implementation or authoritative evidence.
  - **Unverified:** Available evidence is insufficient or ambiguous. State what would resolve it.
- Detect stale, duplicated, already-resolved, or interdependent findings. Stop once the evidence is sufficient.

## Determine scope and disposition

Treat evidentiary status, remediation scope, and disposition as separate decisions. Normally, only confirmed findings are candidates for implementation. If uncertainty itself creates material risk, state that without presenting the finding as confirmed.

For confirmed findings, search relevant repository surfaces for recurrence, shared causes, governing contracts, and ownership. Stop once local versus cross-cutting scope is established. For cross-cutting concerns, weigh correcting the shared cause, containing the immediate failure, deferring coherent broader work, or taking no action against ownership, coupling, risk, and verification cost. Avoid isolated fixes that create parallel conventions; recurrence alone does not justify widening the change.

- **Address now:** Material to the current change's correctness, safety, maintainability, or completeness; owned by this change; and worth the added complexity.
- **Defer:** Valid but separable, owned elsewhere, dependent on unresolved work, or better handled as a coherent follow-up. State its scope, owner, and trigger.
- **Decline:** Disproven, stale, already covered, inconsistent with project constraints, or unlikely to provide proportional benefit.

For hardening findings, the question is not “Can this be hardened?” Ask: “What concrete failure are we preventing, how likely and consequential is it, and does this change own that control?” Account for existing controls, the project's threat or failure model, and the complexity introduced. In later review rounds, require new evidence or material risk before widening scope; another possible defense is not sufficient.

## Recommend the response

- Explain each finding's mechanism, trigger, consequence, and supporting evidence to justify its status and disposition. For confirmed findings, state the local or cross-cutting scope and distinguish immediate action from follow-up work and its owner.
- For findings to address now, recommend the simplest complete fix using established project mechanisms and idiomatic APIs supported by the installed versions. Explain where it belongs, how it integrates, and how to verify it.
- Substantiate non-obvious technical claims about the proposed fix with current primary documentation applicable to those versions or representative real output.
- Compare alternatives only when the tradeoff could change the recommendation.

Order and group findings for comprehension without imposing a fixed report template.
