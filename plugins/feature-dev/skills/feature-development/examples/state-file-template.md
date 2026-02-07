# State File Template

Template for `.claude/feature-dev.local.md` - the persistent memory file for feature development.

## Usage

This file is automatically created and updated by the feature-development skill. You can also create it manually to pre-configure settings.

## Template

```markdown
---
# Feature Identification
feature_id: ""                       # Auto-generated: feature-name-YYYY-MM-DD
feature_name: ""                     # Human-readable name from request
started_at: ""                       # ISO timestamp when feature started
last_updated: ""                     # ISO timestamp of last update

# Progress Tracking
current_phase: "discovery"           # discovery|clarifying|architecture|impact|implementation|review|summary
phase_status: "pending"              # pending|in_progress|completed|blocked
implementation_mode: ""              # lightweight|balanced|thorough (set in Phase 3)

# Milestone Tracking
current_milestone: 0                 # Current milestone number (1-indexed)
total_milestones: 0                  # Total milestones planned (set in Phase 3)
milestones_completed: []             # Array of completed milestone numbers

# Architecture Decision
chosen_approach: ""                  # Name/identifier of chosen approach
approach_rationale: ""               # Why this approach was chosen

# Auto-commit Settings
auto_commit: true                    # Enable/disable auto-commit per milestone
require_confirmation: false          # Prompt before each commit

# Session Context
enabled: true                        # Quick enable/disable for hooks
session_count: 1                     # Number of sessions on this feature
---

# Feature: [Feature Name]

## Original Request

[Copy of the user's original feature request]

## Discovery Summary

[Key findings from Phase 1 exploration - filled after Phase 1]

### Similar Features Found
- [file path] - [pattern description]

### Architecture Patterns
- [pattern name] - [how it's used]

### Testing Conventions
- Framework: [testing framework]
- Location: [test file locations]
- Patterns: [mocking, fixtures, etc.]

## Clarifying Questions & Answers

[Q&A pairs from Phase 2 - filled after Phase 2]

### Q1: [Question]
**Answer**: [User's answer]

### Q2: [Question]
**Answer**: [User's answer]

## Architecture Decision

[Chosen approach details from Phase 3 - filled after Phase 3]

### Chosen: [Approach Name]

**Components**:
1. [Component 1]
2. [Component 2]

**Trade-offs accepted**:
- [Trade-off 1]

### Test Strategy
- Unit tests: [approach]
- Integration tests: [approach]

## Milestones

[Milestone list with status - filled after Phase 3, updated during Phase 4]

### Milestone 1: [Name] [STATUS]
- Files: [list]
- Deliverables: [list]

### Milestone 2: [Name] [STATUS]
- Files: [list]
- Deliverables: [list]

## Files Modified

[Running list of changed files - updated during Phase 4]

- `path/to/file.ts` (created)
- `path/to/other.ts` (modified)

## Key Decisions Log

| Decision | Rationale | Date |
|----------|-----------|------|
| [Decision] | [Why] | [YYYY-MM-DD] |

## Notes

[Free-form notes for context that doesn't fit elsewhere]
```

## Field Reference

### Progress Tracking Fields

| Field | Values | Updated When |
|-------|--------|--------------|
| `current_phase` | discovery, clarifying, architecture, impact, implementation, review, summary | Phase transition |
| `phase_status` | pending, in_progress, completed, blocked | Phase start/end |
| `implementation_mode` | lightweight, balanced, thorough | Phase 3 user choice |

### Milestone Tracking Fields

| Field | Type | Updated When |
|-------|------|--------------|
| `current_milestone` | number | Milestone start |
| `total_milestones` | number | Phase 3 architecture chosen |
| `milestones_completed` | array | Milestone completion |

### Auto-commit Settings

| Field | Default | Effect |
|-------|---------|--------|
| `auto_commit` | true | When false, skips all auto-commits |
| `require_confirmation` | false | When true, prompts before each commit |

## Gitignore

Add to your project's `.gitignore`:

```gitignore
# Feature-dev plugin state
.claude/feature-dev.local.md
.claude/feature-dev.local.md.archived-*
```
