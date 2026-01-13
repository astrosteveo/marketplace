#!/usr/bin/env bash
# Stop hook for engram:resume - validates resume context provided

LOG="/tmp/engram-hook-debug.log"
echo "[$(date)] Hook: engram:resume Stop" >> "$LOG"

INPUT=$(cat)
echo "  Input (truncated): ${INPUT:0:300}..." >> "$LOG"

TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')

if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    echo "  Transcript: $TRANSCRIPT_PATH" >> "$LOG"

    # Check for memory_resume call
    RESUME=$(grep -c 'memory_resume' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
    echo "  memory_resume: $RESUME" >> "$LOG"
fi

echo "[$(date)] engram:resume Stop hook completed" >> "$LOG"
echo "---" >> "$LOG"

exit 0
