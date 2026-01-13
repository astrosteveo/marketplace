#!/usr/bin/env bash
# Stop hook for engram:remember - validates memory persistence

LOG="/tmp/engram-hook-debug.log"
echo "[$(date)] Hook: engram:remember Stop" >> "$LOG"

INPUT=$(cat)
echo "  Input (truncated): ${INPUT:0:300}..." >> "$LOG"

TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')

if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    echo "  Transcript: $TRANSCRIPT_PATH" >> "$LOG"

    # Check for memory tools
    REMEMBER=$(grep -c 'memory_remember' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
    DECISION=$(grep -c 'memory_decision' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
    LESSON=$(grep -c 'memory_lesson' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")

    echo "  memory_remember: $REMEMBER" >> "$LOG"
    echo "  memory_decision: $DECISION" >> "$LOG"
    echo "  memory_lesson: $LESSON" >> "$LOG"
fi

echo "[$(date)] engram:remember Stop hook completed" >> "$LOG"
echo "---" >> "$LOG"

exit 0
