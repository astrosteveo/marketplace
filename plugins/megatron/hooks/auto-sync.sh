#!/bin/bash
# Auto-sync memory on Stop event
# This hook fires every time Claude finishes responding,
# ensuring the conversation is indexed before the user might exit.

set -eo pipefail

# Get the plugin root (directory containing this script's parent)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(dirname "$SCRIPT_DIR")}"

# Read hook input from stdin
input=$(cat)

# Extract the working directory from the hook input
cwd=$(echo "$input" | jq -r '.cwd // empty')

if [[ -z "$cwd" ]]; then
    # Fall back to current directory if cwd not provided
    cwd="$(pwd)"
fi

# Run the sync command silently
cd "${PLUGIN_ROOT}/claude-memory"
uv run claude-memory sync --project "$cwd" >/dev/null 2>&1 || true

# Always succeed - don't block Claude's response
exit 0
