````prompt
---
description: Compress a prose file into terse caveman-speak — saves ~46% input tokens every session
agent: "agent"
tools:
  - run_in_terminal
argument-hint: "<filepath>"
---


Compress this file into terse form: {{input}}

## Instructions

Rewrite the specified file's prose into caveman-compressed form to reduce input tokens loaded each session.
Creates a `.original.md` backup before overwriting.

### Process

1. Read the target file
2. Copy it to `<filename>.original.md` as human-readable backup
3. Compress ONLY the prose — apply compression rules below
4. Write the compressed version back to the original path
5. Report token savings estimate

### Compression Rules — Remove

- Articles: a, an, the
- Filler: just, really, basically, actually, simply, essentially, generally
- Pleasantries: "sure", "certainly", "of course", "happy to", "I'd recommend"
- Hedging: "it might be worth", "you could consider", "it would be good to"
- Redundant phrasing: "in order to" → "to", "make sure to" → "ensure", "the reason is because" → "because"
- Connective fluff: "however", "furthermore", "additionally"
- "you should", "make sure to", "remember to" — just state the action
- Merge redundant bullets that say the same thing differently

### Compression Rules — Preserve EXACTLY (never modify)

- Code blocks (fenced ``` and indented)
- Inline code (`backtick content`)
- URLs and links (full URLs, markdown links)
- File paths (`/src/components/...`, `./config.yaml`)
- Commands (`npm install`, `git commit`, `docker build`)
- Technical terms (library names, API names, protocols, algorithms)
- Proper nouns (project names, people, companies)
- Dates, version numbers, numeric values
- Environment variables (`$HOME`, `NODE_ENV`)
- All markdown headings (keep exact heading text, compress body below)
- Bullet point hierarchy (keep nesting level)
- Tables (compress cell text, keep structure)

### Compression Rules — Transform

- Use short synonyms: "big" not "extensive", "fix" not "implement a solution for", "use" not "utilize"
- Fragments OK: "Run tests before commit" not "You should always run tests before committing"
- Keep one example where multiple examples show the same pattern

### Pattern

Original:
> You should always make sure to run the test suite before pushing any changes to the main branch. This is important because it helps catch bugs early.

Compressed:
> Run tests before push to main. Catch bugs early.

### Boundaries

- ONLY compress natural language files (.md, .txt)
- NEVER modify: .py, .js, .ts, .json, .yaml, .yml, .toml, .env, .lock, .css, .html, .xml, .sql, .sh
- If file has mixed content (prose + code), compress ONLY the prose sections
- If unsure whether something is code or prose, leave it unchanged
- Never compress `*.original.md` files (skip them)

### What NOT to compress

- `.mcp.json`, `settings.json` — not prose
- Files with pipe-heavy tables — verify output after
- Source code files

````
