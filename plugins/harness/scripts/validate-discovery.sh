#!/usr/bin/env bash
# Stop hook for workflow-discovery - validates phase completion

LOG="/tmp/harness-hook-debug.log"
echo "[$(date)] Hook: workflow-discovery Stop" >> "$LOG"

INPUT=$(cat)
echo "  Input (truncated): ${INPUT:0:300}..." >> "$LOG"

# Parse the transcript to check for required artifacts
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty')

if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    echo "  Transcript: $TRANSCRIPT_PATH" >> "$LOG"

    # Check if mkdir was called for .artifacts
    MKDIR_FOUND=$(grep -c '\.artifacts/' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
    echo "  .artifacts references: $MKDIR_FOUND" >> "$LOG"

    # Check if progress.md was written
    PROGRESS_FOUND=$(grep -c 'progress\.md' "$TRANSCRIPT_PATH" 2>/dev/null || echo "0")
    echo "  progress.md references: $PROGRESS_FOUND" >> "$LOG"
fi

echo "[$(date)] workflow-discovery Stop hook completed" >> "$LOG"
echo "---" >> "$LOG"

# Allow completion - prompt hooks handle actual validation
exit 0
