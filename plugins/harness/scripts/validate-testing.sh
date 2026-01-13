#!/usr/bin/env bash
# Stop hook for workflow-testing - validates phase completion

LOG="/tmp/harness-hook-debug.log"
echo "[$(date)] Hook: workflow-testing Stop" >> "$LOG"

INPUT=$(cat)
echo "  Input (truncated): ${INPUT:0:300}..." >> "$LOG"

TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')

if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    echo "  Transcript: $TRANSCRIPT_PATH" >> "$LOG"

    # Check for AskUserQuestion (test checklist)
    ASK_CALLS=$(grep -c 'AskUserQuestion' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
    echo "  AskUserQuestion calls: $ASK_CALLS" >> "$LOG"

    # Check for Testing section
    TESTING=$(grep -c '## Testing' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
    echo "  Testing section refs: $TESTING" >> "$LOG"
fi

echo "[$(date)] workflow-testing Stop hook completed" >> "$LOG"
echo "---" >> "$LOG"

exit 0
