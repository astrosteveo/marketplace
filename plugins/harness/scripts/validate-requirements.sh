#!/usr/bin/env bash
# Stop hook for workflow-requirements - validates phase completion

LOG="/tmp/harness-hook-debug.log"
echo "[$(date)] Hook: workflow-requirements Stop" >> "$LOG"

INPUT=$(cat)
echo "  Input (truncated): ${INPUT:0:300}..." >> "$LOG"

TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')

if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    echo "  Transcript: $TRANSCRIPT_PATH" >> "$LOG"

    # Check for requirements.md
    REQ_FOUND=$(grep -c 'requirements\.md' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
    echo "  requirements.md references: $REQ_FOUND" >> "$LOG"
fi

echo "[$(date)] workflow-requirements Stop hook completed" >> "$LOG"
echo "---" >> "$LOG"

exit 0
