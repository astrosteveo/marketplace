# Engram

Semantic memory for Claude Code. Persistent context across sessions.

## The Problem

You're deep in a multi-day feature implementation. Phase 3 of 5. Context fills up. You `/new`. Now Claude has no idea what was happening.

## The Solution

Engram watches Claude Code's conversation logs, indexes them into a project-local vector database, and exposes MCP tools that let Claude query past context.

When you `/new` mid-task:
```
> resume
```

Claude instantly sees what you were working on, active todos, recent conversations, key decisions.

No more re-explaining. No more lost context.

## Quick Start

```bash
# Option 1: Install with pip
pip install engram
cd your-project
engram init

# Option 2: Install with script (no pip required)
git clone https://github.com/astrosteveo/engram
cd your-project
/path/to/engram/install.sh
```

Restart Claude Code and you have memory tools available.

## What `engram init` / `install.sh` Does

- Creates `.engram/` directory for memory storage
- Adds engram to `.mcp.json` for Claude Code integration
- Adds `.engram/` to `.gitignore`
- Copies slash commands (`/remember`, `/resume`, `/search`, `/stats`, `/sync`)
- Indexes any existing transcripts (init only)

## Claude Code Tools

Once initialized, Claude has access to:

| Tool | What it does |
|------|--------------|
| `memory_search` | Semantic search across past sessions |
| `memory_resume` | Get context to continue previous work |
| `memory_remember` | Explicitly save important context |
| `memory_sync` | Index current session |
| `memory_stats` | Check what's indexed |

## CLI Commands

```bash
engram init                    # Set up engram in a project
engram sync                    # Index latest transcript
engram search "query"          # Search memory
engram resume                  # Get resume context
engram stats                   # Show what's indexed
engram remember "important"    # Save something explicitly
```

## How It Works

```
~/.claude/projects/*.jsonl
        │
        ▼
    Parser ──► Chunker (Q&A exchange grouping)
        │
        ▼
    ChromaDB (.engram/ per project)
        │
        ▼
    MCP Server ──► Claude Code
```

1. Claude Code writes conversation logs to `~/.claude/projects/`
2. Engram parses and chunks conversations into Q&A exchanges
3. Exchanges are embedded and stored in project-local ChromaDB
4. MCP tools let Claude query and retrieve context

## Storage

Each project gets its own memory:
- Index: `<project>/.engram/index/` (ChromaDB)
- State: `<project>/.engram/state.json` (todos, plans, current work)

## Development

```bash
git clone https://github.com/astrosteveo/engram
cd engram
uv sync
uv run engram --help
```

## License

MIT
