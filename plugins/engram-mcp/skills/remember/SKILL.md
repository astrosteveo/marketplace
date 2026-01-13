---
name: engram:remember
description: This skill should be used when the user asks to "remember this", "save for later", "store this information", "persist this context", or wants to explicitly save important information for future sessions.
context: fork
allowed-tools:
  - mcp__plugin_engram-mcp_engram__memory_remember
  - mcp__plugin_engram-mcp_engram__memory_decision
  - mcp__plugin_engram-mcp_engram__memory_lesson
  - AskUserQuestion
hooks:
  Stop:
    - hooks:
        - type: command
          command: "${CLAUDE_PLUGIN_ROOT}/scripts/validate-remember.sh"
          timeout: 10
---

# Remember - Persist Important Context

Save important information to engram memory for retrieval in future sessions.

## Execution

### Step 1: Identify What to Remember

Analyze `$ARGUMENTS` or recent conversation to determine:
- **What** information needs persistence
- **Why** it matters for future sessions
- **Category** that best fits (general, decision, or lesson)

### Step 2: Classify Content Type

| If the content is... | Use this tool |
|---------------------|---------------|
| General information, preference, or context | `memory_remember` |
| Architectural or implementation choice | `memory_decision` |
| Bug fix, gotcha, pattern, or anti-pattern | `memory_lesson` |

### Step 3: Structure the Content

Write content that will be useful when retrieved later:
- Include context ("When working on X...")
- Include the actual information
- Include rationale ("Because Y...")

**Example structures:**

For preferences:
```
"User prefers {preference} when {context}. Reason: {rationale}."
```

For decisions:
```
"Selected {choice} for {purpose}. Key factors: {factors}. Trade-offs: {trade-offs}."
```

For lessons:
```
"When {situation}: {lesson}. Root cause: {cause}. Prevention: {how to avoid}."
```

### Step 4: Save to Memory

**For general information:**
```
mcp__plugin_engram-mcp_engram__memory_remember
  content: "{structured content}"
  tags: ["{relevant}", "{tags}"]
```

**For decisions:**
```
mcp__plugin_engram-mcp_engram__memory_decision
  content: "{structured content}"
  category: "architecture"  # or implementation, tradeoff, tooling
  alternatives: ["{other options considered}"]
```

**For lessons:**
```
mcp__plugin_engram-mcp_engram__memory_lesson
  content: "{structured content}"
  category: "pattern"  # or bug_fix, gotcha, anti_pattern
  root_cause: "{cause if known}"
```

### Step 5: Confirm Persistence

Report to user:
- What was saved
- Which tool was used
- Tags/categories assigned
- How to retrieve later (search query suggestion)

## Tag Guidelines

Use consistent, searchable tags:

| Domain | Example Tags |
|--------|--------------|
| Technology | `react`, `typescript`, `postgresql` |
| Concern | `performance`, `security`, `accessibility` |
| Type | `preference`, `constraint`, `requirement` |
| Feature | `auth`, `payments`, `notifications` |

## Examples

**User:** "Remember that I prefer Tailwind over styled-components"

```
mcp__plugin_engram-mcp_engram__memory_remember
  content: "User prefers Tailwind CSS over styled-components for styling. Reason: utility-first approach, better performance, smaller bundle size."
  tags: ["preference", "styling", "tailwind", "css"]
```

**User:** "We decided to use PostgreSQL, not MongoDB"

```
mcp__plugin_engram-mcp_engram__memory_decision
  content: "Selected PostgreSQL as the primary database. Reasons: ACID compliance needed for financial transactions, JSONB provides document flexibility, team has SQL expertise."
  category: "architecture"
  alternatives: ["MongoDB", "MySQL"]
```

**User:** "Remember that auth tokens expire silently - we spent hours debugging this"

```
mcp__plugin_engram-mcp_engram__memory_lesson
  content: "Auth tokens expire silently without error - requests return 401 but error message is vague. Always check token expiry first when debugging auth issues."
  category: "gotcha"
  root_cause: "Token refresh middleware wasn't logging expiry events"
```
