# 📚 Claude Code Knowledge Base — {{PROJECT_NAME}}

> Your AI assistant's brain lives here. This is how it remembers, learns, and gets better over time.

---

## 🤔 What Is This?

This `claude/` directory is the **knowledge base** for Claude Code (Anthropic's AI coding assistant). It contains structured domain knowledge that Claude reads on-demand during coding sessions — think of it as a shared brain that every AI tool on your team can tap into.

Here's how all the pieces fit together:

| File/Dir | Purpose | Auto-loaded? |
|----------|---------|:------------:|
| `CLAUDE.md` (repo root) | 📋 Root instructions — operating protocol, critical patterns, exit checklist | ✅ Every conversation |
| `@claude/architecture.md` | 🏗️ Architecture overview — imported by `CLAUDE.md` | ✅ Via `@import` |
| `@claude/rules.md` | ⚖️ Golden rules — imported by `CLAUDE.md` | ✅ Via `@import` |
| `claude/*.md` (this dir) | 📚 Domain knowledge — build, terminal safety, CVE policy, etc. | ❌ On-demand (lookup table) |
| `.claude/rules/*.md` | 📏 Path-scoped rules — auto-load when working on matching files | ✅ Per file-path match |
| `.claude/agents/*.md` | 🤖 Custom subagents — research, reviewer, plan-challenger | ✅ Available for delegation |
| `.claude/skills/*/SKILL.md` | 🎓 Skills — background knowledge + invocable workflows | ✅ Auto-activated / invocable |
| `.claude/hooks/*.sh` | 🪝 Hooks — lifecycle automation (session start, compact, format, etc.) | ✅ Auto-triggered |
| `*/CLAUDE.md` (subdirectories) | 📂 Service-specific instructions — auto-loaded per directory | ✅ Per-directory |
| `.claude/settings.json` | ⚙️ Claude Code project settings — tool permissions, hooks, deny rules | ✅ Auto-applied |
| `.claude/commands/*.md` | ⚡ Custom slash commands — `/plan`, `/review`, `/build`, etc. | ✅ Registered as commands |
| `.claudeignore` | 🚫 Context exclusion — binary files, lock files, build artifacts | ✅ Auto-applied |
| `claude/tasks/lessons.md` | 🧠 Accumulated session wisdom — mistakes, patterns, corrections | ❌ Read at session start |
| `claude/tasks/todo.md` | 📝 Current task plan — checkable items, progress tracking | ❌ Read/written during tasks |
| `claude/tasks/CLAUDE_ERRORS.md` | 🐛 Structured error log — promotes to rules after 3+ recurrences | ❌ Read at session start |

---

## 🏗️ Architecture — How Claude Code Reads This

### 🧠 Memory Hierarchy

Claude Code loads knowledge in a strict priority order — higher priorities always win:

| Priority | File | Scope | Gitignored? |
|:--------:|------|-------|:-----------:|
| 1 | `~/.claude/CLAUDE.md` | 🌐 User-global (all projects) | N/A |
| 2 | `CLAUDE.md` (repo root) + `@import`s | 📦 Project-wide | ❌ Committed |
| 3 | `CLAUDE.local.md` (repo root) | 👤 Personal project overrides | ✅ Yes |
| 4 | `.claude/rules/*.md` (no paths) | 📏 Always-loaded project rules | ❌ Committed |
| 4b | `.claude/rules/*.md` (with paths) | 🎯 Path-scoped rules — auto-load on file match | ❌ Committed |
| 5 | Subdirectory `CLAUDE.md` files | 📂 Loaded when working in that dir | ❌ Committed |
| 6 | `.claude/settings.json` | ⚙️ Project tool permissions | ❌ Committed |
| 7 | `.claude/settings.local.json` | 👤 Personal tool permissions | ✅ Yes |
| 8 | `.claude/commands/*.md` | ⚡ Custom slash commands | ❌ Committed |
| 8b | `.claude/skills/*/SKILL.md` | 🎓 Skills — background + invocable | ❌ Committed |
| 9 | `.claude/agents/*.md` | 🤖 Custom subagents | ❌ Committed |
| 10 | `.claude/hooks/*.sh` | 🪝 Lifecycle hooks | ❌ Committed |

### 🎯 Three-Tier Auto-Loading

1. **`CLAUDE.md`** + `@import`s at the repo root (always loaded):
   - Operating protocol, critical patterns, exit checklist
   - `@claude/architecture.md` — workspace layout, service catalog
   - `@claude/rules.md` — 24 golden rules
   - Lookup table for on-demand domain docs

2. **`.claude/rules/`** with `paths:` frontmatter (auto-loaded per file match):
   - `terminal-safety.md` — loads always (no paths = universal)
   - `quality-gates.md` — loads always (hard limits: 50 lines/fn, 4 params, 400 lines/file)
   - `self-maintenance.md` — loads when editing knowledge files
   - `typescript.md`, `python.md`, `nodejs-backend.md`, `react.md` — path-scoped language rules

3. **Subdirectory `CLAUDE.md`** files (auto-loaded per directory):
   - Service-specific instructions loaded when working in that directory

### 🔍 On-Demand Loading

The `CLAUDE.md` lookup table tells Claude which `claude/*.md` files to read for deep domain knowledge:

```
Task about building?   → 🔨 Read claude/build.md
Task about security?   → 🔒 Read claude/cve-policy.md
Task about [domain]?   → 📚 Read claude/[domain].md
```

---

## 📂 File Inventory

### 📚 Domain Knowledge (`claude/*.md`)

| File | Purpose |
|------|---------|
| `architecture.md` | 🏗️ Workspace layout, service types, package aliases (auto-imported) |
| `rules.md` | ⚖️ 24 golden rules — non-negotiable working standards (auto-imported) |
| `terminal-safety.md` | 🚧 Terminal anti-patterns, shell quirks, safe command templates |
| `build.md` | 🔨 Build commands, test commands, CI pipeline, local dev |
| `templates.md` | 📝 MR/ticket templates, context window management |
| `cve-policy.md` | 🔒 CVE decision tree, ignore list format, override checklist |
| `plugins.md` | 🔌 Plugin configuration — claude-mem, graphify, rtk, codebase-memory-mcp, cocoindex-code, code-review-graph, obsidian-mind, hook coexistence matrix |
| `decisions.md` | 🏛️ Architectural decision log — settled choices with full rationale |
| `_examples/*.md` | 💡 Worked examples of domain docs (delete after understanding) |

### 🔧 Bootstrap & Maintenance Scripts (`claude/scripts/`)

| Script | Purpose |
|--------|---------|
| `discover.sh` | 🔍 3800-line stack detector — 25+ languages, 1100+ frameworks, outputs `KEY=VALUE` env |
| `populate-templates.sh` | 🔄 Batch placeholder replacement — fills 70+ `{{VARS}}` across all config files |
| `post-bootstrap-validate.sh` | ✅ Combined validator — runs validate.sh + canary-check.sh + placeholder check + auto-fixes |
| `validate.sh` | 🔎 120-check template validator — run directly or via post-bootstrap-validate.sh |
| `canary-check.sh` | 🐤 Structural health check — imports, tokens, hooks, rules, stale refs |
| `phase2-verify.sh` | 🛡️ Phase 2 data-integrity check — confirms lessons/todo/settings survived Smart Merge |
| `toggle-claude-mem.sh` | 🔌 Enable/disable claude-mem plugin with worker lifecycle management |
| `generate-service-claudes.sh` | 📂 Auto-generates per-service CLAUDE.md stubs for monorepo services |
| `generate-copilot-docs.sh` | 🐙 Mirrors `claude/*.md` → `.github/copilot/` for GitHub Copilot users |
| `setup-plugins.sh` | 🔌 All-in-one plugin management — install, disable, verify, update CLAUDE.md (used in Phase 4) |
| `check-creative-work.sh` | ✅ Creative work gate check — architecture, placeholders, domain docs, IDE (used in Phase 3) |

### 📏 Path-Scoped Rules (`.claude/rules/`)

| File | Auto-loads on | Key patterns |
|------|--------------|--------------|
| `terminal-safety.md` | _(always loaded — no paths)_ | 🚧 Never pager, never interactive, output limits |
| `quality-gates.md` | _(always loaded — no paths)_ | 📏 50 lines/fn, 4 params, 3 nesting, 400 lines/file |
| `self-maintenance.md` | `claude/**`, `CLAUDE.md`, `.claude/**`, `claude/tasks/lessons.md` | 🔄 Consistency invariants, DRY, quality limits |
| `typescript.md` | `**/*.ts`, `**/*.tsx`, `tsconfig.json` | 📘 Strict mode, Zod at boundaries, no barrel re-exports |
| `python.md` | `**/*.py` | 🐍 Type hints, Pydantic, pytest, ruff, pathlib |
| `nodejs-backend.md` | `src/api/**`, `api/**`, `routes/**`, `server/**` | 🖥️ Repository pattern, typed routes, async error middleware |
| `react.md` | `**/*.tsx`, `**/*.jsx`, `src/components/**` | ⚛️ TanStack Query, stable keys, custom hook extraction |
| `memory.md` | _(always loaded — globs: `**/*`)_ | 🧠 Read CLAUDE_ERRORS.md before code changes, memory layer separation |
| `domain-learning.md` | _(always loaded — globs: `**/*`)_ | 📖 Persist business domain facts to `.claude/rules/domain/` |
| `practice-capture.md` | _(always loaded — globs: `**/*`)_ | 💡 Suggest capturing lessons when workarounds/backtracks detected |
| `agents.md` | _(always loaded — globs: `**/*`)_ | 🤖 Delegation decision tree, agent teams, model routing |

### ⚡ Slash Commands (`.claude/commands/`)

| Command | Description | Auto-invoke? |
|---------|-------------|:------------:|
| `/plan` | 📋 Create a structured plan for a task | ✅ Yes |
| `/review` | 🔍 Full MR review protocol (10-point checklist) | ❌ Manual |
| `/mr` | 📝 Generate MR description for current branch | ❌ Manual |
| `/ticket` | 🎫 Create a ticket/issue description | ✅ Yes |
| `/build` | 🔨 Build services | ❌ Manual |
| `/test` | 🧪 Run tests | ❌ Manual |
| `/lint` | 🎨 Lint & format code | ❌ Manual |
| `/debug` | 🐛 Debug a failing test, build, or service | ✅ Yes |
| `/serve` | 🚀 Start service(s) locally | ❌ Manual |
| `/migrate` | 🗄️ Database migrations | ❌ Manual |
| `/db` | 💾 Query the database | ❌ Manual |
| `/context` | 📚 Load all relevant domain context | ✅ Yes |
| `/docker` | 🐳 Docker build & image management | ❌ Manual |
| `/deps` | 📦 Dependency upgrades and CVE fixes | ❌ Manual |
| `/diff` | 🔀 Branch diff analysis (merge-base aware) | ✅ Yes |
| `/git` | 🌿 Git workflow helpers | ❌ Manual |
| `/cleanup` | 🧹 Clean workspace | ❌ Manual |
| `/maintain` | 🛠️ Knowledge base maintenance | ✅ Yes |
| `/checkpoint` | 💾 Save session state | ❌ Manual |
| `/resume` | ▶️ Resume previous session | ✅ Yes |
| `/bootstrap` | 🚀 Auto-configure from target repo | ✅ Yes |
| `/mcp` | 🔌 Manage MCP servers — list, add, configure | ❌ Manual |
| `/squad-plan` | 🧑‍🤝‍🧑 Generate parallel workstream plan for Claude Squad | ❌ Manual |
| `/research` | 🔍 Generate research questions + gather knowledge | ❌ Manual |
| `/update-code-index` | 📋 Scan exports → generate CODE_INDEX.md; check before writing new functions | ❌ Manual |
| `/health` | 🏥 Config health check — CLAUDE.md, settings, hooks, rules frontmatter, secrets scan, MCP binaries | ❌ Manual |
| `/status` | 📊 One-glance project status — budget, placeholders, plugins, hooks, knowledge graph | ❌ Manual |
| `/ask` | 🔀 Route codebase question to right tool — graph · semantic search · risk analysis | ❌ Manual |
| `/worktree` | 🌿 Create git worktree for isolated parallel development | ❌ Manual |
| `/worktree-status` | 📊 Show all worktrees with branch, dirty/clean status, and last commit | ❌ Manual |
| `/clean-worktrees` | 🧹 Remove all worktrees for merged branches (`--dry-run` to preview) | ❌ Manual |

### 🤖 Subagents (`.claude/agents/`)

Agents declare their **optimal model** for best results — but gracefully fall back to the session model when it's unavailable. This means they work with **any provider** (Anthropic API, Bedrock, Vertex) and **any local model** (Ollama, LM Studio, or any OpenAI-compatible endpoint).

| Agent | Description | Optimal | Tools |
|-------|-------------|:-------:|-------|
| `research` | 🔍 Deep codebase exploration | session | Read-only |
| `reviewer` | 🔍 Expert MR code review (10-point protocol) | opus | Read-only + lint |
| `plan-challenger` | ⚔️ Adversarial plan review | opus | Read-only |
| `session-reviewer` | 📊 Conversation pattern analysis — detect corrections, frustrations, recurring issues | session | Read-only |
| `security-auditor` | 🔐 Security scanning — secrets, auth gaps, injection, CVEs, DEPLOY/HOLD/BLOCK verdict | opus | Read-only |

> **"Optimal"** = the model set in the agent file for maximum quality. **"session"** = inherits whatever model you're running — Haiku, a local LLM, anything.

### 🎓 Skills (`.claude/skills/`)

| Skill | Type | Trigger |
|-------|------|---------|
| `tdd` | 🟢 Background | Auto-loads on test files |
| `root-cause-trace` | 🔵 Invocable | Manual or auto |
| `changelog` | 🔵 Invocable | Manual (context: fork) |
| `careful` | 🔵 Invocable | Manual |
| `cross-layer-check` | 🔵 Invocable | Manual (bundled script) |
| `repo-recap` | 🔵 Invocable | Manual — `/repo-recap [fr]` |
| `pr-triage` | 🔵 Invocable | Manual — `/pr-triage [all\|42 57] [fr]` |
| `issue-triage` | 🔵 Invocable | Manual — `/issue-triage [all\|42 57] [fr]` |
| `codebase-memory` | 🔵 Invocable | Manual — use before reading files for structural questions (`trace_path`, `detect_changes`, `get_architecture`) |
| `cocoindex-code` | 🔵 Invocable | Manual — `/cocoindex-code` or `mcp__cocoindex-code__search` for semantic code discovery |
| `code-review-graph` | 🔵 Invocable | Manual — run before any PR: `mcp__code-review-graph__detect_changes_tool(base_branch="main")` |
| `playwright` | 🔵 Invocable | Manual — browser automation via MCP: navigate, snapshot, click, fill |
| `brainstorming` | 🔵 Invocable | Auto — fires before new features/components; HARD-GATE: no code until design approved |
| `writing-skills` | 🔵 Invocable | Manual — when creating or editing SKILL.md files; CSO and structure guidelines |
| `subagent-driven-development` | 🔵 Invocable | Manual — after `/squad-plan`; dispatches subagents with two-stage review per task |
| `receiving-code-review` | 🔵 Invocable | Auto — fires when receiving code review feedback; enforces technical rigor |
| `codeburn` | 🔵 Invocable | Manual — `codeburn today` / `codeburn report` for token cost observability |
| `serena` | 🔵 Invocable | Manual — LSP-backed rename/move/inline; use `mcp__serena__rename_symbol` etc. |

### 🪝 Hooks (`.claude/hooks/`)

| Hook | Trigger | Purpose |
|------|---------|---------|
| `session-start.sh` | SessionStart(startup\|resume\|clear) | 🏁 Inject branch, task, reminders |
| `on-compact.sh` | SessionStart(compact) | 💾 Re-inject after compaction |
| `pre-compact.sh` | PreCompact | 📸 Backup transcript + append todo marker + emit project-aware summarizer instructions |
| `config-protection.sh` | PreToolUse(Write\|Edit\|MultiEdit) | 🔒 Block config file weakening |
| `terminal-safety-gate.sh` | PreToolUse(Bash) | 🚧 Block dangerous terminal patterns |
| `pre-commit-quality.sh` | PreToolUse(Bash) | 🧹 Commit quality gate |
| `suggest-compact.sh` | PreToolUse(*) | 📊 Suggest /compact at intervals |
| `identity-reinjection.sh` | UserPromptSubmit | 🪪 Periodic identity refresh |
| `subagent-stop.sh` | SubagentStop | 📓 Completion logging |
| `stop-batch-format.sh` | Stop | 🎨 Batch format edited files |
| `exit-nudge.sh` | Stop | 👋 Exit checklist reminder |
| `edit-accumulator.sh` | PostToolUse(Edit\|Write\|MultiEdit) | 📝 Accumulate edited file paths |
| `permission-denied.sh` | PermissionDenied | 🔐 Audit trail — log denied operations to `.permission-denials.log` |
| `warn-missing-test.sh` | PostToolUse(Write) | 🧪 Warn when source files lack tests (strict profile only) |
| `rtk-rewrite.sh` | PreToolUse(Bash) | ⚡ RTK token optimizer — transparently rewrites commands for 60-90% savings (no-op if rtk absent) |
| `tdd-loop-check.sh` | Stop | 🔁 TDD enforcement — fails the loop if tests were skipped after code changes |

---

## ➕ How to Add More Knowledge

Want to teach your AI something new? Here's how — it's designed to be easy:

### 📚 Adding a new domain doc

1. Create `claude/<domain>.md` following the existing format (see `_examples/` for inspiration)
2. Add an entry to the lookup table in `CLAUDE.md`
3. *(Optional)* Create a path-scoped rule in `.claude/rules/<domain>.md` with critical do/don't patterns
4. Update this README's File Inventory

### ⚡ Adding a new slash command

1. Create `.claude/commands/<name>.md` with YAML frontmatter:
   ```yaml
   ---
   description: What this command does (≤127 chars)
   disable-model-invocation: true  # for commands with side effects
   effort: low                      # low for quick tasks, high for research
   allowed-tools: Bash(command *)   # pre-approve tools
   argument-hint: "[expected args]"
   ---
   ```
2. Add `## Instructions` section with step-by-step actions
3. For live data, use `` !`command` `` for dynamic context injection
4. Update this README's Commands table

### 🤖 Adding a new subagent

1. Create `.claude/agents/<name>.md` with YAML frontmatter
2. Keep tools minimal — read-only for research agents
3. Set `maxTurns` to prevent runaway (default: unlimited)
4. Update this README's Subagents table

### 🪝 Adding a new hook

1. Create `.claude/hooks/<name>.sh` — must `exit 0` (non-zero blocks the action)
2. Make executable: `chmod +x .claude/hooks/<name>.sh`
3. Register in `.claude/settings.json` under the `hooks` key
4. Update this README's Hooks table

### 📏 Adding a new path-scoped rule

1. Copy `.claude/rules/_template-domain-rule.md`
2. Set `paths:` to match your target files
3. Keep it ≤40 lines — reference full `claude/*.md` doc for details
4. Update this README's Rules table

---

## 💡 Why This Architecture?

### vs. a single giant instruction file 📄
A single file >4KB gets expensive to load every conversation. The two-tier approach (small root + large on-demand) keeps costs down while providing deep context when needed.

### vs. inline code comments 💬
Code comments explain _what_ and _how_. The knowledge base explains _why_, _when_, and _what to watch out for_.

### vs. a wiki or external docs 🌐
The knowledge base is version-controlled with the code. When the code changes, the knowledge changes in the same commit. External wikis drift.

### 🔄 Self-Maintenance Philosophy
Knowledge is a **live product**. Every task is an opportunity to improve docs. Stale docs are bugs. The Exit Checklist and `/maintain` command enforce this — your knowledge base literally heals itself.

---

## ✅ Maintenance Checklist

Run periodically (or just use `/maintain full` and let the AI handle it 😄):

- [ ] Verify all file paths in `claude/*.md` still exist
- [ ] Verify `CLAUDE.md` lookup table matches actual files: `ls claude/*.md`
- [ ] Check lessons size: `wc -l claude/tasks/lessons.md` (archive if >500 lines)
- [ ] Verify command files match README list: `ls .claude/commands/*.md`
- [ ] Verify rule files: `ls .claude/rules/*.md`
- [ ] Verify hook scripts are executable: `ls -la .claude/hooks/*.sh`
- [ ] Verify `hooks` in `.claude/settings.json` reference existing scripts
- [ ] Check for stale references: `grep -rn 'old_pattern' claude/ .claude/`
