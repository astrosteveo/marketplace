---
name: platform-features
description: This skill should be used when the user asks about "Claude Code teams", "task management in plugins", "TeamCreate", "TaskCreate", "SendMessage", "session forking", "cloud handoff", "NotebookEdit", "extended thinking", "--agents flag", "--max-budget-usd", "--disallowedTools", "--from-pr", or wants to leverage Claude Code platform capabilities in their plugin design. Covers teams, tasks, sessions, and new built-in tools relevant to plugin developers.
---

# Claude Code Platform Features for Plugin Developers

## Overview

Claude Code provides platform features beyond the basic plugin component model. Understanding these features helps plugin developers create richer, more integrated plugins.

**Key platform capabilities:**
- Teams and parallel agent coordination
- Task management for structured workflows
- Session features (forking, cloud handoff, PR review)
- Extended thinking for complex reasoning
- New built-in tools (NotebookEdit, PDF ranges)
- CLI configuration flags

## Teams and Parallel Agents

Claude Code supports multi-agent teams for coordinated parallel work:

**Core tools:**
- `TeamCreate` — Create a team with shared task list
- `SendMessage` — Direct or broadcast messages between agents
- Team config at `~/.claude/teams/{team-name}/config.json`

**Plugin integration:**
- Commands can create teams for complex workflows
- Agents can be designed as team members with specific roles
- Use `allowed-tools` to include team tools in commands:
  ```yaml
  allowed-tools: ["TeamCreate", "SendMessage", "TaskCreate", "TaskList", "TaskUpdate", "TaskGet"]
  ```

**Design considerations:**
- Each team member runs as a separate agent with its own context
- Members communicate via SendMessage, not shared memory
- Task lists provide coordination without tight coupling
- Use background agents (Ctrl+B) for parallel execution

For detailed team patterns, see `references/teams-and-agents.md`.

## Task Management

Structured task tracking for multi-step workflows:

**Core tools:**
- `TaskCreate` — Create tasks with subject, description, activeForm
- `TaskList` — List all tasks with status
- `TaskUpdate` — Update status (pending → in_progress → completed), set owner, add dependencies
- `TaskGet` — Get full task details

**Plugin integration:**
- Commands can use task tools to track workflow progress
- Agents can create and manage tasks autonomously
- Tasks support dependencies (`blocks`/`blockedBy`) for sequencing

**Example: Task-driven command:**
```yaml
---
description: Execute multi-step deployment with tracking
allowed-tools: ["TaskCreate", "TaskList", "TaskUpdate", "Bash"]
---
```

For detailed patterns, see `references/task-management.md`.

## Session Features

### Session Forking

Fork the current conversation to explore different approaches:
- Preserves full context history
- Each fork proceeds independently
- Useful for A/B testing approaches

### Cloud Handoff

Hand off long-running tasks to cloud execution:
- Session continues without local terminal
- Results available when complete
- Useful for large-scale operations

### PR Review Mode

Start Claude Code in PR review context:
```bash
claude --from-pr 123
```

**Plugin relevance:** Commands designed for PR workflows can detect this mode and adapt behavior.

## Extended Thinking

Configure maximum thinking tokens for complex reasoning:

**Environment variable:** `MAX_THINKING_TOKENS`

```bash
MAX_THINKING_TOKENS=50000 claude
```

**Plugin relevance:** Commands performing complex analysis may benefit from extended thinking. Document this recommendation for users.

## New Built-in Tools

### NotebookEdit

Edit Jupyter notebook cells:
- Replace, insert, or delete cells
- Supports code and markdown cell types
- 0-indexed cell numbering

**Plugin relevance:** Include `NotebookEdit` in `allowed-tools` for data science plugins.

### PDF Reading with Page Ranges

Read specific pages from large PDFs:
```
Read tool with pages parameter: "1-5", "10-20"
```

**Plugin relevance:** Document page range usage for plugins working with PDF files.

## CLI Configuration Flags

Flags relevant to plugin developers and users:

| Flag | Description |
|------|-------------|
| `--agents <path>` | Override agent discovery with explicit path |
| `--max-budget-usd <n>` | Set spending limit per session |
| `--disallowedTools <tools>` | Block specific tools |
| `--from-pr <number>` | Start in PR review context |
| `--plugin-dir <path>` | Load plugin from directory |

**Plugin developer guidance:**
- Document any recommended CLI flags in README
- Test plugins with `--plugin-dir` during development
- Consider `--disallowedTools` impact on plugin functionality

## Quick Reference

### Team-Related Tools

| Tool | Purpose |
|------|---------|
| TeamCreate | Create team with shared task list |
| SendMessage | DM, broadcast, shutdown requests |
| TaskCreate | Create structured tasks |
| TaskList | List tasks and status |
| TaskUpdate | Update status, owner, dependencies |
| TaskGet | Get full task details |

### Session Commands

| Feature | How to Use |
|---------|-----------|
| Fork session | In-IDE feature |
| Cloud handoff | In-IDE feature |
| PR review | `claude --from-pr <number>` |
| Extended thinking | `MAX_THINKING_TOKENS=N claude` |

## Additional Resources

### Reference Files

For detailed guidance, consult:

- **`references/teams-and-agents.md`** — Team creation, coordination patterns, member design
- **`references/task-management.md`** — Task tools, dependencies, workflow patterns
- **`references/session-and-cli.md`** — Session features, CLI flags, environment variables

### Example Files

Working examples in `examples/`:

- **`team-workflow-command.md`** — Command that creates a team for parallel work
- **`task-management-patterns.md`** — Common task management patterns for plugins
