---
name: prepare-pr
description: Draft or revise self-contained, reviewer-accessible PR titles and descriptions from branch, repository, and task context. Use when writing, reviewing, improving, or publishing PR copy on any Git host. Create or update a hosted PR only when explicitly requested and after confirming GitHub hosting.
---

# Prepare PR

## Establish scope

- Honor a user-specified base branch; otherwise infer it from `origin/HEAD` or other local Git metadata.
- Use the complete committed diff against the merge base as the source of truth. Use repository and task context to understand intent; treat commit messages as supporting evidence, not the narrative.
- When revising an existing PR, inspect its current title and description alongside the final branch diff.
- Identify uncommitted changes and any committed changes that do not fit the primary scope.

## Draft the PR

### Title

- Name the primary outcome with a concrete verb and object, specific enough to distinguish the PR from neighboring work.
- Use a sentence-style subject line without conventional commit prefixes, bracketed tags, or a trailing period unless repository conventions require them.

### Description

- Write a proportionate, self-contained narrative for a reviewer who did not follow the task. Treat the PR body as a durable reviewer artifact, not a summary of the conversation. Preserve the context needed to understand the problem, outcome, approach, verification, and relationship to surrounding work; when shortening, cut repetition before necessary context.
- Center the primary change and organize by reviewer significance, not file order or implementation chronology. Disclose ancillary work without letting it obscure the story; if the diff contains unrelated changes, say so rather than inventing a unified narrative.
- Explain non-obvious decisions and material risks, mitigations, or tradeoffs that affect review.
- Ground rationale and assurances in available evidence. Report only verification evidenced by the branch or user, and state gaps directly.
- Choose the structure and level of detail that make the change easiest to understand. Follow useful repository conventions, but do not impose a stock template or retain empty boilerplate. A focused fix may need a short narrative; a broad or risky change may need distinct context for behavior, decisions, migration, rollout, risks, or verification.
- Do not hard-wrap prose at a fixed column width. Keep each paragraph on one logical line and preserve only line breaks required by Markdown structure.

## Update GitHub only when requested

Drafting or revising PR copy does not authorize a remote change. Create or update a hosted PR only when the user explicitly requests it.

1. Inspect `origin` to determine the hosting provider.
2. For a non-GitHub host, return the proposed title and description without attempting publication.
3. For GitHub or GitHub Enterprise, confirm the repository and authenticated account with `gh`.
4. Before ordinary publication, check for local `gh stack` tracking and remote GitHub stack membership. If either is present, follow `$manage-stack`.
5. For an ordinary existing PR, write the body to a temporary file and update the explicitly targeted PR with `gh pr edit`.
6. For a new ordinary PR, require a non-default branch, a clean working tree, and committed PR scope. Push with upstream tracking, write the body to a temporary file, and run `gh pr create` with explicit base, head, title, and body arguments.
7. Create a new ordinary PR as a draft and assign `@me`. Honor explicit requests for a ready PR, another assignee, or no assignee.

## Return the result

Return the title, Markdown description, scope assumptions, and missing verification. After a remote update, also return the PR URL, head and base branches, draft status, and assignee.
