---
name: audit-architecture
description: Audit a codebase for architectural friction, prioritize evidence-backed improvement opportunities, and recommend where deeper design work is warranted.
---

# Audit Architecture

Audit architectural friction. Keep the work read-only unless the user's request also includes implementation or documentation changes.

## Process

### 1. Explore

- Use the user's scope. Otherwise, inspect change history for recurring hot spots and focus on recently active or operationally important areas before widening the scan.
- Ground candidates in repository evidence, including change history, domain glossaries, ADRs, and operational evidence when available.
- Look for shallow or pass-through modules; fragmented responsibilities or invariants; duplication and parallel conventions; misplaced dependencies, cycles, or excessive fan-in and fan-out; leaking coordination or cross-cutting concerns; temporal, deployment, or failure coupling; and behavior that is difficult to test through its interface.
- Apply the deletion test to suspected shallow modules. Recommend change only where concrete friction or likely change justifies it.

### 2. Present the candidates

- Present the strongest candidates with their scope, friction, proposed direction, benefit, material risks or tradeoffs, and supporting evidence. Use repository terminology, organize for comprehension, and add diagrams only when useful.
- Reconsider recorded decisions only with new evidence; identify ADR conflicts and explain why reconsideration is warranted.
- Recommend the candidate to address first and explain why. Proceed to interface design when the user selects a candidate or delegates that selection.

### 3. Hand off deeper design

- Use `$design-architecture` for the selected candidate.
- Identify accepted domain knowledge that belongs in repository guidance. For a durable, non-obvious rejection, offer an ADR so later audits do not repeat it.
- Offer `$pressure-test` for consequential unresolved decisions, but invoke it only when the user explicitly requests it.
