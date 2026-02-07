# Session Features and CLI Reference

Guide to Claude Code session features, CLI flags, and environment variables relevant to plugin developers.

## Session Forking

### How It Works

Session forking creates a new, independent conversation branch from the current point in an active session. The fork preserves the full conversation history up to the fork point, then each branch proceeds independently.

**Mechanism:**
1. User initiates a fork from within the IDE
2. Claude Code copies the full conversation context (messages, tool results, loaded skills)
3. A new session is created with the copied context
4. Both the original and forked sessions continue independently
5. Changes in one session do not affect the other

### Use Cases

- **A/B testing approaches:** Fork before trying two different implementation strategies, then compare results
- **Exploratory branches:** Fork to explore a risky approach without losing the stable conversation
- **Parallel investigations:** Fork to investigate a side issue while the main session continues
- **Checkpoint creation:** Fork before a destructive operation as a rollback point

### Limitations

- Forked sessions share the filesystem but not conversation state after the fork point
- File changes in one session are visible to the other (they share the same working directory)
- No built-in mechanism to merge fork results back together
- Each fork consumes its own context window independently

### Plugin Relevance

Plugin commands and agents work identically in forked sessions. Consider these implications:

- **State files:** Both sessions may read/write the same `.claude/plugin-name.local.md` file, potentially causing conflicts
- **Hook execution:** Hooks fire independently in each session
- **MCP servers:** Shared server instances may receive requests from both sessions
- **File locks:** If plugins use file-based locking, forks can create contention

## Cloud Handoff

### How It Works

Cloud handoff transfers a running Claude Code session from the local terminal to cloud-based execution. The session continues processing in the cloud while the local terminal is freed.

**Flow:**
1. User initiates cloud handoff from the IDE
2. Current session state is serialized and sent to cloud infrastructure
3. Cloud instance picks up execution from the handoff point
4. Local terminal is released
5. Results become available when the cloud session completes

### When to Use

- **Long-running operations:** Tasks expected to take more than a few minutes
- **Resource-intensive work:** Operations requiring sustained compute
- **Background processing:** Work that does not need interactive input
- **Overnight tasks:** Large refactoring, comprehensive testing, or extensive analysis

### Plugin Considerations

- **Interactive commands:** Commands using `AskUserQuestion` will not work in cloud mode since there is no interactive terminal
- **Local file access:** Cloud sessions access the project via remote filesystem; large binary files may be slow
- **Environment variables:** Ensure required env vars are available in the cloud environment
- **MCP servers:** Local MCP servers may not be accessible from cloud; design for graceful degradation

## PR Review Mode

### Using --from-pr

Start Claude Code pre-loaded with pull request context:

```bash
claude --from-pr 123
```

This loads:
- PR title and description
- Changed files and diffs
- PR comments and review status
- Associated issue references

### Detecting PR Context in Plugins

Plugin commands can detect whether they were started in PR review mode by checking the conversation context. The PR information is available in the initial session state.

**Design pattern for PR-aware commands:**

```markdown
---
description: Review code with context-aware analysis
allowed-tools: ["Read", "Grep", "Bash(git:*)"]
---

Check if this session was started with --from-pr context.

If PR context is available:
  Focus review on changed files
  Reference PR description for intent
  Check for issues mentioned in PR

If no PR context:
  Perform general code review on provided files
```

### Plugin Relevance

- Design commands that adapt behavior based on PR context availability
- PR review mode is read-only by convention; avoid commands that push changes
- Use PR metadata (title, description, labels) to inform analysis
- Consider creating PR-specific commands (e.g., `/pr-security-review`)

## Extended Thinking

### MAX_THINKING_TOKENS

Control the maximum number of tokens Claude uses for internal reasoning before responding:

```bash
MAX_THINKING_TOKENS=50000 claude
```

**Default:** Standard thinking budget (varies by model)
**Maximum:** Model-dependent upper limit

### How It Affects Plugins

Extended thinking benefits:
- Complex multi-step reasoning in commands
- Deep code analysis requiring consideration of many factors
- Architectural decisions weighing multiple trade-offs
- Security analysis requiring thorough threat modeling

### When Plugins Should Recommend Extended Thinking

Document in plugin README when extended thinking improves results:

```markdown
## Recommended Settings

For best results with the security-audit command, use extended thinking:

MAX_THINKING_TOKENS=50000 claude
```

**Good candidates for extended thinking:**
- Commands performing complex analysis (security audits, architecture reviews)
- Agents making multi-factor decisions
- Workflows requiring deep context understanding
- Tasks where thoroughness matters more than speed

**Not needed for:**
- Simple file operations
- Straightforward code generation
- Quick lookups and queries
- Commands with well-defined, narrow scope

## CLI Flags Reference

### --agents \<path\>

Override agent discovery with an explicit path:

```bash
claude --agents /path/to/custom/agents
```

**Purpose:** Load agents from a non-standard location, useful for testing or development.

**Plugin relevance:**
- Test plugin agents without installing the full plugin
- Override agent selection during development
- Use alternative agent configurations for different environments

### --max-budget-usd \<n\>

Set a spending limit per session:

```bash
claude --max-budget-usd 5.00
```

**Purpose:** Prevent runaway costs during automated or long-running sessions.

**Plugin relevance:**
- Recommend budget limits for expensive workflows in plugin documentation
- Team-based commands may consume more budget due to multiple agents
- Test plugins with budget limits to ensure graceful degradation when limit is reached

### --disallowedTools \<tools\>

Block specific tools from being used:

```bash
claude --disallowedTools "Bash,Write"
```

**Purpose:** Restrict Claude's capabilities for safety or compliance.

**Plugin relevance:**
- Test that plugins degrade gracefully when tools are restricted
- Document which tools are required vs optional for plugin functionality
- Consider users who run with restricted tool sets
- Commands with `allowed-tools` frontmatter interact with this flag; disallowed tools take precedence

### --plugin-dir \<path\>

Load a plugin directly from a local directory:

```bash
claude --plugin-dir /path/to/my-plugin
```

**Purpose:** Development and testing of plugins without installation.

**Plugin relevance:**
- Primary development workflow for plugin creators
- Test changes immediately without publish/install cycle
- Verify plugin structure and component discovery
- Debug loading issues

### --from-pr \<number\>

Start in pull request review context:

```bash
claude --from-pr 123
```

**Purpose:** Pre-load PR context for review workflows.

**Plugin relevance:** See the PR Review Mode section above for detailed guidance.

## Environment Variables

### MAX_THINKING_TOKENS

Control extended thinking budget. See the Extended Thinking section above.

```bash
export MAX_THINKING_TOKENS=50000
```

### CLAUDE_CODE_REMOTE

Indicates the session is running in a remote or cloud environment:

```bash
# Set automatically in cloud handoff sessions
CLAUDE_CODE_REMOTE=true
```

**Plugin relevance:**
- Detect cloud environment and adjust behavior
- Disable features requiring local resources
- Skip interactive prompts in remote sessions
- Adjust file paths for remote filesystem

### CLAUDE_PLUGIN_ROOT

The absolute path to the plugin's root directory, set automatically for each plugin:

```bash
# Available in hook scripts and command execution
echo $CLAUDE_PLUGIN_ROOT
```

**Plugin relevance:**
- Essential for all intra-plugin path references
- Used in hook commands, MCP server args, and script execution
- Never hardcode paths; always use this variable
- See the plugin-structure skill for complete documentation

### CLAUDE_PROJECT_ROOT

The absolute path to the user's project root directory:

```bash
echo $CLAUDE_PROJECT_ROOT
```

**Plugin relevance:**
- Reference project files from plugin scripts
- Locate project-level configuration
- Distinguish between plugin files and project files

### General Environment Guidance

- Document all required environment variables in plugin README
- Provide fallback behavior when optional env vars are missing
- Never hardcode values that should come from environment
- Test plugins with and without optional env vars set
- Use `.env` files or shell profiles for persistent configuration
- Consider security: never log sensitive env var values

## Quick Reference Table

| Feature | Invocation | Plugin Impact |
|---------|-----------|---------------|
| Session fork | IDE feature | State file conflicts possible |
| Cloud handoff | IDE feature | No interactive input available |
| PR review | `--from-pr N` | Adapt commands to PR context |
| Extended thinking | `MAX_THINKING_TOKENS=N` | Better for complex analysis |
| Custom agents | `--agents path` | Test agents independently |
| Budget limit | `--max-budget-usd N` | Test graceful degradation |
| Tool restrictions | `--disallowedTools` | Test with restricted tools |
| Plugin dev | `--plugin-dir path` | Primary dev workflow |
| Remote detection | `CLAUDE_CODE_REMOTE` | Adjust for cloud environment |
