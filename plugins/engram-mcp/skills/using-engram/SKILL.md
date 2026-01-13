---
name: using-engram
description: This skill should be used when the user asks about "engram memory", "how to use memory tools", "semantic search in Claude", "persist context across sessions", "remember things for later", or needs guidance on using engram MCP tools effectively.
user-invocable: false
---

# Using Engram - Semantic Memory for Claude Code

Engram provides persistent semantic memory across Claude Code sessions. Information persists in a local ChromaDB index at `.engram/` and remains searchable across sessions.

## Core Concepts

### Memory Types

| Type | Purpose | Example |
|------|---------|---------|
| `exchange` | Conversation Q&A pairs | User question + assistant response |
| `tool_use` | Tool invocations and results | Edit, Bash, Grep operations |
| `remembered` | Explicitly saved context | Key decisions, preferences |
| `decision` | Architectural choices | "Selected React over Vue because..." |
| `lesson` | Patterns and gotchas | "Watch out for X when doing Y" |

### Hybrid Search

Engram uses 70% semantic + 30% keyword (BM25) search:
- Semantic: Finds conceptually similar content
- Keyword: Finds exact matches

Wrap queries in quotes for exact matching: `"FastAPI authentication"`.

## Available Tools

### memory_search
Semantic search across project memory.

```
mcp__plugin_engram-mcp_engram__memory_search
  query: "authentication implementation patterns"
  n_results: 5
  filter_type: "decision"  # Optional: remembered, exchange, tool_use, decision, lesson
```

### memory_resume
Get context to resume previous work. Returns last session state, active todos, plan files, and recent exchanges.

```
mcp__plugin_engram-mcp_engram__memory_resume
```

### memory_remember
Explicitly save important information for future sessions.

```
mcp__plugin_engram-mcp_engram__memory_remember
  content: "User prefers functional components over class components"
  tags: ["preference", "react", "components"]
```

### memory_decision
Record architectural or implementation decisions with alternatives considered.

```
mcp__plugin_engram-mcp_engram__memory_decision
  content: "Selected PostgreSQL for the database. Reasons: JSONB support, mature ecosystem."
  category: "architecture"  # architecture, implementation, tradeoff, tooling
  alternatives: ["MongoDB", "SQLite"]
```

### memory_lesson
Record patterns, gotchas, and lessons learned.

```
mcp__plugin_engram-mcp_engram__memory_lesson
  content: "When using React Query, always set staleTime to avoid unnecessary refetches"
  category: "gotcha"  # bug_fix, gotcha, pattern, anti_pattern
  root_cause: "Default staleTime is 0"
```

### memory_insights
Search past decisions and lessons.

```
mcp__plugin_engram-mcp_engram__memory_insights
  query: "database architecture"
  insight_type: "decision"  # decision, lesson, all
  n_results: 5
```

### memory_sync
Index the current session transcript.

```
mcp__plugin_engram-mcp_engram__memory_sync
```

### memory_stats
Get memory statistics for current project.

```
mcp__plugin_engram-mcp_engram__memory_stats
```

### memory_search_global
Search across ALL projects with engram memory.

```
mcp__plugin_engram-mcp_engram__memory_search_global
  query: "how to implement caching"
  n_results: 10
```

### memory_timeline
Show session timeline and work patterns.

```
mcp__plugin_engram-mcp_engram__memory_timeline
  days: 7
  today_only: false
```

### memory_recall_commit
Recall context from when a git commit was made.

```
mcp__plugin_engram-mcp_engram__memory_recall_commit
  commit_ref: "HEAD~3"
```

### memory_patterns
Analyze workflow patterns (e.g., search→read→edit sequences).

```
mcp__plugin_engram-mcp_engram__memory_patterns
```

### memory_export
Export memory to portable file.

```
mcp__plugin_engram-mcp_engram__memory_export
  compress: true
```

## Best Practices

### When to Search Memory

Search memory at the START of significant tasks:
- Beginning a new feature
- Investigating a bug
- Making architectural decisions
- Resuming after a break

### When to Save Memory

Save memory for information that should persist:
- User preferences and constraints
- Key architectural decisions with rationale
- Bugs fixed and their root causes
- Patterns that work well in this codebase
- Gotchas specific to this project

### Effective Queries

**Good queries** - specific and semantic:
- "authentication implementation with JWT"
- "database schema decisions"
- "error handling patterns in API routes"

**Poor queries** - too vague or keyword-only:
- "auth"
- "bug"
- "code"

### Memory Hygiene

- Use appropriate categories (decision vs lesson)
- Include context in content ("When implementing X, do Y because Z")
- Add relevant tags for filtering
- Record alternatives considered for decisions
- Include root cause for lessons when known

## Integration Points

### Session Lifecycle

Engram hooks automatically handle:
- **SessionStart**: Resume context injection
- **PostToolUse**: Live indexing of tool results
- **Stop/SessionEnd**: Final indexing
- **PreCompact**: Index before compaction

### With Workflow Skills

Workflow phases integrate with engram:

| Phase | Engram Usage |
|-------|--------------|
| Discovery | Search for similar features |
| Design | Get past architecture decisions |
| Implement | Find implementation patterns, record lessons |
| Summary | Persist completion record, sync session |

## Troubleshooting

### Memory Not Found

1. Check `.engram/` directory exists
2. Run `memory_stats` to verify index health
3. Try `memory_sync` to index current session

### Stale Results

The BM25 index may become stale. Run `memory_sync` to refresh.

### Cross-Project Search Empty

Verify other projects have `.engram/` directories. Engram searches common paths:
- `~/workspace`
- `~/projects`
- `~/code`
- `~/dev`
