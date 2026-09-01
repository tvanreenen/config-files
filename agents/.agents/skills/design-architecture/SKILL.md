---
name: design-architecture
description: Design or refactor module responsibilities, interfaces, seams, and dependency placement for cohesion, testability, locality, and leverage. Use for materially architectural changes or competing designs; skip routine work within an established structure.
---

# Design Architecture

Integrate architectural changes with the repository's established responsibilities, terminology, conventions, and constraints. Prefer architectural fit over abstract purity.

## Principles

- Design deep modules: substantial cohesive behavior behind narrow interfaces. Treat interface as everything callers must know, and depth as leverage rather than implementation size.
- Apply the deletion test. A useful module concentrates complexity; a pass-through merely relocates it.
- Recognize when a problem maps to an established data structure, algorithm, protocol, or industry standard. Prefer established solutions that fit the constraints; verify relevant semantics, complexity, interoperability, and version applicability from authoritative sources before introducing a custom mechanism.
- Place seams only where actual variation or meaningful ownership, volatility, failure, security, deployment, or external-system boundaries justify them. Keep test-only seams internal and avoid speculative adapters.
- Make variable dependencies explicit, and test observable behavior primarily through the public interface. Preserve focused coverage for distinct algorithms, invariants, performance, and failure modes.
- When restructuring, replace redundant tests of obsolete shallow modules rather than layering them beneath equivalent interface-level tests.

## Compare consequential alternatives

When materially different designs remain plausible, compare at least two from the same constraints and evidence. Consider the public surface, representative callers, hidden complexity, dependency strategy, repository fit, cohesion, locality, leverage, testability, likely change patterns, and material tradeoffs. Recommend the strongest design. Use a hybrid only when it is more coherent than either alternative.

## Boundary prompts

- When changing existing contracts, persisted state, or deployment topology, account for compatibility, staged migration, verification, rollback, and cleanup.
- Across process or network boundaries, resolve ownership, consistency, idempotency, ordering, concurrency, deadlines, retries, backpressure, partial failure, reconciliation, telemetry, and operational responsibility.
