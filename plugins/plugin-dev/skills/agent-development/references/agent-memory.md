# Agent Memory System

Reference guide for Claude Code's agent memory types, storage, and best practices.

## Memory Types

### User Memory (`~/.claude/memory/`)

Persists across all projects and sessions for the current user.

**Storage path:** `~/.claude/memory/`
**Scope:** All projects, all sessions
**Git:** Not committed (user-local)

**Use for:**
- Personal preferences and workflows
- Cross-project learnings and patterns
- User-specific tool configurations

### Project Memory (`.claude/memory/`)

Shared across the team, committed to version control.

**Storage path:** `.claude/memory/` in project root
**Scope:** Current project, all team members
**Git:** Committed and shared

**Use for:**
- Project-specific patterns and conventions
- Team-shared knowledge base
- Architecture decisions and rationale
- Codebase-specific learnings

### Local Memory (`.claude/local-memory/`)

Local to the current machine, not committed.

**Storage path:** `.claude/local-memory/` in project root
**Scope:** Current project, current machine only
**Git:** Not committed (in .gitignore)

**Use for:**
- Machine-specific configurations
- Local development environment notes
- Temporary investigation context
- Personal project notes

## Agent Memory Configuration

### Enabling Memory in Agent Frontmatter

```yaml
---
name: learning-agent
memory:
  user: true
  project: true
  local: false
---
```

### Memory Access Patterns

**Read from memory:**
Agents with memory access can read their memory files to inform decisions.

**Write to memory:**
Agents can write learnings and patterns back to memory for future sessions.

**Memory file format:**
Memory files are typically Markdown (`.md`) organized by topic:
```
.claude/memory/
├── MEMORY.md           # Main memory file (always loaded)
├── patterns.md         # Code patterns
├── debugging.md        # Debugging notes
└── architecture.md     # Architecture decisions
```

## Design Patterns

### Pattern 1: Learning Agent

Agent that improves over iterations by recording what works:

```yaml
---
name: code-reviewer
memory:
  project: true
---

Review code and record common issues found in this project to memory.
Check memory first for known project-specific patterns to watch for.
```

### Pattern 2: Context-Aware Agent

Agent that uses accumulated knowledge for better decisions:

```yaml
---
name: architecture-advisor
memory:
  user: true
  project: true
---

Check project memory for architecture decisions before making recommendations.
Reference user memory for preferred patterns and technologies.
```

### Pattern 3: Investigation Agent

Agent that records investigation findings locally:

```yaml
---
name: bug-investigator
memory:
  local: true
---

Record investigation findings to local memory for reference.
Check local memory for previous investigations of similar issues.
```

## Best Practices

1. **Minimize memory scope**: Only enable the memory types the agent actually needs
2. **Use project memory for shared knowledge**: Patterns the whole team should benefit from
3. **Use user memory sparingly**: Only for truly personal preferences
4. **Use local memory for ephemeral notes**: Investigation context, temporary state
5. **Keep memory files concise**: Memory files in the main MEMORY.md should stay under 200 lines
6. **Organize by topic**: Use separate files linked from MEMORY.md for detailed notes
7. **Clean up stale memory**: Remove outdated information regularly
