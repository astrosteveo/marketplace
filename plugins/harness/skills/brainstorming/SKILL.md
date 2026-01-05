---
name: brainstorming
description: Use when starting any creative work - building features, adding components, modifying behavior, or before implementation of new functionality. Required before writing code for unclear requirements or when user provides high-level idea without detailed specifications.
---

# Brainstorming Ideas Into Designs

## Overview

Help turn ideas into fully formed designs and specs through natural collaborative dialogue.

Start by understanding the current project context, then ask questions one at a time to refine the idea. Once you understand what you're building, present the design in small sections (200-300 words), checking after each section whether it looks right so far.

## The Process

**Understanding the idea:**
- Check out the current project state first (files, docs, recent commits)
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

1. **Determine feature name:**
   - Extract topic from conversation (e.g., "OAuth service" → `oauth-service`)
   - Check for existing `.artifacts/` directories
   - If found: Ask "This seems related to [existing-feature]. Use that directory or create new?"
   - If new: Confirm derived name: "I'll save to `.artifacts/<derived-name>/`. Okay?"
   - Allow user to specify different name if needed

2. **Save design:**
   - Create `.artifacts/<feature-name>/` directory if needed
   - Write design to `.artifacts/<feature-name>/YYYY-MM-DD-design.md`
   - Use elements-of-style:writing-clearly-and-concisely skill if available

3. **Commit:**
   - Commit the design document to git
   - Include feature name in commit message: `docs: add <feature-name> design`

**Implementation (if continuing):**
- Ask: "Ready to set up for implementation?"
- Use `/using-git-worktrees` to create isolated workspace
- Use harness:writing-plans to create detailed implementation plan

## Key Principles

- **Use the `AskUserQuestion` tool** - ALWAYS use it to ask questions instead of just plain messages
- **One question at a time** - Don't overwhelm with multiple questions
- **Multiple choice preferred** - Easier to answer than open-ended when possible
- **YAGNI ruthlessly** - Remove unnecessary features from all designs
- **Explore alternatives** - Always propose 2-3 approaches before settling
- **Incremental validation** - Present design in sections, validate each
- **Be flexible** - Go back and clarify when something doesn't make sense
