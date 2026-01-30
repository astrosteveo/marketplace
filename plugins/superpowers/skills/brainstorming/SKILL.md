---
name: brainstorming
description: "You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements and design before implementation."
---

# Brainstorming Ideas Into Designs

## Overview

Help turn ideas into fully formed designs and specs through natural collaborative dialogue.

Start by understanding the current project context, then ask questions one at a time to refine the idea. Once you understand what you're building, present the design in small sections (200-300 words), checking after each section whether it looks right so far.

## The Process

**Ground in project vision (required):**
- Check for `docs/GDD.md` and/or `docs/PRD.md`
- If found, read them first to understand the project's north star
- Identify which milestone this feature belongs to
- Reference the vision when discussing how this feature fits
- **If no vision doc exists, determine what's needed:**

  **Which document(s) does this project need?**

  | Project Type | Documents | Examples |
  |--------------|-----------|----------|
  | Pure game | GDD.md only | Platformer, puzzle game, visual novel |
  | App/service/tool | PRD.md only | SaaS, CLI tool, API, library |
  | Game + complex app logic | Both GDD.md + PRD.md | Game + custom engine, game + backend service, game + level editor tool |

  **Decision flow:**
  1. Is there a game with creative vision, player experience, art/audio direction? → Needs GDD.md
  2. Is there a product/tool/service with technical requirements, user personas, success metrics? → Needs PRD.md
  3. Both apply? → Create both, with GDD.md focused on the game experience and PRD.md focused on the tooling/infrastructure

  **When both are needed:**
  - GDD.md: Game vision, core loop, player experience, art/audio direction, gameplay milestones
  - PRD.md: Engine/tool vision, technical architecture, API design, tooling milestones
  - Cross-reference between them where they interact

  **Create the document(s):**
  1. Ask which type(s) apply, with your recommendation based on context
  2. Create `docs/GDD.md` and/or `docs/PRD.md` using templates from `templates/`
  3. Fill in Vision and Core sections collaboratively before proceeding to feature design

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

**Implementation (if continuing):**
- Ask: "Ready to set up for implementation?"
- Ask if they want a separate worktree (use superpowers:using-git-worktrees) or to proceed in the current worktree
- Use superpowers:writing-plans to create detailed implementation plan

## Key Principles

- **One question at a time** - Don't overwhelm with multiple questions
- **Multiple choice preferred** - Easier to answer than open-ended when possible
- **YAGNI ruthlessly** - Remove unnecessary features from all designs
- **Explore alternatives** - Always propose 2-3 approaches before settling
- **Incremental validation** - Present design in sections, validate each
- **Be flexible** - Go back and clarify when something doesn't make sense
