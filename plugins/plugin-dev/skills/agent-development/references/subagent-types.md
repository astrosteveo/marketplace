# Built-in Subagent Types Reference

Complete reference for Claude Code's built-in subagent types and their relationship to custom agents.

## Built-in Types

### Explore Agent

**Purpose:** Fast codebase exploration and search
**Available tools:** Read, Grep, Glob, WebFetch, WebSearch
**Cannot:** Edit, Write, NotebookEdit, Task, ExitPlanMode

**Best for:**
- Finding files by patterns
- Searching code for keywords
- Answering questions about the codebase
- Quick research tasks

**Thoroughness levels:** quick, medium, very thorough

### Plan Agent

**Purpose:** Architecture planning and design
**Available tools:** Read, Grep, Glob, WebFetch, WebSearch (same as Explore)
**Cannot:** Edit, Write, NotebookEdit, Task, ExitPlanMode

**Best for:**
- Designing implementation plans
- Identifying critical files
- Considering architectural trade-offs
- Planning multi-step implementations

### General-purpose Agent

**Purpose:** Complex multi-step tasks requiring full tool access
**Available tools:** All tools
**Cannot:** Nothing restricted

**Best for:**
- Tasks requiring file modifications
- Complex multi-step implementations
- Research combined with code changes
- Any task needing unrestricted tool access

### Bash Agent

**Purpose:** Command execution
**Available tools:** Bash only
**Cannot:** Read, Write, Edit, Grep, Glob, etc.

**Best for:**
- Git operations
- Build and test commands
- System administration tasks
- Pure terminal operations

## Custom Agents vs Built-in Types

| Aspect | Built-in Types | Custom Agents |
|--------|---------------|---------------|
| Definition | Hardcoded in Claude Code | `.md` files in agents/ |
| Tools | Predefined per type | Configurable via `tools` field |
| Behavior | Generic | Domain-specific via system prompt |
| Triggering | Programmatic (Task tool) | Description-based (auto or manual) |
| Memory | No memory | Configurable via `memory` field |
| Hooks | No hooks | Configurable via `hooks` field |

**When to use built-in types:**
- Quick, generic operations (search, plan, execute)
- When no domain-specific knowledge needed
- For parallelizing independent sub-tasks

**When to create custom agents:**
- Domain-specific expertise needed
- Specific system prompt and process required
- Need restricted or specialized tool sets
- Want auto-triggering based on context

## Spawning Subagents

Custom agents and built-in types are spawned via the Task tool:

```
Use Task tool with subagent_type:
- "Explore" → Built-in explore agent
- "Plan" → Built-in plan agent
- "general-purpose" → Built-in general-purpose agent
- "Bash" → Built-in bash agent
```

Custom agents from `agents/` are loaded via the auto-discovery mechanism and triggered by their description matching the current context.
