#!/usr/bin/env bash
# Live indexer - ultra-fast queue writer
#
# Writes directly to daemon queue file. No Python spawn overhead.
# Daemon auto-starts on first SessionStart hook.

set -e

# Read hook input from stdin
INPUT=$(cat)

# Extract cwd from JSON to find the right queue file
# Uses simple grep/sed - no jq dependency
CWD=$(echo "$INPUT" | grep -o '"cwd"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*: *"\([^"]*\)".*/\1/' | head -1)
CWD="${CWD:-$(pwd)}"

# Hash the project path to get queue filename (must match Python daemon)
QUEUE_DIR="/tmp/engram"
mkdir -p "$QUEUE_DIR"

# Python-compatible path hash (SHA256, first 12 chars)
# Using realpath to match Python's resolve()
REAL_PATH=$(realpath "$CWD" 2>/dev/null || echo "$CWD")
PATH_HASH=$(echo -n "$REAL_PATH" | sha256sum | cut -c1-12)
QUEUE_FILE="$QUEUE_DIR/${PATH_HASH}.queue.jsonl"

# Create timestamped event (matching Python format)
# The input is already valid JSON, so we embed it as a JSON string value
TIMESTAMP=$(date -Iseconds)

# Write event as: {"timestamp": "...", "input": "escaped_json_string"}
# We need to escape the JSON for embedding as a string value
ESCAPED_INPUT=$(echo "$INPUT" | python3 -c 'import sys,json; print(json.dumps(sys.stdin.read()))')

echo "{\"timestamp\": \"$TIMESTAMP\", \"input\": $ESCAPED_INPUT}" >> "$QUEUE_FILE"

# Return continue response
echo '{"continue": true}'
