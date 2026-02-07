# Task Management Reference

Complete guide to using task management tools in Claude Code plugins.

## Task Tools

### TaskCreate

Create a new task in the shared task list.

**Parameters:**
- **subject** (required): Brief, actionable title in imperative form (e.g., "Fix authentication bug in login flow")
- **description** (required): Detailed description including context and acceptance criteria
- **activeForm** (recommended): Present continuous form shown in spinner when in_progress (e.g., "Fixing authentication bug")
- **metadata** (optional): Arbitrary key-value pairs for custom data

**Guidelines:**
- Use imperative form for subjects ("Run tests" not "Tests" or "Running tests")
- Use present continuous for activeForm ("Running tests" not "Run tests")
- Include enough description detail for another agent to understand and complete the task
- All tasks are created with status `pending` and no owner

**Example:**
```json
{
  "subject": "Review authentication module for security issues",
  "description": "Analyze src/auth/ for OWASP Top 10 vulnerabilities. Check JWT handling, password hashing, and session management. Report findings with severity ratings.",
  "activeForm": "Reviewing authentication module"
}
```

### TaskList

List all tasks in the task list with summary information.

**Returns for each task:**
- **id**: Task identifier for use with TaskGet and TaskUpdate
- **subject**: Brief task description
- **status**: `pending`, `in_progress`, or `completed`
- **owner**: Agent name if assigned, empty if available
- **blockedBy**: List of open task IDs that must resolve first

**Usage patterns:**
- Check for available work (status: pending, no owner, empty blockedBy)
- Monitor overall progress
- Find blocked tasks that need dependencies resolved
- Verify task completion after workflow

**Task selection order:** When multiple tasks are available, prefer working on tasks in ID order (lowest ID first). Earlier tasks often set up context for later ones.

### TaskUpdate

Update an existing task's status, ownership, or details.

**Parameters:**
- **taskId** (required): The task ID to update
- **status** (optional): New status — `pending`, `in_progress`, `completed`, or `deleted`
- **subject** (optional): Updated title
- **description** (optional): Updated description
- **activeForm** (optional): Updated spinner text
- **owner** (optional): Agent name to assign
- **metadata** (optional): Key-value pairs to merge (set key to null to delete)
- **addBlocks** (optional): Task IDs this task blocks
- **addBlockedBy** (optional): Task IDs that block this task

**Status workflow:** `pending` -> `in_progress` -> `completed`

Use `deleted` to permanently remove a task.

**Important rules:**
- Only mark a task completed when fully accomplished
- If encountering errors or blockers, keep as in_progress
- Read task state with TaskGet before updating to avoid stale data
- Setting owner claims the task for an agent

### TaskGet

Retrieve full details for a specific task by ID.

**Returns:**
- **subject**: Task title
- **description**: Detailed requirements and context
- **status**: Current status
- **blocks**: Tasks waiting on this one
- **blockedBy**: Tasks that must complete first
- **owner**: Assigned agent name
- **metadata**: Custom key-value data

**When to use:**
- Before starting work, to get full requirements
- To check dependency status
- To verify ownership after claiming
- To read updated description after changes

## Task Lifecycle

### Standard Flow

1. **Creation**: TaskCreate with subject, description, activeForm
2. **Assignment**: TaskUpdate to set owner (agent claims task)
3. **Start work**: TaskUpdate to set status to `in_progress`
4. **Execute**: Perform the work described in the task
5. **Complete**: TaskUpdate to set status to `completed`
6. **Next task**: Call TaskList to find next available work

### Ownership

Tasks without an owner are available for any agent to claim. To claim a task:

1. Call TaskList to find unblocked, unowned tasks
2. Call TaskUpdate with your agent name as owner and status as `in_progress`
3. Call TaskGet to verify you own the task (in case of race conditions)
4. Proceed with the work

If another agent claimed the task first, pick the next available task from the list.

### Status Transitions

```
pending ──→ in_progress ──→ completed
   │              │
   └──→ deleted   └──→ deleted
```

- **pending**: Created but not started. May be blocked or available.
- **in_progress**: Actively being worked on by an assigned agent.
- **completed**: Work finished successfully.
- **deleted**: Permanently removed (for tasks created in error or no longer needed).

Never skip from `pending` directly to `completed`. Always transition through `in_progress` to signal that work is happening.

## Dependencies

### blocks / blockedBy Relationships

Tasks can declare dependencies on other tasks:

- **blockedBy**: This task cannot start until the listed tasks complete
- **blocks**: The listed tasks are waiting on this task to complete

**Setting dependencies at creation:**
```
TaskCreate: "Build artifacts" (no dependencies)
TaskCreate: "Deploy to staging"
TaskUpdate: addBlockedBy: ["<build-task-id>"]
```

**Dependency resolution:**
- When a blocking task completes, blocked tasks automatically become available
- Agents checking TaskList will see previously-blocked tasks as now available
- Tasks with non-empty blockedBy lists cannot be claimed

### Dependency Patterns

**Linear chain:**
```
Task A → Task B → Task C
(A blocks B, B blocks C)
```
Tasks execute in strict order.

**Fan-out:**
```
Task A → Task B
Task A → Task C
Task A → Task D
```
Tasks B, C, D all wait for A, then execute in parallel.

**Fan-in:**
```
Task B → Task D
Task C → Task D
```
Task D waits for both B and C to complete.

**Diamond:**
```
A → B → D
A → C → D
```
A must complete first, then B and C run in parallel, then D runs after both finish.

## Task Patterns for Plugins

### Sequential Pipeline

Track progress through ordered phases where each phase depends on the previous:

1. Create all tasks upfront with dependencies
2. Execute the first unblocked task
3. Each completion unblocks the next phase
4. Monitor with TaskList for progress visibility

**Use case:** Build-test-deploy pipelines, phased migrations, ordered processing.

### Parallel Workstreams

Independent tasks running concurrently with a final aggregation step:

1. Create independent tasks (no dependencies between them)
2. Create an aggregation task blocked by all independent tasks
3. Multiple agents pick up independent tasks in parallel
4. When all complete, the aggregation task unblocks

**Use case:** Multi-file analysis, parallel reviews, concurrent test suites.

### Dependency Chains

Complex workflows with multiple dependency relationships:

1. Map the workflow into tasks with clear dependencies
2. Use addBlocks and addBlockedBy to express relationships
3. Tasks naturally execute in the correct order as dependencies resolve
4. Parallel paths execute concurrently where possible

**Use case:** CI/CD pipelines, multi-stage builds, complex deployments.

## Plugin Integration

### Using Tasks in Commands

Commands can use task tools to provide visibility into multi-step workflows:

```yaml
---
description: Multi-step code quality check
allowed-tools: ["TaskCreate", "TaskUpdate", "TaskList", "TaskGet", "Bash", "Read", "Grep"]
---
```

**Benefits:**
- Users see progress through task status updates
- Failed steps are clearly visible
- Can resume from failure point
- Provides an audit trail of work done

### Using Tasks in Agents

Agents can autonomously manage tasks for complex workflows:

1. Agent receives high-level instruction
2. Agent breaks work into tasks via TaskCreate
3. Agent executes tasks sequentially, updating status
4. Agent uses TaskList to track remaining work
5. Agent reports final summary when all tasks complete

### Tracking Multi-Phase Workflows

For workflows spanning multiple phases (analysis, implementation, verification):

1. **Phase tasks**: Create a task for each phase
2. **Sub-tasks**: Create detailed tasks within each phase
3. **Phase dependencies**: Phase N+1 blocked by Phase N tasks
4. **Progress tracking**: TaskList shows overall and per-phase progress

## Best Practices

### Task Naming

- **Subjects**: Use imperative form — "Run tests", "Review auth module", "Deploy to staging"
- **activeForm**: Use present continuous — "Running tests", "Reviewing auth module", "Deploying to staging"
- **Keep subjects concise**: Under 60 characters for readability
- **Be specific**: "Review auth.ts for XSS" is better than "Review file"

### Descriptions

- Include enough context for autonomous execution
- List specific files, directories, or resources involved
- Define acceptance criteria (what "done" looks like)
- Reference relevant documentation or standards
- Keep descriptions focused but comprehensive

### activeForm Patterns

The activeForm text appears in a spinner while the task is in progress:

- Match the subject's action: "Run tests" -> "Running tests"
- Keep short (under 40 characters)
- Use present continuous tense
- Include key context: "Reviewing auth.ts" not just "Reviewing"

### Dependency Design

- Only add dependencies when execution order truly matters
- Avoid over-constraining: if tasks can run in parallel, let them
- Use fan-out/fan-in patterns for maximum parallelism
- Test that dependency chains resolve correctly

### General Guidelines

- Create tasks before starting work (plan first)
- Always mark tasks in_progress before starting work on them
- Never mark tasks completed unless fully done
- Read task state with TaskGet before updating
- Use metadata for custom tracking data (timestamps, metrics)
- Clean up by marking obsolete tasks as deleted
- Prefer lowest-ID tasks when multiple are available
