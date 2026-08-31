---
name: review-findings
description: Validate provided code-review findings against the current code and authoritative evidence, decide whether to address, defer, or decline them, and recommend project- and version-aligned fixes.
---

# Review Findings

Validate the supplied findings rather than accepting or extending them. Keep the work read-only unless the user also requests implementation.

## Validate the finding

- Treat each finding as an untrusted hypothesis.
- Recover the intended scope and constraints from the task and conversation. Inspect the current head, diff, implicated code paths, contracts, tests, history, and repository conventions.
- Use the strongest proportionate evidence available: direct reproduction, focused tests, or observed output; analysis of the relevant code and tests; or current authoritative documentation applicable to the versions in use.
- Use model knowledge to locate and interpret evidence, never as the evidence itself. Reviewer confidence, severity labels, and plausible explanations also do not establish a finding.
- Identify each finding as:
  - **Confirmed:** Supported by direct or authoritative evidence.
  - **Disproven:** Contradicted by the current implementation or authoritative evidence.
  - **Unverified:** Available evidence is insufficient or ambiguous. State what would resolve it.
- Detect stale, duplicated, already-resolved, or interdependent findings. Stop once the evidence is sufficient; do not expand this into a new general review.

## Decide the disposition

Assess disposition separately from evidentiary status. Normally, only confirmed findings are candidates for implementation. If uncertainty itself creates material risk, state that explicitly rather than presenting the finding as confirmed.

- **Address now:** Material to the current change's correctness, safety, maintainability, or completeness; owned by this change; and worth the added complexity.
- **Defer:** Valid but separable, owned elsewhere, dependent on unresolved work, or better handled deliberately in a follow-up. State the follow-up scope and trigger.
- **Decline:** Disproven, stale, already covered, inconsistent with project constraints, or unlikely to provide proportional benefit.

For hardening findings, the question is not “Can this be hardened?” Ask: “What concrete failure are we preventing, how likely and consequential is it, and does this change own that control?” Account for existing controls, the project's threat or failure model, and the complexity introduced. In later review rounds, require new evidence or material risk before widening scope; another possible defense is not sufficient.

## Recommend the response

- Explain the finding's mechanism, triggering conditions, and consequence in enough detail to support its evidence status and disposition.
- For findings to address now, recommend a fix in enough detail to show where it belongs, how it integrates with the existing code, and how it should be verified.
- Prefer the simplest complete fix that fits existing ownership boundaries, abstractions, naming, dependencies, and test strategy. Reuse or extend established mechanisms instead of introducing parallel conventions.
- Use idiomatic, supported APIs and patterns for the repository's actual language, framework, and library versions.
- Substantiate non-obvious language, framework, library, protocol, or provider claims with current primary documentation applicable to those versions or representative real output.
- Compare alternatives only when the tradeoff could change the recommendation. State remaining uncertainty without inventing certainty.

Present the findings in the order that best explains the change. Group related findings where useful, and make the evidence, disposition, reasoning, proposed action, and verification clear without imposing a fixed report template.
