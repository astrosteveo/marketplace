---
name: brainstorming
description: "You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements and design before implementation."
---

# Brainstorming Ideas Into Designs

## Overview

Help turn ideas into fully formed designs and specs through natural collaborative dialogue.

Start by understanding the current project context, then ask questions one at a time to refine the idea. Once you understand what you're building, present the design in small sections (200-300 words), checking after each section whether it looks right so far.

## The Process

**Ground in project vision (REQUIRED - NO EXCEPTIONS):**

**You CANNOT design features without a vision doc. This is not optional.**

1. Check for `docs/GDD.md` and/or `docs/PRD.md`
2. If found: read them, identify which milestone this feature belongs to
3. **If NOT found: STOP. Create the vision doc BEFORE any feature discussion.**

**Creating vision docs (when missing):**

| Project Type | Document | Examples |
|--------------|----------|----------|
| Pure game | GDD.md | Platformer, puzzle game |
| App/service/tool | PRD.md | SaaS, CLI, API, library |
| Both | GDD.md + PRD.md | Game + backend, game + editor |

**Process:**
1. Determine which doc(s) needed (recommend based on context)
2. **Immediately create** `docs/GDD.md` and/or `docs/PRD.md` using templates from `templates/`
3. Fill in Vision and Core sections collaboratively
4. Commit the vision doc(s)
5. **Only then** proceed to feature design

**Red flags - you're skipping vision docs:**
- "Let's just design the feature first"
- "We can create the PRD later"
- "The feature is simple, we don't need a vision doc"
- Discussing feature architecture before vision doc exists

All of these mean: STOP. Create vision doc first.

**Understanding the idea:**
- Check out the current project state (files, docs, recent commits)
- Ask questions one at a time to refine the idea
- Prefer multiple choice questions when possible, but open-ended is fine too
- Only one question per message - if a topic needs more exploration, break it into multiple questions
- Focus on understanding: purpose, constraints, success criteria

**Exploring approaches:**
- Propose 2-3 different approaches with trade-offs
- Present options conversationally with your recommendation and reasoning
- Lead with your recommended option and explain why

**Presenting the design:**
- Once you believe you understand what you're building, present the design
- Break it into sections of 200-300 words
- Ask after each section whether it looks right so far
- Cover: architecture, components, data flow, error handling, testing
- Be ready to go back and clarify if something doesn't make sense

## After the Design

**Documentation:**
- Write the validated design to `docs/plans/{slug}/design.md`
- Use elements-of-style:writing-clearly-and-concisely skill if available
- Commit the design document to git

**Next steps (present these exact options):**

After committing the design, ask: "Ready to set up for implementation?" Then present:

| Option | What it means | When to use |
|--------|---------------|-------------|
| **A) Continue now, same worktree** | Create feature branch here, write implementation plan, start executing | Ready to implement immediately |
| **B) Continue now, new worktree** | Use superpowers:using-git-worktrees, then write plan and execute | Want isolation from main workspace |
| **C) New session, same worktree** | Stop here. User will start fresh session and say "implement [feature]" | Need a break, want fresh context |
| **D) Stop here** | Design is done, come back whenever | Not ready to implement yet |

**Interpreting responses:**
- If user says just a letter (A/B/C/D), use that option
- If user clarifies an option (e.g., "B should be new session"), they're CORRECTING your options - update your understanding
- If unclear, ask for clarification - don't guess

**For option A (same worktree):**
1. Create feature branch: `git checkout -b feature/{slug}` (e.g., `feature/phase-4-pawn`)
2. Use superpowers:writing-plans to create implementation plan
3. Use superpowers:executing-plans to begin implementation

**For option B (new worktree):**
1. Use superpowers:using-git-worktrees (it creates the feature branch automatically)
2. Use superpowers:writing-plans to create implementation plan
3. Use superpowers:executing-plans to begin implementation

## Key Principles

- **One question at a time** - Don't overwhelm with multiple questions
- **Multiple choice preferred** - Easier to answer than open-ended when possible
- **YAGNI ruthlessly** - Remove unnecessary features from all designs
- **Explore alternatives** - Always propose 2-3 approaches before settling
- **Incremental validation** - Present design in sections, validate each
- **Be flexible** - Go back and clarify when something doesn't make sense
