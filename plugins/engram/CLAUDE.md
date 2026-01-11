# CLAUDE.md

## Project Overview

Engram is a semantic memory system for Claude Code. It indexes conversation transcripts from `~/.claude/projects/` into project-local vector databases, enabling context persistence across sessions.

## Commands

```bash
# Setup
uv sync

# Run MCP server
uv run engram-mcp

# CLI
uv run engram init              # Initialize in a project
uv run engram sync              # Sync from transcript
uv run engram search "query"    # Search memory
uv run engram resume            # Get resume context
uv run engram stats             # Show stats
uv run engram remember "text"   # Save explicitly
```

## Architecture

```
MCP Server (mcp_server.py)
    │
    ├── memory_search    ─┐
    ├── memory_resume     │
    ├── memory_remember   ├── Tools for Claude
    ├── memory_sync       │
    └── memory_stats     ─┘
            │
            ▼
ProjectMemory (project_memory.py)
    │
    ├── ChromaDB (.engram/)
    ├── SessionState (state.json)
    └── Transcript parsing
            │
            ▼
Parser (parser.py) ──► Chunker (chunker.py)
```

## Key Files

- `cli.py` - CLI commands
- `mcp_server.py` - MCP server for Claude Code
- `project_memory.py` - Core memory operations
- `parser.py` - JSONL transcript parsing
- `chunker.py` - Conversation chunking
- `live_indexer.py` - Hook-based live indexing

## Storage

- Memory: `<project>/.engram/index/` (ChromaDB)
- State: `<project>/.engram/state.json`
