---
name: post-review-disposition
description: Post concise GitHub PR dispositions for the review comments already triaged in the task, explaining what was completed, deferred, or left unchanged and why.
---

# Post Review Disposition

Post disposition responses on the explicit pull request, or the pull request for the current branch.

- Treat the comments triaged in the conversation, or explicitly selected by the user, as the complete disposition set. Account for each once; do not include unrelated feedback.
- Ground each disposition in the completed triage, resulting changes, and verification. State any evidence gap instead of overstating what was fixed or verified.
- Explain what was addressed, deliberately deferred, or left unchanged and why. Distinguish confirmed defects from optional hardening or broader suggestions.
- Match the response to the comment surface:
  - For selected general PR conversation comments, post one grouped disposition for the set triaged together.
  - For selected inline review comments, reply directly and narrowly in each original review thread.
- Keep responses concise, factual, and non-defensive. Before posting, confirm the current head and avoid duplicates. Use `gh pr comment` for general comments and the review-comment reply endpoint for inline threads.
