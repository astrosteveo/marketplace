---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** This should be run in a dedicated worktree (created by brainstorming skill).

**Save plans to:** `.artifacts/plans/YYYY-MM-DD-<feature-name>.md`

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use harness:executing-plans to implement this plan task-by-task.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## Task Structure

```markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

**Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

**Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

**Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

**Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
```

## Remember
- Exact file paths always
- Complete code in plan (not "add validation")
- Exact commands with expected output
- Reference relevant skills with @ syntax
- DRY, YAGNI, TDD, frequent commits

## Manual Test Checklist Section

Every plan ends with a Manual Test Checklist. This goes after all tasks, before any closing notes.

**Template:**

```markdown
---

## Manual Test Checklist

> **For Claude:** Present this checklist at appropriate checkpoints.
> - subagent-driven-development: after all tasks, before finishing-a-development-branch
> - executing-plans: relevant items after each batch

### [Component/Area Name]
<!-- Tasks N-M -->

- [ ] [Concrete action] → [Expected result]
```

**Format:** `- [ ] [Action] → [Expected result]`

**What to include:**
- User-facing behavior automated tests don't fully cover
- Visual/UI verification (layout, styling, responsiveness)
- Integration points (API calls, database state, external services)
- Error states and edge cases worth human verification

**What NOT to include:**
- Things fully covered by automated tests
- Internal implementation details user can't observe
- Vague items ("make sure it works")

**Task mapping:** Add `<!-- Tasks N-M -->` comment after each group heading so executing-plans can identify relevant items per batch.

**Example:**

```markdown
## Manual Test Checklist

### Authentication
<!-- Tasks 1-3 -->

- [ ] Login with valid credentials → Redirects to /dashboard, shows username
- [ ] Login with wrong password → Shows "Invalid credentials" error
- [ ] Click "Logout" → Returns to /login, clears session

### Dashboard
<!-- Tasks 4-5 -->

- [ ] Load with no data → Shows empty state message
- [ ] Create item → Appears in list without refresh
```

## Execution Handoff

After saving the plan, offer execution choice:

**"Plan complete and saved to `.artifacts/plans/<filename>.md`. Two execution options:**

**1. Subagent-Driven (this session)** - I dispatch fresh subagent per task, review between tasks, fast iteration

**2. Parallel Session (separate)** - Open new session with executing-plans, batch execution with checkpoints

**Which approach?"**

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use harness:subagent-driven-development
- Stay in this session
- Fresh subagent per task + code review

**If Parallel Session chosen:**
- Guide them to open new session in worktree
- **REQUIRED SUB-SKILL:** New session uses harness:executing-plans
