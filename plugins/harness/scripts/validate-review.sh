#!/usr/bin/env bash
# Stop hook for workflow-review - validates phase completion

LOG="/tmp/harness-hook-debug.log"
echo "[$(date)] Hook: workflow-review Stop" >> "$LOG"

INPUT=$(cat)
echo "  Input (truncated): ${INPUT:0:300}..." >> "$LOG"

TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')

if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    echo "  Transcript: $TRANSCRIPT_PATH" >> "$LOG"

    # Check for Task tool calls (reviewer agents)
    TASK_CALLS=$(grep -c '"tool_name":"Task"' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
    echo "  Task tool calls: $TASK_CALLS" >> "$LOG"

    # Check for Code Review section
    REVIEW=$(grep -c 'Code Review' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
    echo "  Code Review refs: $REVIEW" >> "$LOG"
fi

echo "[$(date)] workflow-review Stop hook completed" >> "$LOG"
echo "---" >> "$LOG"

exit 0
