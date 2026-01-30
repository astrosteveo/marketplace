# Plugin Init Plugins Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Create init companion plugins for each marketplace plugin that copy plugin contents from git to project `.claude/` directory, enabling skills to appear as unnnamespaced slash commands.

**Architecture:** Each init plugin has a single install command that runs a bash script. The script does a sparse git clone of the marketplace repo, copies the relevant plugin's skills/commands/agents to `.claude/`, handles hooks by rewriting paths and merging into settings.json, then cleans up.

**Tech Stack:** Bash, git sparse-checkout, jq (for hooks merging)

---

## Plugins to Create Init Versions For

| Plugin | Skills | Commands | Agents | Hooks |
|--------|--------|----------|--------|-------|
| claude-code-setup | 1 | 0 | 0 | 0 |
| claude-md-management | 1 | 1 | 0 | 0 |
| feature-dev | 0 | 1 | 6 | 0 |
| frontend-design | 1 | 0 | 0 | 0 |
| plugin-dev | 7 | 1 | 3 | 0 |
| superpowers | 14 | 3 | 1 | 3 |

---

## Task 1: Create Shared Install Script Template

**Files:**
- Create: `plugins/plugin-init-template/scripts/install.sh`

**Step 1: Write the install script template**

This script will be copied and customized for each init plugin.

```bash
#!/usr/bin/env bash
set -euo pipefail

# Configuration - customize per plugin
REPO="https://github.com/astrosteveo/marketplace.git"
PLUGIN_NAME="PLUGIN_NAME_HERE"
PLUGIN_PATH="plugins/$PLUGIN_NAME"

# Derived paths
TEMP_DIR=$(mktemp -d)
TARGET_DIR="${CLAUDE_PROJECT_DIR:-.}/.claude"

cleanup() {
  rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

echo "Installing $PLUGIN_NAME to $TARGET_DIR..."

# Sparse clone just the plugin we need
cd "$TEMP_DIR"
git clone --depth 1 --filter=blob:none --sparse "$REPO" repo 2>/dev/null
cd repo
git sparse-checkout set "$PLUGIN_PATH" 2>/dev/null

# Create target directories
mkdir -p "$TARGET_DIR/skills" "$TARGET_DIR/commands" "$TARGET_DIR/agents"

# Copy components if they exist
if [ -d "$PLUGIN_PATH/skills" ]; then
  cp -r "$PLUGIN_PATH/skills/"* "$TARGET_DIR/skills/" 2>/dev/null || true
  echo "  Copied skills"
fi

if [ -d "$PLUGIN_PATH/commands" ]; then
  cp -r "$PLUGIN_PATH/commands/"* "$TARGET_DIR/commands/" 2>/dev/null || true
  echo "  Copied commands"
fi

if [ -d "$PLUGIN_PATH/agents" ]; then
  cp -r "$PLUGIN_PATH/agents/"* "$TARGET_DIR/agents/" 2>/dev/null || true
  echo "  Copied agents"
fi

# Handle hooks if present
if [ -d "$PLUGIN_PATH/hooks" ]; then
  mkdir -p "$TARGET_DIR/hooks/$PLUGIN_NAME"

  # Copy hook scripts
  for f in "$PLUGIN_PATH/hooks/"*; do
    if [ -f "$f" ] && [ "$(basename "$f")" != "hooks.json" ]; then
      cp "$f" "$TARGET_DIR/hooks/$PLUGIN_NAME/"
    fi
  done

  # Process hooks.json if it exists
  if [ -f "$PLUGIN_PATH/hooks/hooks.json" ]; then
    HOOKS_JSON="$PLUGIN_PATH/hooks/hooks.json"
    SETTINGS_FILE="$TARGET_DIR/settings.json"

    # Rewrite paths: ${CLAUDE_PLUGIN_ROOT} -> $CLAUDE_PROJECT_DIR/.claude/hooks/PLUGIN_NAME
    REWRITTEN=$(cat "$HOOKS_JSON" | sed "s|\${CLAUDE_PLUGIN_ROOT}/hooks|\$CLAUDE_PROJECT_DIR/.claude/hooks/$PLUGIN_NAME|g")

    # Extract just the hooks object (unwrap from plugin format)
    HOOKS_CONTENT=$(echo "$REWRITTEN" | jq '.hooks')

    # Merge into settings.json
    if [ -f "$SETTINGS_FILE" ]; then
      # Merge with existing settings
      EXISTING=$(cat "$SETTINGS_FILE")
      if echo "$EXISTING" | jq -e '.hooks' >/dev/null 2>&1; then
        # Has existing hooks, deep merge
        MERGED=$(echo "$EXISTING" | jq --argjson new "$HOOKS_CONTENT" '.hooks = (.hooks * $new)')
      else
        # No existing hooks, add them
        MERGED=$(echo "$EXISTING" | jq --argjson new "$HOOKS_CONTENT" '. + {hooks: $new}')
      fi
      echo "$MERGED" > "$SETTINGS_FILE"
    else
      # Create new settings.json
      echo "{\"hooks\": $HOOKS_CONTENT}" | jq '.' > "$SETTINGS_FILE"
    fi
    echo "  Merged hooks into settings.json"
  fi

  echo "  Copied hook scripts to hooks/$PLUGIN_NAME/"
fi

echo ""
echo "Done! $PLUGIN_NAME installed to .claude/"
echo "Skills are now available as /skill-name (no plugin prefix)"
```

**Step 2: Verify script is valid bash**

Run: `bash -n plugins/plugin-init-template/scripts/install.sh`
Expected: No output (syntax OK)

**Step 3: Commit**

```bash
git add plugins/plugin-init-template/scripts/install.sh
git commit -m "feat: add shared install script template for init plugins"
```

---

## Task 2: Create superpowers-init Plugin

**Files:**
- Create: `plugins/superpowers-init/.claude-plugin/plugin.json`
- Create: `plugins/superpowers-init/commands/install.md`
- Create: `plugins/superpowers-init/scripts/install.sh`

**Step 1: Create plugin.json**

```json
{
  "name": "superpowers-init",
  "description": "Install superpowers plugin directly to project .claude/ directory for unnnamespaced skill access",
  "author": {
    "name": "Jesse Vincent",
    "email": "jesse@fsck.com"
  },
  "repository": "https://github.com/astrosteveo/marketplace",
  "license": "MIT",
  "keywords": ["init", "installer", "superpowers"]
}
```

**Step 2: Create install command**

```markdown
---
description: "Install superpowers skills, commands, agents, and hooks to .claude/ for unnnamespaced access"
---

Run the install script to copy superpowers to the project's .claude/ directory:

\`\`\`bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/install.sh
\`\`\`

After installation, skills like `brainstorming` will be available as `/brainstorming` instead of `/superpowers:brainstorming`.
```

**Step 3: Create install script (copy from template, set PLUGIN_NAME)**

Copy template and set `PLUGIN_NAME="superpowers"`

**Step 4: Test script syntax**

Run: `bash -n plugins/superpowers-init/scripts/install.sh`
Expected: No output (syntax OK)

**Step 5: Commit**

```bash
git add plugins/superpowers-init/
git commit -m "feat: add superpowers-init plugin"
```

---

## Task 3: Create plugin-dev-init Plugin

**Files:**
- Create: `plugins/plugin-dev-init/.claude-plugin/plugin.json`
- Create: `plugins/plugin-dev-init/commands/install.md`
- Create: `plugins/plugin-dev-init/scripts/install.sh`

**Step 1: Create plugin.json**

```json
{
  "name": "plugin-dev-init",
  "description": "Install plugin-dev plugin directly to project .claude/ directory for unnnamespaced skill access",
  "author": {
    "name": "Jesse Vincent",
    "email": "jesse@fsck.com"
  },
  "repository": "https://github.com/astrosteveo/marketplace",
  "license": "MIT",
  "keywords": ["init", "installer", "plugin-dev"]
}
```

**Step 2: Create install command**

```markdown
---
description: "Install plugin-dev skills, commands, and agents to .claude/ for unnnamespaced access"
---

Run the install script to copy plugin-dev to the project's .claude/ directory:

\`\`\`bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/install.sh
\`\`\`

After installation, skills like `skill-development` will be available as `/skill-development` instead of `/plugin-dev:skill-development`.
```

**Step 3: Create install script (copy from template, set PLUGIN_NAME="plugin-dev")**

**Step 4: Test script syntax**

Run: `bash -n plugins/plugin-dev-init/scripts/install.sh`
Expected: No output (syntax OK)

**Step 5: Commit**

```bash
git add plugins/plugin-dev-init/
git commit -m "feat: add plugin-dev-init plugin"
```

---

## Task 4: Create feature-dev-init Plugin

**Files:**
- Create: `plugins/feature-dev-init/.claude-plugin/plugin.json`
- Create: `plugins/feature-dev-init/commands/install.md`
- Create: `plugins/feature-dev-init/scripts/install.sh`

**Step 1: Create plugin.json**

```json
{
  "name": "feature-dev-init",
  "description": "Install feature-dev plugin directly to project .claude/ directory for unnnamespaced agent access",
  "author": {
    "name": "Jesse Vincent",
    "email": "jesse@fsck.com"
  },
  "repository": "https://github.com/astrosteveo/marketplace",
  "license": "MIT",
  "keywords": ["init", "installer", "feature-dev"]
}
```

**Step 2: Create install command**

```markdown
---
description: "Install feature-dev commands and agents to .claude/ for unnnamespaced access"
---

Run the install script to copy feature-dev to the project's .claude/ directory:

\`\`\`bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/install.sh
\`\`\`

After installation, agents like `code-explorer` will be available without the plugin prefix.
```

**Step 3: Create install script (copy from template, set PLUGIN_NAME="feature-dev")**

**Step 4: Test script syntax**

Run: `bash -n plugins/feature-dev-init/scripts/install.sh`
Expected: No output (syntax OK)

**Step 5: Commit**

```bash
git add plugins/feature-dev-init/
git commit -m "feat: add feature-dev-init plugin"
```

---

## Task 5: Create frontend-design-init Plugin

**Files:**
- Create: `plugins/frontend-design-init/.claude-plugin/plugin.json`
- Create: `plugins/frontend-design-init/commands/install.md`
- Create: `plugins/frontend-design-init/scripts/install.sh`

**Step 1: Create plugin.json**

```json
{
  "name": "frontend-design-init",
  "description": "Install frontend-design plugin directly to project .claude/ directory for unnnamespaced skill access",
  "author": {
    "name": "Jesse Vincent",
    "email": "jesse@fsck.com"
  },
  "repository": "https://github.com/astrosteveo/marketplace",
  "license": "MIT",
  "keywords": ["init", "installer", "frontend-design"]
}
```

**Step 2: Create install command**

```markdown
---
description: "Install frontend-design skill to .claude/ for unnnamespaced access"
---

Run the install script to copy frontend-design to the project's .claude/ directory:

\`\`\`bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/install.sh
\`\`\`

After installation, the `frontend-design` skill will be available as `/frontend-design` instead of `/frontend-design:frontend-design`.
```

**Step 3: Create install script (copy from template, set PLUGIN_NAME="frontend-design")**

**Step 4: Test script syntax**

Run: `bash -n plugins/frontend-design-init/scripts/install.sh`
Expected: No output (syntax OK)

**Step 5: Commit**

```bash
git add plugins/frontend-design-init/
git commit -m "feat: add frontend-design-init plugin"
```

---

## Task 6: Create claude-code-setup-init Plugin

**Files:**
- Create: `plugins/claude-code-setup-init/.claude-plugin/plugin.json`
- Create: `plugins/claude-code-setup-init/commands/install.md`
- Create: `plugins/claude-code-setup-init/scripts/install.sh`

**Step 1: Create plugin.json**

```json
{
  "name": "claude-code-setup-init",
  "description": "Install claude-code-setup plugin directly to project .claude/ directory for unnnamespaced skill access",
  "author": {
    "name": "Jesse Vincent",
    "email": "jesse@fsck.com"
  },
  "repository": "https://github.com/astrosteveo/marketplace",
  "license": "MIT",
  "keywords": ["init", "installer", "claude-code-setup"]
}
```

**Step 2: Create install command**

```markdown
---
description: "Install claude-code-setup skill to .claude/ for unnnamespaced access"
---

Run the install script to copy claude-code-setup to the project's .claude/ directory:

\`\`\`bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/install.sh
\`\`\`

After installation, the `claude-automation-recommender` skill will be available as `/claude-automation-recommender`.
```

**Step 3: Create install script (copy from template, set PLUGIN_NAME="claude-code-setup")**

**Step 4: Test script syntax**

Run: `bash -n plugins/claude-code-setup-init/scripts/install.sh`
Expected: No output (syntax OK)

**Step 5: Commit**

```bash
git add plugins/claude-code-setup-init/
git commit -m "feat: add claude-code-setup-init plugin"
```

---

## Task 7: Create claude-md-management-init Plugin

**Files:**
- Create: `plugins/claude-md-management-init/.claude-plugin/plugin.json`
- Create: `plugins/claude-md-management-init/commands/install.md`
- Create: `plugins/claude-md-management-init/scripts/install.sh`

**Step 1: Create plugin.json**

```json
{
  "name": "claude-md-management-init",
  "description": "Install claude-md-management plugin directly to project .claude/ directory for unnnamespaced skill access",
  "author": {
    "name": "Jesse Vincent",
    "email": "jesse@fsck.com"
  },
  "repository": "https://github.com/astrosteveo/marketplace",
  "license": "MIT",
  "keywords": ["init", "installer", "claude-md-management"]
}
```

**Step 2: Create install command**

```markdown
---
description: "Install claude-md-management skills and commands to .claude/ for unnnamespaced access"
---

Run the install script to copy claude-md-management to the project's .claude/ directory:

\`\`\`bash
bash ${CLAUDE_PLUGIN_ROOT}/scripts/install.sh
\`\`\`

After installation, skills like `claude-md-improver` will be available as `/claude-md-improver`.
```

**Step 3: Create install script (copy from template, set PLUGIN_NAME="claude-md-management")**

**Step 4: Test script syntax**

Run: `bash -n plugins/claude-md-management-init/scripts/install.sh`
Expected: No output (syntax OK)

**Step 5: Commit**

```bash
git add plugins/claude-md-management-init/
git commit -m "feat: add claude-md-management-init plugin"
```

---

## Task 8: Add Init Plugins to Marketplace

**Files:**
- Modify: `.claude-plugin/marketplace.json`

**Step 1: Read current marketplace.json**

**Step 2: Add all init plugins to the plugins array**

Add entries for:
- `superpowers-init`
- `plugin-dev-init`
- `feature-dev-init`
- `frontend-design-init`
- `claude-code-setup-init`
- `claude-md-management-init`

**Step 3: Commit**

```bash
git add .claude-plugin/marketplace.json
git commit -m "feat: add all init plugins to marketplace"
```

---

## Task 9: Test End-to-End

**Step 1: Create a test project directory**

```bash
mkdir -p /tmp/test-init-plugin
cd /tmp/test-init-plugin
git init
```

**Step 2: Run superpowers-init install script manually**

```bash
CLAUDE_PROJECT_DIR=/tmp/test-init-plugin bash /path/to/superpowers-init/scripts/install.sh
```

**Step 3: Verify files were copied**

```bash
ls -la /tmp/test-init-plugin/.claude/skills/
ls -la /tmp/test-init-plugin/.claude/commands/
ls -la /tmp/test-init-plugin/.claude/agents/
ls -la /tmp/test-init-plugin/.claude/hooks/
cat /tmp/test-init-plugin/.claude/settings.json
```

Expected: All superpowers content present, hooks merged into settings.json with rewritten paths

**Step 4: Cleanup**

```bash
rm -rf /tmp/test-init-plugin
```

**Step 5: Commit test verification notes (optional)**

---

## Summary

After completing all tasks:
- 6 new init plugins created
- Each has install command + script
- Shared script template for consistency
- Hooks handling with path rewriting
- All registered in marketplace.json

Users can now:
1. `/plugin install superpowers-init@astrosteveo-marketplace`
2. `/superpowers-init:install`
3. Use `/brainstorming` instead of `/superpowers:brainstorming`
