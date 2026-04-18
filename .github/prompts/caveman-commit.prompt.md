```prompt
---
description: Generate terse commit message — Conventional Commits, ≤50 char subject, why over what
agent: "agent"
tools:
  - run_in_terminal
---


Generate a terse commit message for the current staged changes.

## Pre-loaded context

**Staged diff:** **Context:** Use terminal to run: `git --no-pager diff --cached --stat 2>/dev/null || echo "Nothing staged"`
**Full diff:** **Context:** Use terminal to run: `git --no-pager diff --cached 2>/dev/null | head -200`

## Instructions

Write commit messages terse and exact. Conventional Commits format. No fluff. Why over what.

### Subject line rules

- `<type>(<scope>): <imperative summary>` — `<scope>` optional
- Types: `feat`, `fix`, `refactor`, `perf`, `docs`, `test`, `chore`, `build`, `ci`, `style`, `revert`
- Imperative mood: "add", "fix", "remove" — not "added", "adds", "adding"
- ≤50 chars when possible, hard cap 72
- No trailing period

### Body (only if needed)

- Skip entirely when subject is self-explanatory
- Add body only for: non-obvious *why*, breaking changes, migration notes, linked issues
- Wrap at 72 chars
- Bullets `-` not `*`
- Reference issues/PRs at end: `Closes #42`, `Refs #17`

### NEVER include

- "This commit does X", "I", "we", "now", "currently"
- "As requested by..." — use Co-authored-by trailer
- "Generated with Claude Code" or any AI attribution
- Emoji (unless project convention requires)

### Examples

❌ "feat: add a new endpoint to get user profile information from the database"
✅ `feat(api): add GET /users/:id/profile`

❌ "fix: fixed a bug where the authentication token was not being refreshed properly"
✅ `fix(auth): refresh token on 401 before retry`

### Auto-Clarity exception

Always include body for: breaking changes, security fixes, data migrations, reverts.

### Output

Output the message as a fenced code block ready to copy. Do NOT run `git commit`.

```
