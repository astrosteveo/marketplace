# Claude Code Settings System Reference

Complete reference for Claude Code's settings hierarchy, permission system, and managed settings.

## Settings Hierarchy

Claude Code settings are resolved from multiple sources with a clear precedence:

### 1. Managed Settings (Highest Priority)

Deployed by enterprise IT. Cannot be overridden by users or plugins.

**Location:** System-managed (not user-accessible)
**Use case:** Enterprise security policies, approved tools, MCP restrictions

### 2. CLI Flags

Settings passed via command line flags.

**Example:**
```bash
claude --max-budget-usd 10 --disallowedTools "Bash"
```

### 3. Local Project Settings

Per-project, per-user settings. Not committed to git.

**Location:** `.claude/settings.local.json`
**Use case:** Personal project preferences, local tool approvals

### 4. Shared Project Settings

Per-project settings shared with the team.

**Location:** `.claude/settings.json`
**Use case:** Team-wide conventions, shared permissions

### 5. User Settings (Lowest Priority)

Global user preferences.

**Location:** `~/.claude/settings.json`
**Use case:** Personal defaults across all projects

## Settings File Format

All settings files use JSON format with optional `$schema` for validation:

```json
{
  "$schema": "https://cdn.claude.ai/settings-schema.json",
  "permissions": {
    "allow": ["Read", "Glob", "Grep", "Write", "Edit"],
    "deny": ["Bash(rm:*)", "Bash(sudo:*)"]
  },
  "env": {
    "CUSTOM_VAR": "value"
  }
}
```

## Permission System

### Permission Rules Format

```json
{
  "permissions": {
    "allow": [
      "Read",
      "Write",
      "Bash(git:*)",
      "Bash(npm:*)",
      "mcp__myserver__*"
    ],
    "deny": [
      "Bash(rm:*)",
      "Bash(sudo:*)"
    ]
  }
}
```

**Pattern syntax:**
- `"ToolName"` — Allow/deny specific tool
- `"Bash(command:*)"` — Allow/deny bash with command prefix
- `"mcp__server__*"` — Allow/deny all tools from MCP server

### How Plugins Interact with Permissions

Plugins should:
1. Document which tools they require
2. Handle permission denials gracefully
3. Provide fallback behavior when tools are restricted
4. Use `allowed-tools` in commands to declare needs upfront

## Managed Settings (Enterprise)

### What Can Be Managed

- Tool permissions (allow/deny lists)
- MCP server allow/deny lists
- Maximum spending limits
- Model restrictions
- Auto-update behavior

### Plugin Developer Implications

1. **Test with restrictions**: Verify your plugin works when tools are limited
2. **Graceful degradation**: Don't crash when a tool is denied
3. **Document requirements**: List minimum required tools
4. **Enterprise guide**: Provide IT teams with configuration guidance

## Behavioral Settings

| Setting | Type | Default | Description |
|---------|------|---------|-------------|
| `permissions` | Object | {} | Tool allow/deny rules |
| `mcpToolApproval` | Object | {} | Per-server tool approval settings |
| `env` | Object | {} | Environment variable overrides |
| `disableAutoUpdater` | Boolean | false | Disable Claude Code auto-updates |
| `maxBudgetUsd` | Number | none | Maximum spending per session |

## Integration with Plugin Settings

**Plugin `.local.md` files** are separate from Claude Code's settings system:

| Aspect | Claude Code Settings | Plugin Settings |
|--------|---------------------|----------------|
| Format | JSON | YAML frontmatter + Markdown |
| Location | `.claude/settings*.json` | `.claude/plugin-name.local.md` |
| Scope | Claude Code behavior | Plugin-specific configuration |
| Managed | Can be enterprise-managed | User-managed only |
| Purpose | Tool permissions, approvals | Plugin state, preferences |

Both systems coexist. Plugins read their own `.local.md` files for configuration while Claude Code's settings control the broader environment.
