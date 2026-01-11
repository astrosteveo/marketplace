#!/bin/bash
# Install engram plugin files into a target project
#
# Usage: ./install.sh [target_directory]
#        ./install.sh              # installs to current directory
#        ./install.sh /path/to/project

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-.}"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo "Installing engram to: $TARGET_DIR"

# Create .claude directories
mkdir -p "$TARGET_DIR/.claude/commands/engram"
mkdir -p "$TARGET_DIR/.claude/skills/engram"

# Copy commands (namespaced by directory)
echo "  Copying commands..."
cp "$SCRIPT_DIR/commands/"*.md "$TARGET_DIR/.claude/commands/engram/"

# Copy skill definition
echo "  Copying skill..."
cp "$SCRIPT_DIR/.claude/skills/engram/SKILL.md" "$TARGET_DIR/.claude/skills/engram/"

# Set up MCP config
MCP_FILE="$TARGET_DIR/.mcp.json"
MCP_CONFIG='{
  "mcpServers": {
    "engram": {
      "command": "uvx",
      "args": ["--from", "git+https://github.com/astrosteveo/engram", "engram-mcp"]
    }
  }
}'

if [ -f "$MCP_FILE" ]; then
    # Check if engram already configured
    if grep -q '"engram"' "$MCP_FILE" 2>/dev/null; then
        echo "  MCP: engram already configured in .mcp.json"
    else
        # Merge with existing config using Python
        echo "  MCP: Adding engram to existing .mcp.json"
        python3 -c "
import json
with open('$MCP_FILE') as f:
    config = json.load(f)
config.setdefault('mcpServers', {})['engram'] = {
    'command': 'uvx',
    'args': ['--from', 'git+https://github.com/astrosteveo/engram', 'engram-mcp']
}
with open('$MCP_FILE', 'w') as f:
    json.dump(config, f, indent=2)
    f.write('\n')
"
    fi
else
    echo "  MCP: Creating .mcp.json"
    echo "$MCP_CONFIG" > "$MCP_FILE"
fi

# Create .engram directory
mkdir -p "$TARGET_DIR/.engram"
echo "  Created .engram/ directory"

# Add to .gitignore if it exists
GITIGNORE="$TARGET_DIR/.gitignore"
if [ -f "$GITIGNORE" ]; then
    if ! grep -q "^\.engram/" "$GITIGNORE" 2>/dev/null; then
        echo "" >> "$GITIGNORE"
        echo "# Engram memory" >> "$GITIGNORE"
        echo ".engram/" >> "$GITIGNORE"
        echo "  Added .engram/ to .gitignore"
    fi
fi

echo ""
echo "Done! Installed:"
echo "  - Commands: /engram/remember, /engram/resume, /engram/search, /engram/stats, /engram/sync"
echo "  - Skill: engram"
echo "  - MCP server: engram"
echo ""
echo "Restart Claude Code to enable."
