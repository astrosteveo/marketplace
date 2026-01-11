---
name: harness:bootstrap
description: Initialize harness workflow and check for in-progress features. Shows status of existing features and provides entry points to start new or resume work.
allowed-tools: Read, Bash, Glob, Grep, Skill, AskUserQuestion
---

# Harness Bootstrap

Initialize the harness workflow environment and provide entry points.

---

## Instructions

### 1. Setup

Check if `.artifacts/` exists. If not, create it:

```bash
mkdir -p .artifacts
```

### 2. Scan for In-Progress Features

Search for existing feature directories:

```bash
ls -1 .artifacts/
```

For each directory found, read `progress.md` and extract:
- Feature name
- Current phase
- Last updated date

### 3. Present Status

**If no features exist:**
```
Harness initialized. No features in progress.

Ready to start? Describe your feature or run /harness:feature-discovery
```

**If features exist:**
```
Harness Status
==============

In Progress:
  - {feature-name} (Phase {N}: {phase-name}) - last updated {date}
  - ...

Options:
  1. Resume {most-recent-feature}
  2. Start new feature
```

### 4. Route to Next Step

Use AskUserQuestion to let user choose:
- **Resume**: Invoke `/harness:orchestrator {feature-slug}`
- **New**: Ask what they want to build, then invoke `/harness:feature-discovery`

---

## Phase Reference

| Phase | Name |
|-------|------|
| 1 | Discovery |
| 2 | Codebase Exploration |
| 3 | Clarifying Questions |
| 4 | Architecture Design |
| 5 | Implementation |
| 6 | Quality Review |
| 7 | Manual Testing |
| 8 | Summary |
