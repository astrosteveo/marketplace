# Engram Integration in Harness Workflow

Deep integration patterns between harness workflow phases and engram semantic memory.

## Why Engram Matters for Workflows

The `context: fork` architecture means each phase skill runs in isolation. Without engram:
- Each phase starts with no context
- Cross-session continuity is lost
- Lessons learned are forgotten

With engram:
- Semantic search provides relevant context to each phase
- Decisions persist across phases and sessions
- Lessons compound over time

## Integration Matrix

| Phase | Engram Tools Used | Purpose |
|-------|-------------------|---------|
| Discovery | `memory_search` | Find similar past features |
| Discovery | `memory_insights` | Get relevant decisions |
| Explore | `memory_search` | Find related explorations |
| Explore | `memory_decision` | Record pattern choices |
| Explore | `memory_lesson` | Record gotchas found |
| Requirements | `memory_search` | Find similar requirements |
| Requirements | `memory_insights` | Get past clarifications |
| Design | `memory_search` | Find architectural patterns |
| Design | `memory_decision` | Record approach selection |
| Implement | `memory_search` | Find implementation patterns |
| Implement | `memory_lesson` | Record bugs/fixes |
| Review | `memory_insights` | Get review criteria |
| Review | `memory_lesson` | Record issues found |
| Testing | `memory_search` | Find test patterns |
| Summary | `memory_remember` | Persist feature summary |

## Tool Usage Patterns

### memory_search - Semantic Context Retrieval

**When:** Start of each phase
**Purpose:** Find relevant past work

```
# Phase-specific searches
Discovery: "feature {description} initialization setup"
Explore:   "architecture patterns {description} codebase"
Requirements: "requirements {description} edge cases"
Design:    "design approach {description} tradeoffs"
Implement: "implementation {description} code patterns"
Review:    "code review {description} issues"
Testing:   "testing {description} verification"
```

**Best practice:** Always search before doing work. Even "no results" is informative.

### memory_insights - Decision/Lesson Retrieval

**When:** Start of relevant phases
**Purpose:** Get recorded decisions and lessons

```
# Design phase example
mcp__plugin_engram-mcp_engram__memory_insights
  query: "architecture {feature_type}"
  insight_type: "decision"
  n_results: 3
```

**Best practice:** Use before making significant choices. Past decisions provide rationale.

### memory_decision - Record Architectural Choices

**When:** After making significant choices
**Purpose:** Persist decision rationale

```
# Example: Recording design choice
mcp__plugin_engram-mcp_engram__memory_decision
  content: "For user-settings feature: Chose React Context over Redux. Simpler for isolated feature, avoids store bloat, matches existing patterns in ProfilePage."
  category: "architecture"
  alternatives: ["Redux slice", "Zustand store", "Local component state"]
```

**Categories:**
- `architecture` - High-level design decisions
- `implementation` - Coding approach choices
- `tradeoff` - Performance/complexity tradeoffs
- `tooling` - Tool/library selections

### memory_lesson - Record Patterns and Gotchas

**When:** After discovering important patterns or fixing issues
**Purpose:** Compound learning across sessions

```
# Example: Recording a lesson
mcp__plugin_engram-mcp_engram__memory_lesson
  content: "React Context providers must be above useContext consumers. Moving SettingsProvider to _app.tsx fixed 'undefined context' errors."
  category: "gotcha"
  root_cause: "Provider component placement in component tree"
```

**Categories:**
- `bug_fix` - How a bug was resolved
- `gotcha` - Non-obvious issues to remember
- `pattern` - Effective patterns discovered
- `anti_pattern` - Patterns that failed

### memory_remember - Explicit Persistence

**When:** Feature completion, key milestones
**Purpose:** Create searchable summary

```
# Example: Feature completion
mcp__plugin_engram-mcp_engram__memory_remember
  content: "Completed dark-mode feature: Used CSS custom properties with ThemeContext. Key files: theme.ts, ThemeProvider.tsx, globals.css. Lesson: System preference detection needs matchMedia listener for real-time updates."
  tags: ["feature-complete", "dark-mode", "theming"]
```

**Best practice:** Include key files, approach, and most important lesson.

## Cross-Phase Context Flow

```
┌─────────────┐
│  Discovery  │──memory_search──▶ Find similar features
└─────────────┘
       │
       ▼ artifacts + engram decisions
┌─────────────┐
│   Explore   │──memory_search──▶ Find patterns
└─────────────┘──memory_decision─▶ Record discoveries
       │
       ▼ artifacts + engram context
┌─────────────┐
│Requirements │──memory_insights─▶ Past clarifications
└─────────────┘
       │
       ▼ artifacts + engram decisions
┌─────────────┐
│   Design    │──memory_search──▶ Architecture patterns
└─────────────┘──memory_decision─▶ Record approach
       │
       ▼ artifacts + engram patterns
┌─────────────┐
│ Implement   │──memory_search──▶ Code patterns
└─────────────┘──memory_lesson──▶ Record bugs/fixes
       │
       ▼
┌─────────────┐
│   Summary   │──memory_remember─▶ Persist everything
└─────────────┘
```

## Session Continuity

### Scenario: User Closes Claude Mid-Workflow

**Day 1:** User starts "add dark mode", completes Discovery and Explore phases.

**Day 2:** User returns.

1. `/feature-v2 "dark mode"` or `/engram:resume`
2. Orchestrator finds `.artifacts/dark-mode/progress.md`
3. Orchestrator searches engram:
   ```
   memory_search: "dark mode feature harness workflow"
   memory_insights: "dark mode"
   ```
4. Context from Day 1 is restored via:
   - Artifacts (progress.md, any phase docs)
   - Engram search results (exchanges, decisions)
5. Workflow continues from Requirements phase

### Scenario: Similar Feature in New Project

**Project A:** Completed "dark mode" feature, persisted to engram.

**Project B:** User starts "add theming support".

1. Engram's global search finds Project A's dark mode work
2. Relevant patterns and decisions are surfaced
3. User benefits from past learning without re-discovery

## Hook Integration

The engram plugin's hooks automatically index:

```json
{
  "PostToolUse": ["Edit", "Write", ...],
  "Stop": [...],
  "SessionEnd": [...]
}
```

This means:
- Every artifact write is indexed
- Phase completions are captured
- No explicit sync needed (but recommended at Summary)

## Best Practices

1. **Search before acting** - Every phase should start with `memory_search`
2. **Record decisions with rationale** - Future you will thank present you
3. **Tag lessons with context** - Include feature type, tech stack
4. **Use specific queries** - "React authentication OAuth" > "auth"
5. **Remember at milestones** - Not just completion, but key pivot points

## Example: Full Phase with Engram

```markdown
# Explore Phase Execution

## 1. Search for Context
memory_search: "dark mode theming CSS architecture"
→ Found: "Previous project used CSS custom properties..."

memory_insights: "theming implementation"
→ Found: Decision: "CSS variables over Sass for runtime switching"

## 2. Do Phase Work
[Launch explorer agents...]
[Read discovered files...]
[Synthesize findings...]

## 3. Record Insights
memory_decision:
  content: "For dark mode: CSS custom properties match existing codebase
            pattern. Variables defined in :root, toggled via data-theme
            attribute on document."
  category: "architecture"

memory_lesson:
  content: "CSS custom properties don't work in media queries. Use
            prefers-color-scheme for initial load, JS toggle for user
            preference."
  category: "gotcha"

## 4. Complete Phase
[Update progress.md...]
[Phase complete, insights persisted]
```
