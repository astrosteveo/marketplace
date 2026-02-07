# Task Management Patterns for Plugins

Common patterns for using task management tools in plugin commands and agents.

## Pattern 1: Sequential Pipeline

Track progress through ordered phases:

```markdown
---
description: Deploy with tracked phases
allowed-tools: ["TaskCreate", "TaskUpdate", "TaskList", "Bash"]
---

Steps:
1. Create tasks for each phase:
   - TaskCreate: "Run tests" (activeForm: "Running tests")
   - TaskCreate: "Build artifacts" (activeForm: "Building")
   - TaskCreate: "Deploy to staging" (activeForm: "Deploying")
   Set dependencies: build blocked by tests, deploy blocked by build.

2. Execute each phase:
   - Mark task in_progress before starting
   - Execute the work
   - Mark task completed when done
   - Next task automatically unblocks

3. Report final status with TaskList
```

## Pattern 2: Parallel Workstreams

Independent tasks running concurrently:

```markdown
Steps:
1. Create parallel tasks:
   - TaskCreate: "Lint code" (no dependencies)
   - TaskCreate: "Run unit tests" (no dependencies)
   - TaskCreate: "Check types" (no dependencies)
   - TaskCreate: "Generate report" (blocked by all above)

2. Execute first three in parallel
3. When all complete, generate report unblocks
```

## Pattern 3: Multi-Phase Workflow Command

```markdown
---
description: Comprehensive code quality check
allowed-tools: ["TaskCreate", "TaskUpdate", "TaskList", "TaskGet", "Bash", "Read", "Grep"]
---

Phase 1 - Analysis:
- TaskCreate: "Static analysis" → Run linters
- TaskCreate: "Security scan" → Check for vulnerabilities
- TaskCreate: "Dependency audit" → Check outdated/vulnerable deps

Phase 2 - Fixes (blocked by Phase 1):
- TaskCreate: "Apply auto-fixes" → Fix what can be automated
- TaskCreate: "Document issues" → Create report for manual fixes

Phase 3 - Verification (blocked by Phase 2):
- TaskCreate: "Verify fixes" → Re-run checks
- TaskCreate: "Generate report" → Final summary

Track all progress via TaskList and provide status updates.
```

## Pattern 4: Agent Task Consumption

Agent that picks up tasks from a shared list:

```markdown
---
name: task-worker
description: Agent that processes tasks from shared task list
---

Process:
1. Call TaskList to find available pending tasks
2. Pick the lowest-ID unblocked, unowned task
3. Call TaskUpdate to claim it (set owner, status: in_progress)
4. Execute the task based on its description
5. Call TaskUpdate to mark completed
6. Repeat from step 1 until no tasks remain
```

## Best Practices

- **Clear subjects**: Use imperative form ("Run tests" not "Tests")
- **Helpful activeForm**: Present continuous ("Running tests") for spinner display
- **Meaningful descriptions**: Include enough detail for autonomous execution
- **Appropriate dependencies**: Only block when truly sequential
- **Clean up**: Mark all tasks completed when workflow ends
