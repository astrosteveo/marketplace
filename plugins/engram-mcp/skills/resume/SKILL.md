---
name: resume
description: This skill should be used when the user asks to "resume work", "continue where we left off", "what were we working on", "pick up from last session", or starts a session wanting context from previous work.
context: fork
allowed-tools:
  - mcp__plugin_engram-mcp_engram__memory_resume
  - mcp__plugin_engram-mcp_engram__memory_search
  - mcp__plugin_engram-mcp_engram__memory_timeline
  - Read
  - Glob
hooks:
  Stop:
    - hooks:
        - type: command
          command: "${CLAUDE_PLUGIN_ROOT}/scripts/validate-resume.sh"
          timeout: 10
---

# Resume - Continue Previous Work

Retrieve context from previous sessions to seamlessly continue work.

## Execution

### Step 1: Get Resume Context

Call memory_resume to get comprehensive session state:

```
mcp__plugin_engram-mcp_engram__memory_resume
```

This returns:
- Last session state (todos, active files)
- Recent exchanges (what was discussed)
- Plan files (if any exist)
- Recent insights (decisions and lessons)

### Step 2: Check for Active Artifacts

Search for in-progress work:

```bash
ls -la .artifacts/*/progress.md 2>/dev/null
```

If artifacts exist, read the most recent `progress.md` to understand:
- What feature was being built
- Which phase it's in
- What remains to be done

### Step 3: Get Recent Timeline (Optional)

If more context needed:

```
mcp__plugin_engram-mcp_engram__memory_timeline
  today_only: false
  days: 3
```

This shows:
- When work happened
- What topics were covered
- Session patterns

### Step 4: Search for Specific Context

If user mentions a specific topic, search for it:

```
mcp__plugin_engram-mcp_engram__memory_search
  query: "{topic from user}"
  n_results: 5
```

### Step 5: Present Resume Summary

Structure the resume context clearly:

```markdown
## Previous Session Context

### Last Active Work
{What was being worked on}

### Current State
- **Phase/Status:** {where things stand}
- **Open Items:** {todos or incomplete tasks}
- **Last Action:** {what was done most recently}

### Key Context
{Relevant decisions, constraints, or information}

### Suggested Next Steps
1. {Most logical next action}
2. {Alternative if needed}

---

Ready to continue. What would you like to focus on?
```

## Handling Different Scenarios

### Scenario: Clear Active Feature

If `.artifacts/{slug}/progress.md` exists with incomplete checklist:

1. Read the progress file
2. Identify current phase
3. Summarize what's done vs remaining
4. Suggest continuing from current phase

**Example output:**
```
**Resuming: dark-mode-toggle**

Status: Implementation phase (5/8 complete)
- [x] Discovery, Explore, Requirements, Design, Implement
- [ ] Review, Testing, Summary

Last action: Implemented theme toggle component

Suggest: Continue to code review phase. Run `/harness:feature "dark mode toggle"` to proceed.
```

### Scenario: No Active Features

If no artifacts found but memory exists:

1. Show last session topics
2. List recent decisions/lessons
3. Ask what the user wants to work on

**Example output:**
```
No active feature workflows found.

**Recent work:**
- 3 days ago: Fixed authentication bug
- 5 days ago: Refactored API error handling

**Recent decisions:**
- Selected JWT over sessions for auth (2 days ago)

What would you like to work on today?
```

### Scenario: Fresh Project

If no engram memory exists:

```
This appears to be a fresh project with no previous session context.

The `.engram/` directory will be created automatically as you work.

What would you like to start with?
```

## Memory Sources

Resume context is assembled from:

| Source | Contains |
|--------|----------|
| `.engram/state.json` | Todos, active files, last phase |
| ChromaDB index | Past exchanges, tool uses |
| Insight index | Decisions and lessons |
| `.artifacts/` | Feature workflow progress |
| Git history | Recent commits, changes |

## Tips

- Run `/resume` at the start of any session after a break
- The more you use engram tools, the richer the resume context becomes
- Decisions and lessons are especially valuable for long-running projects
