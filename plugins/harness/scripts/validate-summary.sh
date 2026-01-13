#!/usr/bin/env bash
# Stop hook for workflow-summary - validates phase completion

LOG="/tmp/harness-hook-debug.log"
echo "[$(date)] Hook: workflow-summary Stop" >> "$LOG"

INPUT=$(cat)
echo "  Input (truncated): ${INPUT:0:300}..." >> "$LOG"

TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')

if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    echo "  Transcript: $TRANSCRIPT_PATH" >> "$LOG"

    # Check for summary.md
    SUMMARY_FOUND=$(grep -c 'summary\.md' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
    echo "  summary.md references: $SUMMARY_FOUND" >> "$LOG"

    # Check for memory_remember (critical for summary)
    REMEMBER=$(grep -c 'memory_remember' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
    echo "  memory_remember calls: $REMEMBER" >> "$LOG"

    # Check for memory_sync
    SYNC=$(grep -c 'memory_sync' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
    echo "  memory_sync calls: $SYNC" >> "$LOG"
fi

echo "[$(date)] workflow-summary Stop hook completed" >> "$LOG"
echo "---" >> "$LOG"

exit 0
