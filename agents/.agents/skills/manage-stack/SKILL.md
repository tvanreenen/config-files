---
name: manage-stack
description: Manage GitHub stacked pull requests with `gh stack`. Use for creating, linking, submitting, navigating, rebasing, syncing, restructuring, or merging a stack; when GitHub stack membership or local `gh stack` tracking is present; or when dependent PRs may require stack-aware handling.
---

# Manage Stack

## Establish the stack and scope

- Confirm that the repository is hosted on GitHub and that `gh stack` is available.
- Treat dependent branches, local `gh stack` tracking, and remote GitHub stack membership as distinct states. Do not create or link a GitHub stack solely because branches depend on one another.
- Inspect the complete set of branches and PRs affected by the requested operation. Ask before acting only when the operation would unexpectedly create, update, or merge additional PRs outside the user's apparent scope.

## Use the stack-aware operation

- Before acting, inspect the installed `gh stack <operation> --help` and current first-party GitHub stacked-PR documentation.
- Supply explicit arguments and non-interactive flags. If the stack-native operation has no non-interactive path, explain the limitation instead of substituting manual branch surgery.
- Use stack-native operations for submission, linking, rebasing, synchronization, restructuring, and merging. Do not substitute `gh pr merge` or manual rebase and retarget sequences.
- Use ordinary `gh pr` commands only for metadata or behavior that `gh stack` does not provide.
- When publication creates multiple PRs, apply `$prepare-pr`'s narrative standard to each new PR. Keep them as drafts and assign the authenticated user unless the user requests otherwise, using `gh pr` afterward when the stack command cannot set that metadata.

## Verify the result

Verify the stack order, trunk, PR bases, local and remote membership, and status after the operation. Return every affected PR and disclose anything that remains unverified.
