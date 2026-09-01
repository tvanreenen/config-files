---
name: audit-architecture
description: Audit a codebase for architectural friction, prioritize evidence-backed improvement opportunities, and recommend where deeper design work is warranted.
---

# Audit Architecture

Perform a read-only audit for architectural friction.

## Process

### 1. Explore

- Use the user's scope. Otherwise, inspect change history for recurring hot spots and focus on recently active or operationally important areas before widening the scan.
- Ground candidates in repository evidence, including change history, domain glossaries, ADRs, and operational evidence when available.
- Look for shallow or pass-through modules; fragmented responsibilities or invariants; duplication and parallel conventions; misplaced dependencies, cycles, or excessive fan-in and fan-out; leaking coordination or cross-cutting concerns; temporal, deployment, or failure coupling; and behavior that is difficult to test through its interface.
- Apply the deletion test to suspected shallow modules. Recommend change only where concrete friction or likely change justifies it, and do not re-litigate recorded decisions without new evidence.

### 2. Present the candidates

- Present only the strongest evidence-backed candidates, organized for comprehension rather than file order or a fixed template.
- Make each candidate's scope, friction, direction, benefit, risks or tradeoffs, and strength of evidence clear. Use repository domain language and diagrams only when they materially aid understanding.
- Identify ADR conflicts and the evidence for reconsidering them.
- Recommend the candidate to address first and explain why. Do not design interfaces until the user selects a candidate.

### 3. Hand off deeper design

- After the user selects a candidate, use `$design-architecture` to examine its constraints, dependencies, module shape, seams, adapters, testing implications, and materially plausible interfaces.
- Identify accepted domain knowledge that belongs in repository guidance. For a durable, non-obvious rejection, offer an ADR so later audits do not repeat it.
- Offer `$pressure-test` for consequential unresolved decisions, but invoke it only when the user explicitly requests it.
- Keep the audit read-only unless the user separately requests implementation or documentation changes.
