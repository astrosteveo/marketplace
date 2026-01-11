#!/bin/bash
# Uninstall engram plugin files from a target project
#
# Usage: ./uninstall.sh [target_directory]
#        ./uninstall.sh              # uninstalls from current directory
#        ./uninstall.sh /path/to/project

set -e

TARGET_DIR="${1:-.}"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo "Uninstalling engram from: $TARGET_DIR"

# Remove commands directory
CMD_DIR="$TARGET_DIR/.claude/commands/engram"
if [ -d "$CMD_DIR" ]; then
    rm -rf "$CMD_DIR"
    echo "  Removed: .claude/commands/engram/"
fi

# Remove skill directory
SKILL_DIR="$TARGET_DIR/.claude/skills/engram"
if [ -d "$SKILL_DIR" ]; then
    rm -rf "$SKILL_DIR"
    echo "  Removed: .claude/skills/engram/"
fi

# Remove from MCP config
MCP_FILE="$TARGET_DIR/.mcp.json"
if [ -f "$MCP_FILE" ] && grep -q '"engram"' "$MCP_FILE" 2>/dev/null; then
    echo "  Removing engram from .mcp.json"
    python3 -c "
import json
with open('$MCP_FILE') as f:
    config = json.load(f)
if 'mcpServers' in config and 'engram' in config['mcpServers']:
    del config['mcpServers']['engram']
with open('$MCP_FILE', 'w') as f:
    json.dump(config, f, indent=2)
    f.write('\n')
"
fi

echo ""
echo "Note: .engram/ directory preserved (contains your memory data)"
echo "      Delete manually if no longer needed: rm -rf $TARGET_DIR/.engram"
echo ""
echo "Done!"
