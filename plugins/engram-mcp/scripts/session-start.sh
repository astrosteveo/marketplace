#!/usr/bin/env bash
# Session start - inject previous session context

LOG="/tmp/engram-hook-debug.log"
echo "[$(date)] SessionStart hook" >> "$LOG"

INPUT=$(cat)
echo "  Input: ${INPUT:0:200}..." >> "$LOG"

# Run the session start handler
echo "$INPUT" | uvx --from git+https://github.com/astrosteveo/engram engram-session-start 2>> "$LOG"
EXIT_CODE=$?

echo "[$(date)] SessionStart exit: $EXIT_CODE" >> "$LOG"
echo "---" >> "$LOG"
