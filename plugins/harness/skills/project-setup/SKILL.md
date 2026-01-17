---
name: project-setup
description: Use when starting work in a new project to ensure GitHub repo, labels, and tracking structure are ready
---

# Project Setup

## Overview

Ensure a project is ready for the harness workflow: GitHub repo exists, labels configured, `.artifacts/` structure in place.

**Announce at start:** "I'm using the project-setup skill to verify this project is ready for development."

## When to Use

- First time using harness in a project
- User says "set up this project" or "initialize tracking"
- Before brainstorming if no `.artifacts/` directory exists

## The Process

### Step 1: Check Git Repository

```bash
git rev-parse --git-dir 2>/dev/null
```

**If not a git repo:**
```bash
git init
git add -A
git commit -m "chore: initial commit"
```

### Step 2: Check GitHub Remote

```bash
gh repo view --json nameWithOwner -q '.nameWithOwner' 2>/dev/null
```

**If no remote or not a GitHub repo:**

Ask user:
```
No GitHub remote found. Options:

1. Create new GitHub repo (I'll use `gh repo create`)
2. Connect to existing repo (provide URL)
3. Skip GitHub setup (issues won't work)

Which option?
```

**Option 1: Create new repo**
```bash
# Get repo name from directory or ask user
gh repo create <name> --source=. --push --public
# or --private based on user preference
```

**Option 2: Connect existing**
```bash
git remote add origin <url>
git push -u origin main
```

**Option 3: Skip**
Note: `gh issue` commands will fail. User acknowledged.

### Step 3: Verify gh Authentication

```bash
gh auth status
```

**If not authenticated:**
```
GitHub CLI not authenticated. Run:

  gh auth login

Then re-run this setup.
```

Stop here until authenticated.

### Step 4: Set Up Labels

Check for enhancement label:
```bash
gh label list --json name -q '.[].name' | grep -q "enhancement" && echo "exists" || echo "missing"
```

**Create standard labels if missing:**
```bash
gh label create enhancement --description "New feature or improvement" --color "a2eeef" 2>/dev/null || true
gh label create bug --description "Something isn't working" --color "d73a4a" 2>/dev/null || true
gh label create documentation --description "Improvements or additions to docs" --color "0075ca" 2>/dev/null || true
```

**For monorepo projects, ask:**
```
Is this a monorepo with multiple components?

If yes, what label should scope issues to this component?
(e.g., "harness", "frontend", "api")
```

Create component label if provided:
```bash
gh label create <component> --description "<Component> related" --color "5319E7"
```

### Step 5: Create Artifacts Structure

```bash
mkdir -p .artifacts/archive
```

**If .gitignore exists, check it doesn't ignore .artifacts:**
```bash
grep -q "^\.artifacts" .gitignore && echo "WARNING: .artifacts may be gitignored"
```

### Step 6: Verify Setup

Run verification:
```bash
echo "=== Project Setup Verification ==="
echo "Git repo: $(git rev-parse --git-dir 2>/dev/null && echo 'OK' || echo 'MISSING')"
echo "GitHub remote: $(gh repo view --json nameWithOwner -q '.nameWithOwner' 2>/dev/null || echo 'MISSING')"
echo "gh auth: $(gh auth status 2>&1 | grep -q 'Logged in' && echo 'OK' || echo 'MISSING')"
echo "enhancement label: $(gh label list --json name -q '.[].name' | grep -q enhancement && echo 'OK' || echo 'MISSING')"
echo ".artifacts dir: $(test -d .artifacts && echo 'OK' || echo 'MISSING')"
```

**Report to user:**
```
Project setup complete:

- Repository: <owner>/<repo>
- Labels: enhancement, bug, documentation [, <component>]
- Artifacts: .artifacts/ ready

You can now use brainstorming to start features.
Issues will be tracked at: https://github.com/<owner>/<repo>/issues
```

## Quick Reference

| Check | Command | Fix |
|-------|---------|-----|
| Git repo | `git rev-parse --git-dir` | `git init` |
| GitHub remote | `gh repo view` | `gh repo create` |
| Auth | `gh auth status` | `gh auth login` |
| Labels | `gh label list` | `gh label create` |
| Artifacts | `test -d .artifacts` | `mkdir -p .artifacts/archive` |

## Common Issues

**"gh: command not found"**
→ Install GitHub CLI: https://cli.github.com/

**"gh auth login" fails**
→ Need GitHub account and permissions

**Labels already exist with different colors**
→ That's fine, `gh label create` will skip them

**Private vs public repo**
→ Ask user preference, default to private for safety

## Integration

**Called before:**
- **brainstorming** - If no .artifacts/ exists, suggest running project-setup first

**Enables:**
- `gh issue create` in all skills
- `.artifacts/<slug>/` workflow
- Issue-based backlog tracking
