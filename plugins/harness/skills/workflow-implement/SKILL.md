---
name: harness:workflow-implement
description: This skill should be used when the user asks to "implement the feature", "write the code", "build it", or when the harness:feature orchestrator invokes the Implement phase.
context: fork
agent: general-purpose
allowed-tools:
  - Task
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash(git:*)
  - Bash(npm:*)
  - Bash(yarn:*)
  - Bash(pnpm:*)
  - Bash(cargo:*)
  - Bash(go:*)
  - Bash(python:*)
  - Bash(pytest:*)
  - Bash(make:*)
  - AskUserQuestion
  - mcp__plugin_engram-mcp_engram__*
hooks:
  Stop:
    - prompt: |
        Before completing, validate:
        1. progress.md shows "Phase: Implement"
        2. plan.md exists with implementation steps
        3. Code changes were made (check git status)
        4. Implementation follows the approved design

        If validation fails, output what's missing. If passes, output "PHASE_COMPLETE".
---

# Implement Phase - Building the Feature

This phase implements the feature according to the approved design.

## Context

**If invoked via orchestrator:** Receives `$ARGUMENTS`:
- `feature_slug`: Feature identifier
- `feature_description`: What to build
- `artifacts_path`: Path to `.artifacts/{slug}/`
- `tdd_mode`: Whether to use test-driven development

**If invoked directly:** Check for existing artifacts. Read `design.md` if available. If starting fresh, ask for what to implement and how.

## Phase Execution

### Step 1: Load Context

Read existing artifacts:
- `{artifacts_path}/progress.md` - Current state
- `{artifacts_path}/requirements.md` - What must be built
- `{artifacts_path}/design.md` - How to build it

Search engram for implementation patterns:

```
mcp__plugin_engram-mcp_engram__memory_search
  query: "{feature_description} implementation code"
  n_results: 5
```

```
mcp__plugin_engram-mcp_engram__memory_insights
  query: "implementation {feature_type}"
  insight_type: "lesson"
  n_results: 5
```

Past lessons (bugs, gotchas) are especially valuable here.

### Step 2: Update Progress

Edit `progress.md`:
- Set Phase to "Implement"
- Check off "Architecture Design"
- Add session log entry

### Step 3: Create Implementation Plan

Based on design.md, create `.artifacts/{slug}/plan.md`:

```markdown
# {Feature Name} - Implementation Plan

## Approach
{Name of chosen approach from design phase}

## Files to Modify

| File | Changes | Order |
|------|---------|-------|
| `path/to/file.ts` | {what changes} | 1 |
| `path/to/other.ts` | {what changes} | 2 |

## Files to Create

| File | Purpose | Order |
|------|---------|-------|
| `path/to/new.ts` | {purpose} | 3 |

## Implementation Steps

### Step 1: {Component/File}
- [ ] {Specific task}
- [ ] {Specific task}

### Step 2: {Component/File}
- [ ] {Specific task}
- [ ] {Specific task}

## Testing Strategy
{How to verify each component works}

## Commit Strategy
{Logical commit points}
```

### Step 4: Present Plan for Approval

Present the implementation plan to user.

**PAUSE POINT**

Ask: "Ready to proceed with implementation?"

Wait for approval before writing any code.

### Step 5: Implement (Standard Mode)

If NOT in TDD mode, implement following the plan:

1. **Work through steps in order**
   - Read existing files before modifying
   - Make focused, minimal changes
   - Follow codebase conventions

2. **Commit frequently**
   ```
   feat({slug}): add {component}
   feat({slug}): implement {behavior}
   ```

3. **Update plan.md**
   - Check off completed steps
   - Note any deviations from plan

4. **Handle blockers**
   - If unexpected issue: document it, ask user if needed
   - If design needs adjustment: note it, continue or pause

### Step 5-TDD: Implement (TDD Mode)

If TDD mode enabled:

1. **Create test plan first**
   Add to `plan.md`:
   ```markdown
   ## Test Cases (TDD Order)
   1. {Behavior}: {test description}
   2. {Behavior}: {test description}
   ```

2. **For each test case, follow Red-Green-Refactor:**

   **RED** - Write failing test
   ```bash
   # Run test, verify it fails
   ```
   Commit: `test({slug}): add failing test for {behavior}`

   **GREEN** - Write minimum code to pass
   ```bash
   # Run test, verify it passes
   ```
   Commit: `feat({slug}): implement {behavior}`

   **REFACTOR** - Clean up if needed
   Commit: `refactor({slug}): {description}`

3. **Repeat for all test cases**

### Step 6: Record Lessons

If bugs encountered or gotchas discovered during implementation:

```
mcp__plugin_engram-mcp_engram__memory_lesson
  content: "When implementing {feature_type}: {lesson}. Root cause: {cause}."
  category: "bug_fix" or "gotcha"
  root_cause: "{cause}"
```

If useful patterns emerged:

```
mcp__plugin_engram-mcp_engram__memory_lesson
  content: "Pattern for {feature_type}: {pattern}. Works well because {reason}."
  category: "pattern"
```

### Step 7: Update Progress with Implementation Summary

Add to `progress.md`:

```markdown
## Implementation

### Files Changed
| File | Changes |
|------|---------|
| `path` | {summary} |

### Files Created
| File | Purpose |
|------|---------|
| `path` | {purpose} |

### Commits
- `{hash}` - {message}
- `{hash}` - {message}

### Deviations from Plan
- {Any changes from original plan and why}

### Issues Encountered
- {Issue}: {how resolved}
```

### Step 8: Prepare Handoff

Summarize for Review phase:
- List of all files changed/created
- Key implementation decisions made
- Any areas of concern for review
- Test coverage status

## Completion Criteria

Stop hook validates:
1. `progress.md` updated with "Phase: Implement"
2. `plan.md` exists with implementation steps
3. Code changes made (git status shows changes or commits)
4. Implementation follows approved design

## Engram Integration

| When | Tool | Purpose |
|------|------|---------|
| Start | `memory_search` | Find implementation patterns |
| Start | `memory_insights` | Get past lessons/bugs |
| During | `memory_lesson` | Record bugs discovered |
| End | `memory_lesson` | Record patterns that worked |
