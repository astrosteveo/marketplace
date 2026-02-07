# Feature-Dev Plugin Enhancement Plan

Enhance the existing feature-dev plugin with **persistent memory** and **auto-commit per milestone** functionality.

## Summary

- **Plugin**: [plugins/feature-dev/](plugins/feature-dev/)
- **Scope**: Add 2 new features to existing 6-phase workflow
- **New components**: 1 agent, 1 skill reference, 1 hook, 3 scripts, 2 example templates

---

## Feature 1: Persistent Memory System

Track feature progress & decisions across sessions using `.claude/feature-dev.local.md`.

### State File Schema

```yaml
---
# Feature Identification
feature_id: "auth-oauth-2025-02-04"
feature_name: "OAuth Authentication"
started_at: "2025-02-04T14:30:00Z"
last_updated: "2025-02-04T16:45:00Z"

# Progress Tracking
current_phase: "implementation"  # discovery|clarifying|architecture|impact|implementation|review|summary
phase_status: "in_progress"
implementation_mode: "balanced"

# Milestone Tracking
current_milestone: 2
total_milestones: 5
milestones_completed: ["1"]

# Architecture Decision
chosen_approach: "clean_architecture"
approach_rationale: "Better testability"

# Auto-commit Settings
auto_commit: true
require_confirmation: false

# Session Context
enabled: true
session_count: 3
---

# Feature: [Name]

## Original Request
[User's original request]

## Discovery Summary
[Phase 1 findings]

## Clarifying Questions & Answers
[Phase 2 Q&A pairs]

## Architecture Decision
[Phase 3 chosen approach and details]

## Milestones
[Milestone list with status]

## Files Modified
[Running list of changed files]
```

### Integration Points

1. **Load**: At skill activation, check for existing state file
2. **Save**: After each phase transition and milestone completion
3. **Backup**: Stop hook saves timestamp and session count

---

## Feature 2: Auto-Commit System

Automatically commit after each verified milestone.

### Workflow Integration

Modified Phase 4 per-milestone cycle:
```
A. Implement → B. Quick Verify → C. Mini-Review → D. Architecture Alignment → E. AUTO-COMMIT (NEW) → F. User Checkpoint → G. Mark Complete
```

### Commit Message Format

```
feat(auth): implement OAuth provider abstraction

- Created OAuthProvider base class
- Added GoogleProvider implementation
- Integrated with auth middleware

Milestone: 2/5 - OAuth Provider Abstraction
Verification: type:PASS lint:PASS tests:4/4
Files: 3 changed
```

### Error Handling

| Error | Response |
|-------|----------|
| Pre-commit hook fails | Auto-fix if possible, retry (max 2) |
| Merge conflict | Pause, present to user |
| Git not initialized | Skip auto-commit |

---

## Files to Create

| File | Purpose |
|------|---------|
| `agents/auto-committer.md` | Execute commits with error handling |
| `hooks/hooks.json` | Stop hook for state backup |
| `hooks/scripts/save-state-on-stop.sh` | Update timestamp on session end |
| `scripts/commit-milestone.sh` | Commit execution script |
| `scripts/generate-commit-message.sh` | Message generation from metadata |
| `skills/feature-development/references/state-management.md` | State handling guide |
| `skills/feature-development/examples/state-file-template.md` | Template for .local.md |

---

## Files to Modify

### 1. SKILL.md
**Path**: [skills/feature-development/SKILL.md](plugins/feature-dev/skills/feature-development/SKILL.md)

**Changes**:
- Add "State Management" section at beginning (resume detection)
- Add save instructions after each phase
- Add auto-commit step E to Phase 4 per-milestone cycle
- Add auto-commit configuration to Phase 3

### 2. phase-details.md
**Path**: [skills/feature-development/references/phase-details.md](plugins/feature-dev/skills/feature-development/references/phase-details.md)

**Changes**:
- Add state save guidance after each phase section
- Add new "Auto-Commit - Extended Guidance" section

### 3. quick-verifier.md
**Path**: [agents/quick-verifier.md](plugins/feature-dev/agents/quick-verifier.md)

**Changes**:
- Add commit metadata to output format (files_changed, verification_summary, ready_to_commit)

### 4. milestone-templates.md
**Path**: [skills/feature-development/examples/milestone-templates.md](plugins/feature-dev/skills/feature-development/examples/milestone-templates.md)

**Changes**:
- Add `Auto-commit` field to milestone template

### 5. README.md
**Path**: [README.md](plugins/feature-dev/README.md)

**Changes**:
- Document persistent memory feature
- Document auto-commit feature
- Add gitignore recommendations

---

## Implementation Sequence

### Phase A: State Management Infrastructure
1. Create `skills/feature-development/examples/state-file-template.md`
2. Create `skills/feature-development/references/state-management.md`
3. Create `hooks/` directory and `hooks.json`
4. Create `hooks/scripts/save-state-on-stop.sh`

### Phase B: Auto-Commit Infrastructure
5. Create `scripts/` directory
6. Create `scripts/commit-milestone.sh`
7. Create `scripts/generate-commit-message.sh`
8. Create `agents/auto-committer.md`

### Phase C: Workflow Integration
9. Modify `SKILL.md` - add state management section
10. Modify `SKILL.md` - add auto-commit step to Phase 4
11. Modify `phase-details.md` - add extended guidance
12. Modify `quick-verifier.md` - add commit metadata

### Phase D: Templates & Documentation
13. Modify `milestone-templates.md` - add auto-commit field
14. Update `README.md` with new features

---

## Verification Plan

### Test State Persistence
1. Start `/feature-dev` with a feature request
2. Complete Phase 1, verify `.claude/feature-dev.local.md` created
3. Exit session, restart Claude Code
4. Run `/feature-dev` again, verify resume prompt appears
5. Choose resume, verify context restored

### Test Auto-Commit
1. Run through Phase 4 with a milestone
2. After quick-verifier passes, verify commit prompt/execution
3. Check `git log` for conventional commit message
4. Test opt-out by setting `auto_commit: false`

### Test Error Handling
1. Create pre-commit hook that fails on lint
2. Verify auto-fix and retry behavior
3. Test with merge conflict present
4. Verify graceful degradation when git not initialized

---

## Gitignore Additions

```gitignore
# Feature-dev plugin state
.claude/feature-dev.local.md
.claude/feature-dev.local.md.archived-*
```
