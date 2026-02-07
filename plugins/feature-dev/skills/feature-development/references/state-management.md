# State Management Reference

Comprehensive guide for persistent memory in the feature-development workflow.

## Overview

The feature-dev plugin uses `.claude/feature-dev.local.md` to persist feature progress across sessions. This enables:
- **Resume capability**: Continue from where you left off
- **Context preservation**: Decisions and findings survive session restarts
- **Progress tracking**: Visual milestone completion across sessions

## State File Location

```
project-root/
└── .claude/
    └── feature-dev.local.md        # Active feature state
    └── feature-dev.local.md.archived-20250204  # Archived features
```

## Loading State

### When to Load

State is loaded at **skill activation** (when `/feature-dev` is invoked), not at session start.

### Load Process

```
1. Check if .claude/feature-dev.local.md exists
2. If exists:
   a. Parse YAML frontmatter
   b. Present resume options to user:
      - Resume from current phase
      - Start new feature (archive current)
      - Review full state before deciding
3. If not exists:
   a. Start fresh workflow
   b. Create state file after Phase 1
```

### Resume Detection Logic

```bash
STATE_FILE=".claude/feature-dev.local.md"

if [[ -f "$STATE_FILE" ]]; then
  # Parse YAML frontmatter
  FRONTMATTER=$(sed -n '/^---$/,/^---$/{ /^---$/d; p; }' "$STATE_FILE")

  # Extract key fields
  FEATURE_NAME=$(echo "$FRONTMATTER" | grep '^feature_name:' | sed 's/feature_name: *//' | tr -d '"')
  CURRENT_PHASE=$(echo "$FRONTMATTER" | grep '^current_phase:' | sed 's/current_phase: *//' | tr -d '"')
  LAST_UPDATED=$(echo "$FRONTMATTER" | grep '^last_updated:' | sed 's/last_updated: *//' | tr -d '"')
  MILESTONE_NUM=$(echo "$FRONTMATTER" | grep '^current_milestone:' | sed 's/current_milestone: *//')
  TOTAL_MILESTONES=$(echo "$FRONTMATTER" | grep '^total_milestones:' | sed 's/total_milestones: *//')
fi
```

### Resume Prompt Format

```
Found existing feature work: "[feature_name]"

Status:
- Phase: [current_phase] ([phase_status])
- Last updated: [relative time]
- Milestones: [current]/[total] complete

Options:
1. **Resume** - Continue from [current_phase]
2. **New Feature** - Archive current and start fresh
3. **Review State** - Show full state before deciding
```

## Saving State

### Save Points

State is saved at specific transition points:

| Trigger | Fields Updated |
|---------|----------------|
| Phase 1 complete | current_phase, discovery summary in body |
| Phase 2 complete | current_phase, Q&A pairs in body |
| Phase 3 complete | current_phase, chosen_approach, milestones in body, total_milestones |
| Each milestone complete | current_milestone, milestones_completed, files modified |
| Phase 5 complete | current_phase, review findings |
| Phase 6 complete | current_phase="summary", final summary |
| Session end (hook) | last_updated, session_count |

### Save Process

1. Read current state file
2. Update YAML frontmatter fields
3. Append/update markdown body sections
4. Write atomically (temp file + rename)

### Atomic Write Pattern

```bash
STATE_FILE=".claude/feature-dev.local.md"
TEMP_FILE="${STATE_FILE}.tmp.$$"

# Write new content to temp file
cat > "$TEMP_FILE" << 'EOF'
[new content]
EOF

# Atomic rename
mv "$TEMP_FILE" "$STATE_FILE"
```

## Phase-Specific State Updates

### After Phase 1: Discovery

```yaml
current_phase: "clarifying"
phase_status: "pending"
```

Body additions:
- Discovery Summary section with findings
- Similar features, architecture patterns, testing conventions

### After Phase 2: Clarifying Questions

```yaml
current_phase: "architecture"
phase_status: "pending"
```

Body additions:
- All Q&A pairs with answers

### After Phase 3: Architecture

```yaml
current_phase: "implementation"  # or "impact" if triggered
phase_status: "pending"
implementation_mode: "[user choice]"
chosen_approach: "[approach name]"
approach_rationale: "[brief rationale]"
total_milestones: [count]
```

Body additions:
- Full architecture decision details
- Milestone list with descriptions

### After Each Milestone

```yaml
current_milestone: [N+1]
milestones_completed: ["1", "2", ..., "N"]
```

Body updates:
- Mark milestone as [COMPLETED] in list
- Add files to "Files Modified" section
- Log any key decisions

### After Phase 5: Review

```yaml
current_phase: "summary"
phase_status: "in_progress"
```

Body additions:
- Review findings and resolutions

### After Phase 6: Summary

```yaml
current_phase: "summary"
phase_status: "completed"
```

Body additions:
- Final summary
- Documentation suggestions
- Next steps

## Archiving Features

When starting a new feature with existing state:

1. Rename current file with timestamp:
   ```
   .claude/feature-dev.local.md → .claude/feature-dev.local.md.archived-20250204-143000
   ```

2. Create fresh state file for new feature

### Archive Naming

```
feature-dev.local.md.archived-YYYYMMDD-HHMMSS
```

## Handling Edge Cases

### Corrupted State File

If YAML parsing fails:
1. Present warning to user
2. Offer to view raw file
3. Options: Fix manually, archive and start fresh

### Stale State

If tracked files no longer exist or have unexpected changes:
1. Detect during resume
2. Warn user about potential drift
3. Suggest reviewing state before continuing

### Multi-Feature Work

Current design: Single active feature at a time.

Future extension (not implemented):
- `feature-dev-[feature-id].local.md` pattern
- Feature switching commands

## Settings Integration

The state file also stores per-feature settings:

```yaml
# Auto-commit Settings
auto_commit: true                    # Enable/disable auto-commit
require_confirmation: false          # Prompt before each commit
```

These settings are:
- Set during Phase 3 (user choice)
- Can be manually edited in state file
- Honored during Phase 4 implementation
