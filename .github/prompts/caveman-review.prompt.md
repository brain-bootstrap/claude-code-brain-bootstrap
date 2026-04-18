```prompt
---
description: One-line PR review comments — location + problem + fix, no throat-clearing
agent: "agent"
tools:
  - run_in_terminal
argument-hint: "[file-path|branch|PR-url]"
---


Review code with terse one-line comments: {{input}}

## Pre-loaded context

**Branch:** **Context:** Use terminal to run: `git branch --show-current`
**Diff stat:** **Context:** Use terminal to run: `git --no-pager diff main...HEAD --stat 2>/dev/null || echo "Not on a feature branch"`

## Instructions

Write code review comments terse and actionable. One line per finding. Location, problem, fix. No throat-clearing.

### Format

`L<line>: <problem>. <fix>.` — or `<file>:L<line>: ...` for multi-file diffs.

### Severity prefix (when mixed findings)

- `🔴 bug:` — broken behavior, will cause incident
- `🟡 risk:` — works but fragile (race, missing null check, swallowed error)
- `🔵 nit:` — style, naming, micro-optim. Author can ignore
- `❓ q:` — genuine question, not a suggestion

### Drop

- "I noticed that...", "It seems like...", "You might want to consider..."
- "This is just a suggestion but..." — use `nit:` instead
- "Great work!", "Looks good overall but..." — say it once at the top, not per comment
- Restating what the line does — the reviewer can read the diff
- Hedging ("perhaps", "maybe", "I think") — if unsure use `q:`

### Keep

- Exact line numbers
- Exact symbol/function/variable names in backticks
- Concrete fix, not "consider refactoring this"
- The *why* if the fix isn't obvious from the problem statement

### Examples

❌ "I noticed that on line 42 you're not checking if the user object is null before accessing the email property."
✅ `L42: 🔴 bug: user can be null after .find(). Add guard before .email.`

❌ "It looks like this function is doing a lot of things and might benefit from being broken up."
✅ `L88-140: 🔵 nit: 50-line fn does 4 things. Extract validate/normalize/persist.`

❌ "Have you considered what happens if the API returns a 429?"
✅ `L23: 🟡 risk: no retry on 429. Wrap in withBackoff(3).`

### Auto-Clarity exception

Drop terse for: security findings (CVE-class — full explanation + reference), architectural disagreements (need rationale), onboarding contexts.

### Boundaries

Reviews only — does not write the code fix, does not approve. Output comments ready to paste into PR.

```
