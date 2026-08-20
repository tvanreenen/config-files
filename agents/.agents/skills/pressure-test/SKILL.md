---
name: pressure-test
description: Thoroughly challenge a plan, decision, or idea through dependency-aware questions before implementation. Use only when the user explicitly invokes this skill to expose assumptions, resolve tradeoffs, and establish a shared understanding.
---

# Pressure Test

Establish a shared understanding of the plan, decision, or idea before acting on it. Be rigorous and direct without becoming theatrical or adversarial.

## Build the decision map

- Identify the objective, constraints, assumptions, decisions, dependencies, risks, and unresolved questions.
- Treat the work as a dependency graph. A question is ready only when its prerequisite decisions and facts are settled.
- Use the current conversation and available project context. For repository work, inspect the relevant code paths, conventions, dependencies, tests, and authoritative documentation before asking questions that this evidence can answer.
- For technical work, examine architectural fit, ownership boundaries, reuse, separation of concerns, seams, version constraints, and the verification strategy.
- Separate discoverable facts from user-owned decisions. Investigate facts yourself; ask the user only for intent, priorities, acceptable tradeoffs, and choices that materially change the result.

## Work in rounds

- In each round, ask the independent questions that are ready now. Defer questions that depend on unresolved answers.
- Keep the round focused. Combine closely related questions, but do not hide distinct decisions inside one prompt.
- For each question, explain why it matters, give concrete options when useful, and recommend an answer with concise reasoning.
- Challenge inconsistencies and weak assumptions. Surface important edge cases, failure modes, risks, mitigations, and tradeoffs.
- After the user responds, update the decision map and continue with the next ready questions.

## Finish

- Stop when no material decision remains unresolved or silently assumed.
- Summarize the agreed direction, key reasoning, accepted tradeoffs, remaining risks, and any intentionally deferred work.
- Ask the user to confirm the shared understanding before implementation or another consequential action begins.
