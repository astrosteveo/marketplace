# Superpowers Release Notes

## v0.1.0 (2026-01-29)

Initial release.

### Features

**Project vision documents with milestones**

Projects have a north star document that grounds all feature work:
- `docs/GDD.md` - Game Design Document (for games)
- `docs/PRD.md` - Product Requirements Document (for products/apps)

Features are organized into **milestones** - logical phases that group related work:
- Milestone 1 might be "Core Loop" or "MVP"
- Each milestone has a goal and a feature table with status tracking
- Unscheduled ideas go in "Future Ideas" section

Templates available at `templates/GDD.md` and `templates/PRD.md`.

When brainstorming features, the skill:
- Reads the vision doc first
- Identifies which milestone the feature belongs to
- References the project vision throughout the discussion

**Out-of-scope idea capture**

During implementation, you'll discover logical next steps that aren't in scope. Instead of losing them or derailing current work:
- `executing-plans` captures ideas as they surface
- `finishing-a-development-branch` prompts for any remaining ideas
- Ideas go to "Future Ideas" section in GDD/PRD

These are good features that didn't make the pragmatic cut — captured for later.

**Feature branch workflow**

All work happens on feature branches using the `{type}/{slug}` naming convention:
- `feature/auth-system` - New functionality
- `fix/login-bug` - Bug fixes
- `refactor/api-cleanup` - Code restructuring

The branch slug matches the plan directory (e.g., `feature/auth-system` → `docs/plans/auth-system/plan.md`).

When work is complete, `finishing-a-development-branch` offers to merge back to main.

**Directory-based plan organization**

Plan files are stored in feature-specific subdirectories:
- `docs/plans/{slug}/plan.md` - Implementation plans
- `docs/plans/{slug}/design.md` - Design documents

Benefits:
- Related files (design, plan, notes) are grouped together
- Branch name and plan directory stay in sync
- Cleaner directory structure for large projects
