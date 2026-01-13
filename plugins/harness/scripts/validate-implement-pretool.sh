#!/usr/bin/env bash
# PreToolUse hook for workflow-implement - blocks code before plan approval

LOG="/tmp/harness-hook-debug.log"
echo "[$(date)] Hook: workflow-implement PreToolUse" >> "$LOG"

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

echo "  Tool: $TOOL_NAME" >> "$LOG"
echo "  File: $FILE_PATH" >> "$LOG"

# Always allow artifact files
if [[ "$FILE_PATH" == *".artifacts/"* ]]; then
    echo "  Decision: ALLOW (artifact file)" >> "$LOG"
    echo "---" >> "$LOG"
    exit 0
fi

# Always allow plan.md
if [[ "$FILE_PATH" == *"plan.md" ]]; then
    echo "  Decision: ALLOW (plan.md)" >> "$LOG"
    echo "---" >> "$LOG"
    exit 0
fi

# For source files, we log but allow (prompt hook does actual validation)
echo "  Decision: ALLOW (source file - prompt hook validates)" >> "$LOG"
echo "---" >> "$LOG"

exit 0
