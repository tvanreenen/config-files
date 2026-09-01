---
name: prepare-pr
description: Draft or revise self-contained, reviewer-accessible PR titles and descriptions from branch, repository, and task context. Use for writing, reviewing, improving, or publishing PR copy on any Git host. Publish only when explicitly requested and after confirming GitHub hosting.
---

# Prepare PR

## Establish the PR scope

- Honor a user-specified base or target branch.
- Otherwise, infer the base from `origin/HEAD` or other local Git metadata.
- Use the complete branch diff against the merge base as the source of truth. Use repository and current task context to interpret intent; treat commit messages as supporting context, not the narrative.
- When revising an existing PR, inspect its current title and description alongside the final branch diff and relevant repository and task context.
- Identify uncommitted changes and whether they fall outside the PR scope.

## Write the PR

- Write a proportionate, self-contained narrative for a reviewer who has not followed the task or conversation. Give the context needed to understand the problem, primary outcome, approach, and verification without turning the body into an implementation log.
- Explain non-obvious decisions and material risks, mitigations, or tradeoffs where they help evaluate the approach.
- Disclose ancillary work without letting it obscure the main change, and organize by reviewer significance rather than file order or implementation chronology.
- If the branch contains unrelated changes, say so instead of forcing a unified story.
- Report only testing evidenced by the branch or provided by the user; state directly when it is absent or unknown.
- Do not invent unsupported rationale or assurances.

### Title

- Name the primary outcome with a concrete verb and object in one sentence-style subject line.
- Keep it specific enough to distinguish the branch from neighboring work.
- Avoid conventional commit prefixes, bracketed tags, and a trailing period unless repository conventions require them.

### Description

- Choose the structure, section names, and level of detail that make this particular change easiest to understand. Follow useful repository conventions, but do not impose a stock template.
- Use prose, bullets, and headings only where they improve the story. A focused fix may need little structure; a broad feature may need distinct context for behavior, decisions, migration, rollout, risks, or verification.
- Keep every section purposeful and omit empty boilerplate.

## Publish when requested

Only create, open, or publish the PR when the user explicitly requests it.

1. Inspect `origin` to determine the hosting provider.
2. For any other provider, return the draft title and description and explain that publication was not attempted because this skill publishes only through GitHub CLI.
3. For GitHub or GitHub Enterprise, require a non-default branch, a clean working tree, committed PR scope, and an authenticated `gh` session; then confirm the repository with `gh repo view`.
4. Before ordinary publication, determine whether the branch or PR has local `gh stack` tracking or remote GitHub stack membership. If either is present, use `$manage-stack` and its stack-aware publication flow.
5. Otherwise, push the branch with upstream tracking, write the body to a temporary file, and run `gh pr create` with explicit base, head, title, and body arguments.
6. Create an ordinary PR as a draft and assign the authenticated user with `--draft` and `--assignee @me`. Honor explicit requests for a ready PR, a different assignee, or no assignee.

## Return the result

Return the title, markdown description, and any scope assumptions or missing verification. After publication, also return the PR URL, head and base branches, draft status, and assignee.
