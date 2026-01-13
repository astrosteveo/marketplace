#!/usr/bin/env bash
# Stop hook for engram:search - validates search was performed

LOG="/tmp/engram-hook-debug.log"
echo "[$(date)] Hook: engram:search Stop" >> "$LOG"

INPUT=$(cat)
echo "  Input (truncated): ${INPUT:0:300}..." >> "$LOG"

TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')

if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    echo "  Transcript: $TRANSCRIPT_PATH" >> "$LOG"

    # Check for search tools
    SEARCH=$(grep -c 'memory_search' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
    INSIGHTS=$(grep -c 'memory_insights' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
    GLOBAL=$(grep -c 'memory_search_global' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
    COMMIT=$(grep -c 'memory_recall_commit' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")

    echo "  memory_search: $SEARCH" >> "$LOG"
    echo "  memory_insights: $INSIGHTS" >> "$LOG"
    echo "  memory_search_global: $GLOBAL" >> "$LOG"
    echo "  memory_recall_commit: $COMMIT" >> "$LOG"
fi

echo "[$(date)] engram:search Stop hook completed" >> "$LOG"
echo "---" >> "$LOG"

exit 0
