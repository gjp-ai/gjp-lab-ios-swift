---
name: commit-push
description: Commit all working-tree changes and push the current branch after a safety review. Use when the user asks to commit and push, or to ship the current changes; not for opening pull requests, rebasing, or partial commits.
metadata:
  version: "0.2.0"
---

# Commit and Push

Commit every change in the working tree and push it. If the user supplied a commit message, use it as the subject.

## Steps

1. Run `git branch --show-current`, `git status --short`, `git diff HEAD --stat`, and `git log --oneline -5`. If there are no changes, say so and stop.
2. Review the diff (`git diff HEAD`) and read any untracked files. Stop and ask before committing if you find:
   - secrets, private keys, tokens, or complete push tokens (client configuration such as `GoogleService-Info.plist` is fine);
   - build output, `DerivedData`, `xcuserdata`, `.DS_Store`, or other files that belong in `.gitignore`;
   - changes that look unrelated or accidental.
3. Stage everything with `git add -A`.
4. Commit. Match the style of the recent commits; by default use a short imperative subject in sentence case with no trailing period and no type prefix (for example, "Add call blocking security feature"). Add a brief body only when the change needs explanation. Append any attribution trailer your environment requires.
5. Push. If the branch has no upstream, use `git push -u origin <branch>`.
6. Report the commit hash, subject, and push result.

## Boundaries

- Never force-push, amend published commits, or skip hooks.
- If the push is rejected, report why and stop; do not rebase, merge, or pull without asking.
- Run only the git commands above unless the user asks for more.
