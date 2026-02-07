# Teams and Agents Reference

Comprehensive guide to using Claude Code's team features in plugin development.

## Team Creation

### TeamCreate Tool

The `TeamCreate` tool creates a multi-agent team with a shared task list for coordinated parallel work.

**Parameters:**
- **teamName** (required): Identifier for the team, used in configuration paths
- **members** (optional): Array of member definitions with names and roles
- **taskList** (optional): Initial tasks to seed the team with

**Team configuration** is stored at `~/.claude/teams/{team-name}/config.json` and includes:
- Team metadata (name, creation time)
- Member roster with roles and capabilities
- Shared task list state
- Communication preferences

**Example team creation flow:**

1. A command or agent calls `TeamCreate` with team configuration
2. Claude Code provisions the team infrastructure
3. Member agents are spawned with team context
4. The shared task list is initialized
5. Members begin picking up tasks or awaiting instructions

### Team Config Structure

```json
{
  "name": "code-review-team",
  "created": "2026-01-15T10:00:00Z",
  "members": [
    {
      "name": "reviewer-1",
      "role": "Code reviewer specializing in security",
      "status": "active"
    },
    {
      "name": "reviewer-2",
      "role": "Code reviewer specializing in performance",
      "status": "active"
    }
  ],
  "taskList": "shared"
}
```

### Member Discovery

Team members discover each other through the shared team context:
- Each member receives the team roster on initialization
- Members can query active team members via the task system
- New members can join an existing team mid-session
- Members leaving the team are reflected in the roster

## Agent Communication

### SendMessage Tool

The `SendMessage` tool enables inter-agent communication within teams. All agent communication must go through this tool; plain text output from agents is not visible to teammates.

### Message Types

#### Direct Message (type: "message")

Send a message to a specific teammate by name:

```json
{
  "type": "message",
  "recipient": "reviewer-1",
  "content": "I've completed the security review of auth.ts. Found 2 high-severity issues.",
  "summary": "Security review complete for auth.ts"
}
```

**When to use:**
- Responding to a specific teammate
- Sharing findings relevant to one person
- Following up on a task with one agent
- Normal back-and-forth coordination

**Parameters:**
- **recipient** (required): Name of the target agent
- **content** (required): Message text
- **summary** (required): 5-10 word preview for UI display

#### Broadcast (type: "broadcast")

Send the same message to all team members at once:

```json
{
  "type": "broadcast",
  "content": "Critical: Found a blocking security vulnerability in the auth module. All reviews should check for related issues.",
  "summary": "Critical security vulnerability found"
}
```

**When to use (sparingly):**
- Critical blocking issues requiring immediate team-wide attention
- Major announcements affecting every teammate equally
- Team-wide state changes (e.g., "all tasks reassigned")

**Cost warning:** Each broadcast sends a separate message to every teammate. N teammates means N message deliveries. Default to direct messages unless genuinely team-wide.

**Parameters:**
- **content** (required): Message to broadcast
- **summary** (required): 5-10 word preview for UI display

#### Shutdown Request (type: "shutdown_request")

Request a teammate to gracefully shut down:

```json
{
  "type": "shutdown_request",
  "recipient": "reviewer-1",
  "content": "All tasks complete, wrapping up the review session"
}
```

The recipient receives the request and can approve (exit) or reject (continue working).

**When to use:**
- After all assigned tasks are complete
- When the team lead decides to wind down the session
- When a member's role is no longer needed

#### Shutdown Response (type: "shutdown_response")

Respond to a received shutdown request:

```json
{
  "type": "shutdown_response",
  "request_id": "abc-123",
  "approve": true
}
```

Or reject with a reason:

```json
{
  "type": "shutdown_response",
  "request_id": "abc-123",
  "approve": false,
  "content": "Still working on task #5, need 2 more minutes"
}
```

## Team Coordination Patterns

### Leader/Worker Pattern

The most common team pattern where one agent coordinates work for multiple workers:

**Leader responsibilities:**
- Create tasks and assign to workers
- Monitor progress via TaskList
- Aggregate results from workers
- Handle exceptions and reassignments
- Initiate team shutdown when complete

**Worker responsibilities:**
- Check TaskList for available tasks
- Claim tasks by setting owner
- Execute task work
- Report results via SendMessage to leader
- Mark tasks completed
- Wait for shutdown or pick up next task

**Flow:**
1. Leader creates team and initial tasks
2. Workers pick up unblocked, unowned tasks (lowest ID first)
3. Workers execute and report back
4. Leader monitors, re-assigns, and coordinates
5. Leader sends shutdown requests when all work is done

### Peer Collaboration Pattern

Agents working as equals without a designated leader:

**Characteristics:**
- All agents have similar capabilities
- Tasks are self-assigned from a shared pool
- Coordination through task dependencies, not direct management
- Each agent independently decides what to work on next

**When to use:**
- Homogeneous tasks (e.g., reviewing multiple independent files)
- Tasks require no central decision-making
- Simple divide-and-conquer workflows

**Flow:**
1. Tasks are pre-seeded in the shared task list
2. Each agent calls TaskList and claims available tasks
3. Agents work independently
4. Dependencies naturally sequence work
5. Last agent to complete triggers cleanup

### Task-Based Coordination Pattern

Coordination primarily through the task system rather than direct messaging:

**Characteristics:**
- Minimal direct agent communication
- Tasks carry all necessary context in their descriptions
- Dependencies handle sequencing
- Status updates via TaskUpdate, not SendMessage

**When to use:**
- Well-defined, independent work items
- Agents don't need to share intermediate results
- Work can be fully described in task descriptions

## Designing Team-Aware Agents

### Agent Frontmatter for Team Participation

Plugin agents designed for team work should include team-relevant capabilities:

```markdown
---
description: Security reviewer for team-based code review
capabilities:
  - Security vulnerability analysis
  - OWASP Top 10 assessment
  - Authentication and authorization review
allowed-tools: ["Read", "Grep", "Glob", "TaskCreate", "TaskList", "TaskUpdate", "TaskGet", "SendMessage"]
---
```

Key considerations:
- Include task management tools in `allowed-tools`
- Include `SendMessage` for team communication
- Describe the agent's team role in the description
- List specific capabilities the team can rely on

### Idle State Handling

Team member agents should handle idle states gracefully:

1. After completing a task, immediately check TaskList for more work
2. If no tasks are available, send a status message to the team lead
3. Wait for new task assignments or shutdown requests
4. Never busy-wait or create unnecessary tasks to stay active

### Message Protocols

Design consistent message protocols within teams:

**Status updates:** When completing a task, send a summary to the leader:
```
"Completed review of auth.ts: 2 high-severity issues, 1 medium. Details in task #7 description."
```

**Blocking issues:** Immediately broadcast critical blockers:
```
"BLOCKING: Cannot proceed with review — repository access denied. Need credentials configured."
```

**Results sharing:** Share findings relevant to specific teammates:
```
"Found SQL injection in users.ts:45 — this may affect your review of the API routes."
```

## Plugin Commands with Teams

### Creating Team-Powered Commands

Commands can leverage teams for parallel work by including team and task tools in `allowed-tools`:

```yaml
---
description: Parallel code analysis across multiple files
argument-hint: [directory-or-glob]
allowed-tools: ["TeamCreate", "SendMessage", "TaskCreate", "TaskList", "TaskUpdate", "TaskGet", "Read", "Glob", "Grep"]
---
```

**Command workflow:**

1. **Discover work:** Use Glob/Grep to find files matching the argument
2. **Create team:** Use TeamCreate to establish the review team
3. **Create tasks:** Use TaskCreate for each work item with clear descriptions
4. **Spawn workers:** Launch agents as team members
5. **Monitor:** Use TaskList to track progress
6. **Aggregate:** Collect results from completed tasks
7. **Cleanup:** Send shutdown requests, summarize findings

### Team Lifecycle in Commands

Commands that create teams should manage the full lifecycle:

1. **Initialization:** Create team, define members, seed tasks
2. **Execution:** Monitor progress, handle exceptions, reassign work
3. **Completion:** Verify all tasks done, collect results
4. **Cleanup:** Shutdown members, delete team, generate report

Failure to clean up teams can leave orphaned agent processes.

## Best Practices

### When to Use Teams vs Single Agents

**Use teams when:**
- Work can be meaningfully parallelized (3+ independent work items)
- Tasks benefit from specialized roles (security reviewer + performance reviewer)
- Total work would exceed reasonable single-agent time
- Different perspectives improve outcome quality

**Use single agents when:**
- Work is inherently sequential
- Fewer than 3 independent tasks
- Tasks require deep context that is hard to share
- Coordination overhead would exceed parallelism benefit

### Team Size Guidance

- **2-3 members:** Best for most tasks. Low coordination overhead, clear roles.
- **4-5 members:** For large-scale parallel work. Requires more careful task design.
- **6+ members:** Rarely beneficial. Coordination overhead usually dominates. Consider splitting into sub-teams instead.

### Error Handling

**Member failure:** If a team member encounters an error:
1. Mark the task as still in_progress (do not mark completed)
2. Send a message to the team lead describing the failure
3. The lead can reassign the task or adjust the approach

**Communication failure:** If SendMessage fails:
1. Retry once after a brief pause
2. Fall back to updating task descriptions with status
3. Use TaskUpdate to signal blockers via task metadata

**Task conflicts:** If two members try to claim the same task:
1. The first to call TaskUpdate with owner wins
2. Check TaskGet after claiming to verify ownership
3. If claim lost, pick the next available task

### General Guidelines

- Always refer to teammates by name, never by UUID
- Keep message summaries concise (5-10 words) for UI readability
- Prefer direct messages over broadcasts to minimize cost
- Include task management tools in all team-aware agent definitions
- Design tasks with enough description detail for autonomous execution
- Clean up teams and shutdown members when work is complete
- Test team workflows with `--plugin-dir` during development
