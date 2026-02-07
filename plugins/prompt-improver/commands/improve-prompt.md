---
description: Improve a prompt using prompt engineering best practices and copy the result to your clipboard
argument-hint: <paste or type your prompt here>
allowed-tools: Bash(bash ${CLAUDE_PLUGIN_ROOT}/scripts/clipboard.sh *)
---

# Prompt Improver

Use the prompt-improvement skill to analyze and improve the following prompt:

$ARGUMENTS

Follow the skill's analysis phase, apply the relevant improvement techniques, then follow the output protocol exactly - display the improved prompt in a code block, copy it to the clipboard using the provided script, and briefly summarize what you changed.
