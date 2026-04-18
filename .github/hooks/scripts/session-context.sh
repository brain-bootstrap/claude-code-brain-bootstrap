#!/bin/bash
# Copilot Hook: SessionStart — Inject session context
# Outputs JSON with additionalContext for session awareness.
# Adapted from .claude/hooks/session-start.sh for GitHub Copilot.

BRANCH="$(git branch --show-current 2>/dev/null || echo 'unknown')"

# Recent lessons (last 5 lines)
LESSONS=""
if [ -f "claude/tasks/lessons.md" ]; then
  LESSONS="$(tail -5 claude/tasks/lessons.md 2>/dev/null || true)"
fi

# Current todo state
TODO=""
if [ -f "claude/tasks/todo.md" ]; then
  TODO="$(grep -E '^\s*-\s*\[[ x]\]' claude/tasks/todo.md 2>/dev/null | tail -5 || true)"
fi

# jq availability warning
JQ_WARNING=""
if ! command -v jq &>/dev/null; then
  JQ_WARNING=" | ⚠️ jq not installed — safety hooks degraded"
fi

# JSON-escape helper: escape backslashes, double quotes, and newlines
json_escape() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  s="$(printf '%s' "$s" | awk '{printf "%s\\n", $0}' | sed '$ s/\\n$//')"
  printf '%s' "$s"
}

LESSONS_ESC="$(json_escape "$LESSONS")"
TODO_ESC="$(json_escape "$TODO")"

cat <<EOF
{
  "additionalContext": "Session context: branch=${BRANCH}${JQ_WARNING}\n\nRecent lessons:\n${LESSONS_ESC}\n\nOpen todos:\n${TODO_ESC}"
}
EOF
