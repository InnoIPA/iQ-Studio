---
name: iq-studio-commit-log
description: "Use for iQ-Studio commit message drafting, commit-log review, and deciding how to split staged or unstaged changes into commits. Apply when the user asks for a commit log, commit message, git commit style, or repository commit principle guidance."
---

# iQ-Studio Commit Log

## Purpose

Use this skill to draft commit logs that match the iQ-Studio repository history and keep commits focused, reviewable, and easy to trace.

Expected output: one or more commit messages, with a short rationale when staging state or commit scope matters.

## Scope Summary

Use this skill when the user asks for a commit log, commit message, commit review, commit split, changelog-oriented summary, or guidance on what staged changes should become. The skill turns a diff into a short, consistent message that helps future developers understand why the change exists and what changed.

Do not use this skill to rewrite code or documentation content. Use it after the change scope is known, or while deciding how to split the scope before committing.

## Highest Principles

- A commit should tell a future teammate what changed and why it matters, not merely list touched files.
- One commit should represent one reviewable idea. Split unrelated work before drafting the final log.
- Prefer the staged area as the source of truth. Do not silently include unstaged or line-ending-only changes.
- Make the subject concise enough to scan in `git log --oneline`; use the body only for context that the subject cannot carry.
- If the change fixes a bug with external tracking, ask for or include the issue ID. Bugs should be traceable.

## Workflow

1. Inspect the current scope:
   - `git status --short --untracked-files=all`
   - `git diff --cached --name-status`
   - `git diff --name-status`
2. Compare against recent history:
   - `git log --oneline -n 30`
3. Prefer the staged scope when the user already staged files. Mention unstaged changes only when they are relevant, surprising, or likely accidental.
4. If many files are modified, check whether the change is real content or mechanical noise:
   - `git diff --ignore-space-at-eol --stat`
   - `git ls-files --eol` when line endings may explain CLI/GUI differences.
5. Before drafting, answer internally:
   - What changed?
   - Why was this change needed?
   - How was it changed, if the implementation detail matters?
   - What improved for users, maintainers, or the release flow?
6. Draft the smallest commit message that honestly covers the staged changes. Suggest a split only when unrelated changes are mixed together.

## Commit Format

Use this shape by default:

```text
type: subject

Body, when useful:
- What changed
- Why it changed
- How it improves the workflow

Issue: ID, when available
```

Rules:

- `type` is lowercase and comes from the type table.
- Do not use a scope. Write `docs: ...`, not `docs(avl): ...`.
- Keep the subject under about 50 characters when practical. Never end it with a period.
- Keep the body separated from the subject by a blank line.
- Use the body for "what/why/how/improvement" context, not for repeating file names.

## Subject Style

Prefer the repository's existing Conventional Commit style:

| Type | Use for |
| :--- | :--- |
| `feat` | New or changed user-facing functionality. |
| `fix` | Bug fixes and behavior corrections. |
| `docs` | README, tutorial, benchmark, changelog, and documentation-only updates. |
| `style` | Formatting-only changes that do not affect runtime behavior. |
| `refactor` | Code restructuring that is neither a feature nor a bug fix. |
| `perf` | Code changes that improve performance. |
| `test` | Adding, updating, or repairing tests. |
| `chore` | Maintenance, config, scripts, build tooling, repository organization, metadata, or file moves. |
| `revert` | Reverting an earlier commit; include the reverted commit reference when known. |
| `merge` | Branch merge commits when preserving a merge-generated message. |

Use sentence case after the prefix, keep the subject concise, and do not end it with a period.

Examples:

```text
docs: update model deploy navigation and doc links
fix: support custom class counts and fail fast on class-count mismatches
chore: reorganize AI Hub YOLO workflow files
refactor: remove unused YOLO26 pipeline files
```

## Body Style

Use a body only when it adds useful context. Keep bullets short and action-oriented:

```text
chore: organize iQ-Studio guidance

- move the agent entry guide under .agents
- add focused agent, formatting, literacy, and commit-log skills
- replace legacy IQS docs with skill-based references
```

Longer examples:

```text
feat: add onUrlChange event

- forward popstate events when available
- fall back to hashchange events for older browsers
- poll only when neither event type is available

Breaks: $browser.onHashChange was removed; use onUrlChange instead.
```

```text
fix: adjust IE9 unit expectations

Older IE versions serialize HTML uppercase, but IE9 does not.
Use case-insensitive expectations where the test framework allows it.

Closes: #392
Breaks: foo.bar API was removed; use foo.baz instead.
```

For release or merge commits, preserve the branch/PR-generated style instead of forcing a prefix.

## Commit Splitting

Prefer separate commits when changes have different review concerns:

- Docs content updates vs launcher/runtime behavior.
- Functional code changes vs generated images or benchmark outputs.
- Mechanical line-ending normalization vs real content edits.
- File moves/reorganization vs unrelated prose or feature changes.

When only line endings changed, recommend either excluding them from the current commit or using a dedicated commit:

```text
chore: normalize repository line endings
```

## Gotchas

- Do not include unstaged changes in the proposed commit message unless the user asks for a whole-working-tree commit.
- Do not overstate behavior changes when the diff only moves files or updates references.
- Do not invent issue numbers, release versions, or PR numbers.
- If `tools/README.md` or another file is `MM`, explain that it has both staged and unstaged changes before proposing a final message.
