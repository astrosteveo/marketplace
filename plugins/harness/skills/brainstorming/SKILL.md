---
name: brainstorming
description: "You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements and design before implementation."
---

# Brainstorming Ideas Into Specs and Designs

## Overview

Help turn ideas into specs (WHAT we're building) and designs (HOW we're building it) through natural collaborative dialogue.

Start by understanding the current project context, then ask questions one at a time to refine the idea. Once requirements are clear, write the spec. Then explore approaches and present the design in small sections, checking after each section whether it looks right so far.

## Prerequisites

**First time in this project?** Check if setup is needed:
```bash
test -d .artifacts && gh repo view >/dev/null 2>&1 && echo "ready" || echo "needs setup"
```

If "needs setup": **REQUIRED SUB-SKILL:** Use harness:project-setup first.

## Project Tracking

**Backlog:** GitHub issues with `enhancement` label
**Active work:** `.artifacts/<feature-slug>/`
**Completed:** `.artifacts/archive/<feature-slug>/`

When starting a feature:
- If working from a GitHub issue, reference it in the spec
- Create `.artifacts/<feature-slug>/` for all artifacts
- After completion, archive moves to `.artifacts/archive/`

## Artifact Structure

**Save to:** `.artifacts/<feature-slug>/`

```
.artifacts/
  <feature-slug>/
    <feature-slug>-spec.md     # WHAT we're building
    <feature-slug>-design.md   # HOW we're building it
    <feature-slug>-plan.md     # Created later by writing-plans
  archive/
    <completed-feature>/       # Archived after completion
```

## The Process

**Phase 1: Understanding the idea**
- Check out the current project state first (files, docs, recent commits)
- Ask questions one at a time to refine the idea
- Prefer multiple choice questions when possible, but open-ended is fine too
- Only one question per message - if a topic needs more exploration, break it into multiple questions
- Focus on understanding: purpose, constraints, success criteria

**Phase 2: Writing the spec**
- Once requirements are clear, write the spec document
- This captures WHAT we're building before exploring HOW
- Get user validation on the spec before proceeding to design

**Phase 3: Exploring approaches**
- Propose 2-3 different approaches with trade-offs
- Present options conversationally with your recommendation and reasoning
- Lead with your recommended option and explain why

**Phase 4: Presenting the design**
- Once approach is agreed, present the design
- Break it into sections of 200-300 words
- Ask after each section whether it looks right so far
- Cover: architecture, components, data flow, error handling, testing
- Be ready to go back and clarify if something doesn't make sense

## Spec Document Template

```markdown
# [Feature Name] Spec

**Goal:** [One sentence describing what this builds]

**Problem:** [What problem does this solve? Why does it matter?]

---

## Requirements

- [Functional requirement 1]
- [Functional requirement 2]
- ...

## Constraints

- [Technical constraint, dependency, or limitation]
- ...

## Acceptance Criteria

- [ ] [Testable criterion 1]
- [ ] [Testable criterion 2]
- ...

## Out of Scope

- [Explicitly excluded feature or capability]
- ...
```

## Design Document Template

```markdown
# [Feature Name] Design

**Spec:** `./<feature-slug>-spec.md`

**Approach:** [2-3 sentences summarizing chosen approach]

---

## Architecture

[High-level architecture description]

## Components

### [Component 1]
[Purpose, responsibilities, interfaces]

### [Component 2]
[Purpose, responsibilities, interfaces]

## Data Flow

[How data moves through the system]

## Error Handling

[Error cases and how they're handled]

## Testing Approach

[How this will be tested - unit, integration, manual]

## Trade-offs

| Decision | Alternative | Why This Choice |
|----------|-------------|-----------------|
| [Choice] | [Other option] | [Reasoning] |
```

## After the Design

**Documentation:**
- Create directory: `.artifacts/<feature-slug>/`
- Write spec: `.artifacts/<feature-slug>/<feature-slug>-spec.md`
- Write design: `.artifacts/<feature-slug>/<feature-slug>-design.md`
- Use elements-of-style:writing-clearly-and-concisely skill if available
- Commit both documents to git

**Implementation (if continuing):**
- Ask: "Ready to set up for implementation?"
- Use harness:using-git-worktrees to create isolated workspace
- Use harness:writing-plans to create detailed implementation plan

## Key Principles

- **One question at a time** - Don't overwhelm with multiple questions
- **Multiple choice preferred** - Easier to answer than open-ended when possible
- **YAGNI ruthlessly** - Remove unnecessary features from all specs and designs
- **Spec before design** - Lock WHAT before exploring HOW
- **Explore alternatives** - Always propose 2-3 approaches before settling
- **Incremental validation** - Present design in sections, validate each
- **Be flexible** - Go back and clarify when something doesn't make sense
