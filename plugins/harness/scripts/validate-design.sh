#!/usr/bin/env bash
# Stop hook for workflow-design - validates phase completion

LOG="/tmp/harness-hook-debug.log"
echo "[$(date)] Hook: workflow-design Stop" >> "$LOG"

INPUT=$(cat)
echo "  Input (truncated): ${INPUT:0:300}..." >> "$LOG"

TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')

if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    echo "  Transcript: $TRANSCRIPT_PATH" >> "$LOG"

    # Check for design.md
    DESIGN_FOUND=$(grep -c 'design\.md' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
    echo "  design.md references: $DESIGN_FOUND" >> "$LOG"

    # Check for WebSearch (research)
    WEBSEARCH=$(grep -c 'WebSearch' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
    echo "  WebSearch calls: $WEBSEARCH" >> "$LOG"
fi

echo "[$(date)] workflow-design Stop hook completed" >> "$LOG"
echo "---" >> "$LOG"

exit 0
