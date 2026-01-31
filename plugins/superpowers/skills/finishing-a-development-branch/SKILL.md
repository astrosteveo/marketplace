---
name: finishing-a-development-branch
description: Use when implementation is complete, all tests pass, and you need to integrate the work - validates, updates docs, and creates PR
---

# Finishing a Development Branch

## Overview

Guide completion of development work through validation, documentation, and PR creation.

**Core principle:** Verify branch → Run tests → Manual validation → Update docs → Final commit → Create PR.

**Announce at start:** "I'm using the finishing-a-development-branch skill to complete this work."

## The Process

### Step 1: Verify Feature Branch

```bash
git branch --show-current
```

**If on main/master:** Stop. "You're on `<branch>`. This skill is for finishing feature branches. Create a feature branch first."

**If on feature branch:** Continue.

### Step 2: Run Tests

```bash
# Run project's test suite
npm test / cargo test / pytest / go test ./...
```

**If tests fail:** Stop. Fix failures before proceeding.

**If tests pass:** Continue.

### Step 3: Manual Validation

Ask the user to validate:

```
Tests pass. Please verify the feature works as expected:

1. [Specific thing to check based on implementation]
2. [Another specific thing to check]
3. [Edge case or integration point to verify]

Try these out and let me know if everything looks good, or if you find any issues.
```

**If issues found:** Fix them, re-run tests, ask again.

**If validated:** Continue.

### Step 4: Update Documentation

Review and update relevant docs based on what changed:

**CLAUDE.md** - Add any new patterns, conventions, or learnings discovered during implementation.

**PRD.md / GDD.md** - Update feature status in milestone tables. Capture any out-of-scope ideas discovered in "Future Ideas" section.

**README.md** - Update if the feature affects usage, setup, or public API.

Only update docs that are relevant to the changes. Skip if nothing meaningful to add.

### Step 5: Final Commit

If docs were updated:

```bash
git add -A
git commit -m "docs: update documentation for <feature>"
```

### Step 6: Present Options

```
Ready to create PR. Which workflow?

1. Create PR for review (push, create PR, wait for review)
2. Create PR and merge immediately (push, create PR, merge, cleanup)
3. Merge locally to main (skip PR - for trivial one-offs only)
4. Keep the branch as-is (I'll handle it later)
5. Discard this work

Which option?
```

**Note:** Options 1-2 are the standard workflow. Option 3 bypasses PR history - only use for trivial changes that don't need release note visibility.

### Step 7: Execute Choice

#### Option 1: Create PR for Review

```bash
git push -u origin <feature-branch>

gh pr create --title "<concise title>" --body "$(cat <<'EOF'
## Summary
<2-3 bullets of what changed>

## Test Plan
- [ ] <verification steps>
EOF
)"
```

Report PR URL. Done.

**Note:** After PR is merged externally, run cleanup manually:
```bash
git checkout <base-branch> && git pull
git branch -d <feature-branch>
mkdir -p docs/plans/_archived && mv docs/plans/<slug> docs/plans/_archived/
git add docs/plans/ && git commit -m "chore: archive <slug> plan"
```

#### Option 2: Create PR and Merge Immediately

```bash
# Push and create PR
git push -u origin <feature-branch>

gh pr create --title "<concise title>" --body "$(cat <<'EOF'
## Summary
<2-3 bullets of what changed>

## Test Plan
- [x] Tests passing
- [x] Manual validation complete
EOF
)"

# Merge via GitHub (keeps PR history for release notes)
gh pr merge --squash --delete-branch

# Sync local
git checkout <base-branch>
git pull

# Archive the plan
mkdir -p docs/plans/_archived
mv docs/plans/<slug> docs/plans/_archived/
git add docs/plans/
git commit -m "chore: archive <slug> plan"
git push
```

Report: "PR merged and plan archived."

#### Option 3: Merge Locally (Skip PR)

**For trivial one-offs only.** This bypasses PR history and won't appear in auto-generated release notes.

```bash
git checkout <base-branch>
git pull
git merge <feature-branch>

# Verify tests on merged result
<test command>

# If tests pass
git branch -d <feature-branch>
git push

# Archive the plan
mkdir -p docs/plans/_archived
mv docs/plans/<slug> docs/plans/_archived/
git add docs/plans/
git commit -m "chore: archive <slug> plan"
git push
```

#### Option 4: Keep As-Is

Report: "Keeping branch `<name>` for later."

#### Option 5: Discard

**Confirm first:**
```
This will permanently delete:
- Branch <name>
- All commits: <commit-list>

Type 'discard' to confirm.
```

If confirmed:
```bash
git checkout <base-branch>
git branch -D <feature-branch>
```

## Quick Reference

| Option | Push | PR | Merge | Cleanup | Archive Plan |
|--------|------|-----|-------|---------|--------------|
| 1. PR for review | ✓ | ✓ | wait | manual | manual |
| 2. PR and merge | ✓ | ✓ | ✓ | ✓ | ✓ |
| 3. Merge locally | ✓ | - | ✓ | ✓ | ✓ |
| 4. Keep as-is | - | - | - | - | - |
| 5. Discard | - | - | - | ✓ (force) | - |

Options 1-2 are the proper workflow (PRs for release notes). Option 3 is for trivial one-offs only.

## Red Flags

**Never:**
- Run this skill on main/master
- Proceed with failing tests
- Skip manual validation
- Create PR without running tests
- Delete work without typed confirmation

**Always:**
- Verify feature branch first
- Run tests before validation
- Give specific validation steps
- Update relevant docs before PR
- Use `gh pr merge` to keep PR history for release notes

## Integration

**Called by:**
- subagent-driven-development (final step)
- executing-plans (final step)
