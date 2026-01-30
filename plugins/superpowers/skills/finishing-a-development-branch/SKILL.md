---
name: finishing-a-development-branch
description: Use when implementation is complete, all tests pass, and you need to decide how to integrate the work - guides completion of development work by presenting structured options for merge, PR, or cleanup
---

# Finishing a Development Branch

## Overview

Guide completion of feature branch work by presenting clear options for integrating back to main.

**Core principle:** Verify tests → Manual testing → Update docs → Present options → Execute choice → Clean up.

**Announce at start:** "I'm using the finishing-a-development-branch skill to complete this work."

**Expected state:** On a feature branch (`{type}/{slug}`) with all work committed and tests passing.

## The Process

### Step 1: Verify Tests

**Before presenting options, verify tests pass:**

```bash
# Run project's test suite
npm test / cargo test / pytest / go test ./...
```

**If tests fail:**
```
Tests failing (<N> failures). Must fix before completing:

[Show failures]

Cannot proceed with merge/PR until tests pass.
```

Stop. Don't proceed to Step 2.

**If tests pass:** Continue to Step 2.

### Step 2: Manual Testing (If Applicable)

**For features with user-facing changes, provide manual testing steps:**

```
## Manual Testing Steps

Before completing, please verify:

1. [Step to test feature A]
2. [Step to test feature B]
3. [Expected behavior to confirm]

Do you want to run through these manually, or proceed to documentation?
```

**Skip this step if:**
- The change is purely internal/backend with no user-facing impact
- The change is a refactor with no behavior change
- Test coverage adequately verifies all behavior

### Step 3: Update Documentation

**Update relevant documentation based on what was built:**

#### CLAUDE.md
- Add any new project-specific conventions discovered
- Document new commands, testing approaches, or build steps
- Update file structure if it changed significantly

#### GDD.md and/or PRD.md
- Check which document(s) exist - some projects have both (e.g., game + engine)
- Update milestone status for completed features in the relevant document(s)
- Add any "Future Ideas" discovered during implementation
- Mark completed features in the milestone table

#### TDD Artifacts
- Ensure test documentation reflects new test patterns
- Update any testing instructions in docs/

**Ask:** "I've identified these documentation updates. Should I apply them?"

Present specific updates you'll make, then apply after confirmation.

### Step 4: Capture Any Remaining Out-of-Scope Ideas

Before finishing, ask: "Did you notice any features or improvements that were out of scope but worth capturing?"

If yes:
- Add them to the appropriate document's "Future Ideas" section:
  - Game-related ideas → `docs/GDD.md`
  - Tool/infrastructure ideas → `docs/PRD.md`
  - If only one exists, use that one
- These are good ideas that didn't make the pragmatic cut for this feature

### Step 5: Determine Base Branch

```bash
# Try common base branches
git merge-base HEAD main 2>/dev/null || git merge-base HEAD master 2>/dev/null
```

Or ask: "This branch split from main - is that correct?"

### Step 6: Present Options

Present exactly these 4 options:

```
Implementation complete on <branch-name>. What would you like to do?

1. Push and create a Pull Request (Recommended)
2. Merge back to <base-branch>
3. Keep the branch as-is (I'll handle it later)
4. Discard this work

Which option?
```

**Don't add explanation** - keep options concise.

### Step 7: Execute Choice

#### Option 1: Push and Create PR (Recommended)

```bash
# Push branch
git push -u origin <feature-branch>

# Create PR
gh pr create --title "<title>" --body "$(cat <<'EOF'
## Summary
<2-3 bullets of what changed>

## Test Plan
- [ ] Automated tests pass
- [ ] <manual verification steps if applicable>

## Documentation
- [ ] CLAUDE.md updated (if applicable)
- [ ] GDD.md/PRD.md milestone updated

🤖 Generated with [Claude Code](https://claude.com/claude-code)
EOF
)"
```

Then: Cleanup worktree (Step 8)

#### Option 2: Merge Locally

```bash
# Switch to base branch
git checkout <base-branch>

# Pull latest
git pull

# Merge feature branch
git merge <feature-branch>

# Verify tests on merged result
<test command>

# If tests pass
git branch -d <feature-branch>
```

Then: Cleanup worktree (Step 8)

#### Option 3: Keep As-Is

Report: "Keeping branch <name>. Worktree preserved at <path>."

**Don't cleanup worktree.**

#### Option 4: Discard

**Confirm first:**
```
This will permanently delete:
- Branch <name>
- All commits: <commit-list>
- Worktree at <path>

Type 'discard' to confirm.
```

Wait for exact confirmation.

If confirmed:
```bash
git checkout <base-branch>
git branch -D <feature-branch>
```

Then: Cleanup worktree (Step 8)

### Step 8: Cleanup Worktree

**For Options 1, 2, 4:**

Check if in worktree:
```bash
git worktree list | grep $(git branch --show-current)
```

If yes:
```bash
git worktree remove <worktree-path>
```

**For Option 3:** Keep worktree.

## Quick Reference

| Option | Push | Merge | Keep Worktree | Cleanup Branch |
|--------|------|-------|---------------|----------------|
| 1. Create PR (Recommended) | ✓ | - | ✓ | - |
| 2. Merge locally | - | ✓ | - | ✓ |
| 3. Keep as-is | - | - | ✓ | - |
| 4. Discard | - | - | - | ✓ (force) |

## Common Mistakes

**Skipping test verification**
- **Problem:** Merge broken code, create failing PR
- **Fix:** Always verify tests before offering options

**Skipping documentation updates**
- **Problem:** CLAUDE.md and GDD/PRD become stale
- **Fix:** Always check for doc updates before presenting options

**Open-ended questions**
- **Problem:** "What should I do next?" → ambiguous
- **Fix:** Present exactly 4 structured options

**Automatic worktree cleanup**
- **Problem:** Remove worktree when might need it (Option 3)
- **Fix:** Only cleanup for Options 1, 2, and 4

**No confirmation for discard**
- **Problem:** Accidentally delete work
- **Fix:** Require typed "discard" confirmation

## Red Flags

**Never:**
- Proceed with failing tests
- Merge without verifying tests on result
- Delete work without confirmation
- Force-push without explicit request
- Skip documentation updates

**Always:**
- Verify tests before offering options
- Offer manual testing steps for user-facing changes
- Update CLAUDE.md and GDD/PRD
- Present exactly 4 options (PR recommended)
- Get typed confirmation for Option 4
- Clean up worktree for Options 1, 2 & 4 only

## Integration

**Called by:**
- **subagent-driven-development** (Step 7) - After all tasks complete
- **executing-plans** (Step 5) - After all tasks complete

**Pairs with:**
- **using-git-worktrees** - Cleans up worktree created by that skill
