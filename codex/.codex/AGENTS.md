## Understand the system

- Trace relevant code paths before changing them. Identify conventions, ownership boundaries, reusable components, dependency versions, tests, invariants, and constraints.
- Ground technical decisions in current, authoritative documentation. Prefer official primary sources and verify that guidance applies to the versions in use.

## Design and implementation

- Integrate changes into the existing architecture. Reuse or extend established mechanisms; keep responsibilities cohesive, interfaces narrow, and dependencies explicit; introduce abstractions only at genuine points of variation.
- Prefer the simplest complete solution that fits repository conventions, addresses the root cause, and handles relevant edge cases and failure modes. Do not trade correctness or maintainability for speed.

## Verification

- Run the relevant tests, static analysis, and build checks. Test observable behavior and boundaries rather than implementation details, and report anything that remains unverified.
