# Engram Synthesize Design

Generate and maintain CLAUDE.md from engram memory.

## Core Concept

**engram synthesize** generates a CLAUDE.md file optimized for Claude to understand the codebase.

- CLAUDE.md is a **generated artifact**, not manually maintained
- Engram memory is the **source of truth** - want something permanent? Use `remember()`
- Manual edits are ephemeral (overwritten on next synthesis)

## When It Runs

- **Automatically** on session end via hook
- **On demand** via `/engram:synthesize` command

## Bootstrap Behavior

- First run (no memory): Analyzes codebase (package.json, README, structure)
- Subsequent runs: Regenerates from accumulated memory

## Output Structure

```markdown
## Commands     - build, test, lint, run
## Architecture - project structure, where things live
## Patterns     - coding conventions to follow
## Gotchas      - things to avoid
## Decisions    - why X over Y
```

## Implementation

### New MCP Tool

```
engram__memory_synthesize
```

- Inputs: `project_path` (optional, defaults to cwd)
- Outputs: Path to generated CLAUDE.md
- Behavior: Pulls from all memory sources, generates structured markdown

### Memory Sources

- `remembered` chunks (explicit `remember()` calls)
- `decision` insights (architecture, implementation choices)
- `lesson` insights (gotchas, patterns, anti-patterns)
- Bootstrap analysis (package.json, README, file structure)

### New Command

```
/engram:synthesize
```

- Invokes the MCP tool
- Shows diff of what changed

### Session End Hook

```json
"SessionEnd": [{
  "hooks": [{
    "type": "command",
    "command": "engram synthesize --quiet"
  }]
}]
```

### Bootstrap Analysis (First Run)

- Detect package manager (npm/bun/pnpm/yarn)
- Extract scripts from package.json
- Parse README for project description
- Map directory structure to architecture section

## Edge Cases

**Conflict handling:**
- Existing CLAUDE.md → full overwrite (memory is source of truth)
- Want to preserve something → use `engram remember "..."` before synthesis

**Empty states:**
- No memory + no package.json/README → minimal skeleton with headers only
- Empty category → omit that section

**Content deduplication:**
- Dedupe similar learnings across memory
- Same thing remembered multiple times → appears once

**Formatting:**
- Terse, scannable, optimized for Claude
- Bullet points over prose
- Code blocks for commands
- No fluff

**File location:**
- Always at project root: `./CLAUDE.md`
