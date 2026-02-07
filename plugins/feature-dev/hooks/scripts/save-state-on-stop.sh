#!/bin/bash
# Save state on session stop
# Updates timestamp and session count in the feature-dev state file

set -euo pipefail

STATE_FILE=".claude/feature-dev.local.md"

# Quick exit if no active feature state
if [[ ! -f "$STATE_FILE" ]]; then
  exit 0
fi

# Parse YAML frontmatter
FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$STATE_FILE")

# Check if enabled
ENABLED=$(echo "$FRONTMATTER" | grep '^enabled:' | sed 's/enabled: *//' | tr -d ' ')
if [[ "$ENABLED" != "true" ]]; then
  exit 0
fi

# Check if feature is complete (no need to update)
CURRENT_PHASE=$(echo "$FRONTMATTER" | grep '^current_phase:' | sed 's/current_phase: *//' | tr -d '"')
PHASE_STATUS=$(echo "$FRONTMATTER" | grep '^phase_status:' | sed 's/phase_status: *//' | tr -d '"')
if [[ "$CURRENT_PHASE" == "summary" && "$PHASE_STATUS" == "completed" ]]; then
  exit 0
fi

# Get current timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Get current session count and increment
SESSION_COUNT=$(echo "$FRONTMATTER" | grep '^session_count:' | sed 's/session_count: *//' | tr -d ' ')
SESSION_COUNT=${SESSION_COUNT:-0}
NEW_COUNT=$((SESSION_COUNT + 1))

# Create temp file for atomic update
TEMP_FILE="${STATE_FILE}.tmp.$$"

# Update last_updated timestamp
sed "s/^last_updated:.*/last_updated: \"$TIMESTAMP\"/" "$STATE_FILE" > "$TEMP_FILE"

# Update session count
sed -i "s/^session_count:.*/session_count: $NEW_COUNT/" "$TEMP_FILE"

# Atomic rename
mv "$TEMP_FILE" "$STATE_FILE"

exit 0
