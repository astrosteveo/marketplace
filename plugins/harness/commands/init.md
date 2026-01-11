---
name: harness:init
description: Initialize or update harness in the current project
allowed-tools: Bash
argument-hint: [--update | --force]
---

Initialize harness in the current project by copying skills and agents to `.claude/`.

**Flags:**
- (no flag): First install - skip existing files
- `--update`: Smart update - update unchanged files, preserve customized ones
- `--force`: Overwrite everything

Run the init script:
`!${CLAUDE_PLUGIN_ROOT}/scripts/init.sh $ARGUMENTS`

Report the results to the user. Explain what was installed/updated/preserved.
