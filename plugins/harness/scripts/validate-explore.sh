#!/usr/bin/env bash
# Stop hook for workflow-explore - validates phase completion

LOG="/tmp/harness-hook-debug.log"
echo "[$(date)] Hook: workflow-explore Stop" >> "$LOG"

INPUT=$(cat)
echo "  Input (truncated): ${INPUT:0:300}..." >> "$LOG"

TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')

if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    echo "  Transcript: $TRANSCRIPT_PATH" >> "$LOG"

    # Check for Task tool calls (explorer agents)
    TASK_CALLS=$(grep -c '"tool_name":"Task"' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
    echo "  Task tool calls: $TASK_CALLS" >> "$LOG"

    # Check for Codebase Exploration section
    EXPLORATION=$(grep -c 'Codebase Exploration' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
    echo "  Exploration section refs: $EXPLORATION" >> "$LOG"
fi

echo "[$(date)] workflow-explore Stop hook completed" >> "$LOG"
echo "---" >> "$LOG"

exit 0
