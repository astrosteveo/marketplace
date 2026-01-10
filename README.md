# harness-mp

Personal plugin marketplace for Claude Code.

## Plugins

| Plugin | Description | Repo |
|--------|-------------|------|
| **harness** | Feature development workflow + plugin creation skills | [harness](https://github.com/astrosteveo/harness) |
| **engram** | Semantic memory - persistent context across sessions | [engram](https://github.com/astrosteveo/engram) |

## Installation

1. Add this marketplace:
   ```
   /plugin marketplace add ~/workspace/harness-mp
   ```

2. Install plugins:
   ```
   /plugin install harness@harness-mp
   /plugin install engram@harness-mp
   ```

## Plugin Details

### harness

Pure skill plugin with 18 skills for:
- Feature development workflow (orchestrator, explore, design, implement, review, etc.)
- Plugin development (create skills, agents, hooks, commands on the fly)

### engram

MCP server for semantic memory:
- Indexes Claude Code conversation logs
- Enables context persistence across sessions
- `resume` to pick up where you left off

Requires: `pip install engram` + `engram init` in your project
