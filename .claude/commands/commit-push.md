---
description: Commit all working-tree changes and push the current branch
argument-hint: "[optional commit message]"
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*), Bash(git push:*), Bash(git branch:*), Bash(git rev-parse:*)
---

Commit every change in the working tree and push it.

## Context

- Branch: !`git branch --show-current`
- Status: !`git status --short`
- Diff summary: !`git diff HEAD --stat`
- Recent commits (match this style): !`git log --oneline -5`

## Steps

1. If there are no changes, say so and stop.
2. Review the diff (`git diff HEAD`, and read any untracked files). Stop and ask before committing if you find:
   - secrets, keys, tokens, or complete FCM tokens (`GoogleService-Info.plist` is client config and is fine);
   - build output, `DerivedData`, `xcuserdata`, `.DS_Store`, or other files that belong in `.gitignore`;
   - changes that look unrelated or accidental.
3. Stage everything with `git add -A`.
4. Commit. Use `$ARGUMENTS` as the subject if given; otherwise write one. Follow the repository style: a short imperative subject, sentence case, no trailing period, no type prefix (e.g. "Add call blocking security feature"). Add a brief body only when the change needs explanation. End the message with the attribution trailer required by the session, if any.
5. Push. If the branch has no upstream, use `git push -u origin <branch>`. Never force-push. If the push is rejected, report why and stop; do not rebase or merge without asking.
6. Report the commit hash, subject, and push result.
