---
name: prepare-pr-artifacts
description: Evaluate the changes on the current branch and draft a PR title, PR description, and squash merge commit message. Use when Codex needs to inspect a git diff, compare a branch against its base, or prepare pull request copy for GitHub or similar review systems. Prefer this skill when the user wants sentence-style titles and commit subjects instead of conventional commit prefixes, and when the squash merge commit body should preserve most of the change detail.
---

# Prepare PR Artifacts

## Overview

Inspect the branch against its most likely base branch and turn the diff into three outputs: a PR title, a PR description, and a squash merge commit message. Keep titles and commit subjects in sentence style, and avoid `feat:`, `fix:`, and similar type prefixes.

## Inspect the change

- Honor a user-specified base branch or target branch when one is given.
- Otherwise, infer the base branch from local git metadata. Prefer the default remote branch if it is available locally.
- Use the diff as the source of truth. Review commit messages for context, but do not let weak commit hygiene distort the summary.
- Check both breadth and depth: changed files, diff hunks, and the commit range between base and `HEAD`.
- Call out testing only when there is clear evidence in the branch or the user provides it.

Useful local commands:

```bash
git branch --show-current
git symbolic-ref refs/remotes/origin/HEAD
git merge-base HEAD <base-branch>
git log --oneline <base-branch>..HEAD
git diff --stat <base-branch>...HEAD
git diff <base-branch>...HEAD
```

## Choose the story

- Center the summary on the change's purpose, not on a file-by-file inventory.
- Favor the user-visible outcome or architectural intent over implementation trivia.
- Separate substantive work from mechanical edits such as formatting, generated files, or broad renames.
- If the branch contains multiple unrelated changes, say so plainly instead of inventing a cleaner narrative.

## Draft the PR title

- Write one sentence-style subject line.
- Avoid conventional commit prefixes such as `feat:`, `fix:`, `chore:`, and bracketed tags.
- Prefer a concrete verb and object.
- Keep it specific enough to distinguish this branch from neighboring work.
- Omit the trailing period unless the user or repo style clearly prefers one.

## Draft the PR description

- Keep the PR description shorter than the squash merge commit message.
- Explain what changed and why, not every touched file.
- Include implementation notes only when they help reviewers understand tradeoffs, risks, migrations, or rollout details.
- Include testing when known. If testing is unknown or absent, say that directly.

Prefer this structure:

```markdown
## Summary
- Explain the main change.
- Mention the most important supporting details.

## Testing
- List the testing that was run.

## Notes
- Add only when there are migrations, risks, follow-ups, or reviewer callouts.
```

## Draft the squash merge commit message

- Use a sentence-style subject line. It can match the PR title or a tighter variant.
- Put most of the durable detail here because hosted PR metadata may not survive forever.
- After the subject, add a blank line and a body that captures the motivation, key implementation decisions, important behavior changes, and testing status.
- Prefer a compact body with short paragraphs or concise bullets.
- Preserve enough context that a future reader can understand the change from git history alone.
- Do not simply paste the PR description into the commit body. The commit message should usually be richer.

## Return the result

Return all three artifacts unless the user explicitly asks for a subset.

Use this structure:

- `PR title`
- One sentence-style title line
- `PR description`
- A short markdown description with `Summary`, `Testing`, and optional `Notes`
- `Squash merge commit message`
- A plain-text commit message with a subject line, a blank line, and a richer body than the PR description
