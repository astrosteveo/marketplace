#!/usr/bin/env bash
# Stop hook for workflow-implement - validates phase completion

LOG="/tmp/harness-hook-debug.log"
echo "[$(date)] Hook: workflow-implement Stop" >> "$LOG"

INPUT=$(cat)
echo "  Input (truncated): ${INPUT:0:300}..." >> "$LOG"

TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')

if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    echo "  Transcript: $TRANSCRIPT_PATH" >> "$LOG"

    # Check for plan.md
    PLAN_FOUND=$(grep -c 'plan\.md' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
    echo "  plan.md references: $PLAN_FOUND" >> "$LOG"

    # Check for code edits
    EDITS=$(grep -c '"tool_name":"Edit"\|"tool_name":"Write"' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
    echo "  Edit/Write calls: $EDITS" >> "$LOG"
fi

echo "[$(date)] workflow-implement Stop hook completed" >> "$LOG"
echo "---" >> "$LOG"

exit 0
