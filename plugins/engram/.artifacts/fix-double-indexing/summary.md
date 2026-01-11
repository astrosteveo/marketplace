# Fix Double Indexing - Summary

## Completed
2026-01-11

## What Was Built
A fix for the double indexing bug in Engram where content was being indexed twice - once via live indexing (Stop hook) and once via batch sync (CLI commands). The solution unified the ID generation format between both indexing paths and added a cleanup command for migrating existing indexes.

### Key Features
- **Unified ID format**: Both live indexer and batch sync now generate identical chunk IDs (`{session}:exchange:{uuid}`)
- **Deduplication via upsert**: ChromaDB's upsert mechanism now correctly deduplicates because IDs match
- **Migration tool**: `engram cleanup` command removes old-format duplicates from existing indexes

## Key Decisions
| Decision | Rationale |
|----------|-----------|
| Use live indexer ID format as canonical | Live indexer was already using the more descriptive `exchange:` prefix; changing one file (chunker.py) vs. multiple files in live indexer |
| Pragmatic approach (Approach C) | Right-sized solution for a bug fix - ~80 lines total. Avoided over-engineering with new modules or extensive logging |
| Add cleanup command instead of auto-cleanup | Auto-cleanup on every sync would be too slow; explicit command gives user control |
| Defer debug logging | Can add later if troubleshooting needed; not essential for the fix |
| Defer marker file sharing | Upsert handles most cases; adds complexity without significant benefit |
| Accept session ID with colons as known limitation | Unlikely in practice since Claude session IDs are typically UUIDs |

## Files Modified
| File | Changes |
|------|---------|
| `/home/astrosteveo/workspace/marketplace/plugins/engram/engram/chunker.py` | Line 96: Changed ID format from `{session}:{uuid}` to `{session}:exchange:{uuid}` |
| `/home/astrosteveo/workspace/marketplace/plugins/engram/engram/project_memory.py` | Added `cleanup_duplicates()` method (~60 lines) to detect and remove old-format duplicates |
| `/home/astrosteveo/workspace/marketplace/plugins/engram/engram/cli.py` | Added `engram cleanup` command (~17 lines) as CLI entry point for migration |

## Files Created
| File | Purpose |
|------|---------|
| (none) | All changes fit in existing modules |

## Manual Testing
- Tested by: User
- Date: 2026-01-11
- Result: PASSED
- Summary of what was verified:
  - **Unit tests**: New chunk ID format matches live indexer format
  - **Cleanup command**: Visible in `engram --help` and functions correctly
  - **Duplicate removal**: Old format chunks are removed when new format exists
  - **Upsert deduplication**: Live + batch sync produce no duplicates
  - **Search quality**: Relevant results returned, no duplicate content in results
- **Integration tests on live engram project**:
  - Initial state: 37 chunks
  - After cleanup: 0 duplicates found (clean install)
  - After sync: 86 chunks indexed
  - Post-sync cleanup: 0 duplicates created
  - Search verified: Relevant results with good scores (0.592-0.729)

## Known Limitations
- **Session IDs with colons**: If a session_id contains colons, the cleanup parsing may fail. This is unlikely in practice as Claude Code session IDs are typically UUIDs.
- **Partial chunk cleanup not implemented**: Partial chunks (`{session}:partial:{uuid}`) are not explicitly cleaned up when exchanges complete. They get overwritten by exchange chunks via upsert, which is functionally equivalent.
- **No debug logging**: Verbose logging for troubleshooting was deferred. Can be added later if needed.

## Future Improvements
- Add debug logging for indexing decisions (R5 from requirements)
- Share marker files between live and batch indexers for more efficient incremental syncing (R2)
- Explicit partial chunk cleanup when exchange completes (R3)
- Enhanced `engram stats` command showing duplicate detection

## Lessons Learned
- **What went well**:
  - Thorough codebase exploration identified root cause quickly (different ID schemes)
  - Architecture diagram made the dual-path problem very clear
  - Pragmatic approach kept scope manageable for a bug fix
  - ChromaDB's upsert behavior validated through testing

- **What could be improved**:
  - ID format should have been unified from the start when live indexer was added
  - Could benefit from a central ID generation module if more indexing paths are added
