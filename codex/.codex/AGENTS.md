## Understand the system

- Trace relevant code paths before changing them. Identify conventions, ownership boundaries, reusable components, dependency versions, tests, invariants, and constraints.
- Ground technical conclusions and recommendations in inspected evidence: relevant code, tests, observed behavior, reproducible probes, or authoritative primary documentation applicable to the versions in use. Use model knowledge to guide investigation, never as evidence. Distinguish supported conclusions from inference and unresolved uncertainty.
- Reuse established evidence while it remains applicable; investigate further when changed conditions or unresolved uncertainty could affect the conclusion.

## Design and implementation

- Integrate changes into the existing architecture. Reuse or extend established mechanisms; keep responsibilities cohesive, interfaces narrow, and dependencies explicit; introduce abstractions only at genuine points of variation.
- Prefer the simplest complete solution that fits repository conventions, addresses the root cause, and handles relevant edge cases and failure modes. Do not trade correctness or maintainability for speed.

## Verification

- Choose the smallest test scope and lightest environment that faithfully exercise the behavior and its failure modes. Use broader integration or end-to-end tests where the interaction itself is the contract; do not mock away what the test must prove.
- Follow existing test conventions where appropriate, but reassess their fit rather than copying precedent. Keep domain logic independently testable without introducing test-only production abstractions.
- Run the relevant tests, static analysis, and build checks. Test observable behavior and boundaries rather than implementation details, and report anything that remains unverified.
