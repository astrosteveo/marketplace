#!/usr/bin/env bash
# Live indexer - runs engram-live-index via uvx

LOG="/tmp/engram-hook-debug.log"
echo "[$(date)] Hook: $hook_event_name" >> "$LOG"

INPUT=$(cat)
echo "  Input: ${INPUT:0:500}..." >> "$LOG"

echo "$INPUT" | uvx --from git+https://github.com/astrosteveo/engram engram-live-index 2>> "$LOG"
echo "[$(date)] Exit: $?" >> "$LOG"
echo "---" >> "$LOG"
