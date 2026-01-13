---
name: search
description: This skill should be used when the user asks to "search memory", "find in past sessions", "what did we decide about", "look up previous work on", or needs to retrieve specific information from project memory.
context: fork
allowed-tools:
  - mcp__plugin_engram-mcp_engram__memory_search
  - mcp__plugin_engram-mcp_engram__memory_insights
  - mcp__plugin_engram-mcp_engram__memory_search_global
  - mcp__plugin_engram-mcp_engram__memory_recall_commit
hooks:
  Stop:
    - hooks:
        - type: command
          command: "${CLAUDE_PLUGIN_ROOT}/scripts/validate-search.sh"
          timeout: 10
---

# Search - Query Project Memory

Search engram semantic memory for past context, decisions, and lessons.

## Execution

### Step 1: Parse Search Intent

From `$ARGUMENTS`, identify:
- **Query**: What the user wants to find
- **Scope**: Project-only or cross-project
- **Type**: General search or insights (decisions/lessons)

### Step 2: Select Search Strategy

| User Intent | Tool to Use |
|-------------|-------------|
| General context, past work | `memory_search` |
| Past decisions or architecture choices | `memory_insights` with `insight_type: "decision"` |
| Past bugs, gotchas, patterns | `memory_insights` with `insight_type: "lesson"` |
| How something was done in another project | `memory_search_global` |
| What was happening at a specific commit | `memory_recall_commit` |

### Step 3: Execute Search

**General search:**
```
mcp__plugin_engram-mcp_engram__memory_search
  query: "{semantic query}"
  n_results: 10
```

**Search with type filter:**
```
mcp__plugin_engram-mcp_engram__memory_search
  query: "{semantic query}"
  filter_type: "decision"  # or: remembered, exchange, tool_use, lesson
  n_results: 10
```

**Insights search:**
```
mcp__plugin_engram-mcp_engram__memory_insights
  query: "{topic}"
  insight_type: "decision"  # or: lesson, all
  n_results: 5
```

**Cross-project search:**
```
mcp__plugin_engram-mcp_engram__memory_search_global
  query: "{semantic query}"
  n_results: 10
```

**Commit context:**
```
mcp__plugin_engram-mcp_engram__memory_recall_commit
  commit_ref: "abc123"  # or HEAD~3, branch name, etc.
```

### Step 4: Present Results

Organize results by relevance and type:

```markdown
## Search Results: "{query}"

### Most Relevant

**[{type}] {date}**
{content snippet}
*Relevance: {score}*

---

### Decisions Found
| Date | Decision | Rationale |
|------|----------|-----------|
| {date} | {choice} | {why} |

### Lessons Found
| Date | Lesson | Category |
|------|--------|----------|
| {date} | {content} | {category} |

### Related Exchanges
{Summary of relevant past conversations}

---

{N} results found. Refine search with more specific terms if needed.
```

### Step 5: Offer Follow-up Actions

Based on results, suggest:
- More specific search queries
- Related topics to explore
- Actions to take based on findings

## Query Crafting Tips

### Effective Queries

Engram uses semantic search. Write queries as natural language:

**Good:**
- "how did we implement user authentication"
- "decisions about database schema for orders"
- "bugs related to async state updates"

**Poor:**
- "auth" (too vague)
- "SELECT * FROM" (not semantic)
- "file.ts line 42" (not indexed)

### Using Filters

Filter by type to narrow results:

| Filter | Best For |
|--------|----------|
| `remembered` | Explicit saves, preferences |
| `decision` | Architecture choices |
| `lesson` | Bugs, patterns, gotchas |
| `exchange` | Past conversations |
| `tool_use` | Code changes, commands run |

### Exact Matching

Wrap query in quotes for exact phrase matching:

```
mcp__plugin_engram-mcp_engram__memory_search
  query: "\"PostgreSQL JSONB\""
```

## Examples

**User:** "What did we decide about caching?"

```
mcp__plugin_engram-mcp_engram__memory_insights
  query: "caching"
  insight_type: "decision"
  n_results: 5
```

**User:** "Search all my projects for how to handle file uploads"

```
mcp__plugin_engram-mcp_engram__memory_search_global
  query: "file upload implementation handling"
  n_results: 10
```

**User:** "What were we doing when we made that refactor commit last week?"

```
mcp__plugin_engram-mcp_engram__memory_recall_commit
  commit_ref: "HEAD~15"  # Approximate commits ago
```

**User:** "Find any gotchas about React hooks"

```
mcp__plugin_engram-mcp_engram__memory_insights
  query: "React hooks"
  insight_type: "lesson"
  n_results: 5
```

## No Results?

If search returns empty:

1. **Broaden the query** - Use more general terms
2. **Check memory stats** - Run `memory_stats` to verify index health
3. **Try different filters** - Remove type filter for broader results
4. **Search globally** - Information might be in another project
5. **Sync memory** - Run `memory_sync` if recent work isn't indexed
