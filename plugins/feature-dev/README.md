# Feature Development Plugin

A pragmatic workflow for feature development with specialized agents for codebase exploration, architecture design, and quality review.

## Overview

The Feature Development Plugin guides you through building features with just enough structure to do it well, without over-planning. It helps you understand the codebase, brainstorm approaches, design one good solution, then build iteratively.

## Philosophy

**Pragmatic over perfect.** This plugin:
- **Brainstorms with you** - shares ideas early, gets your input
- **Asks only critical questions** - doesn't interrogate about every edge case
- **Designs one good approach** - doesn't present menus of options
- **Builds and adjusts** - ships working code, then iterates
- **Reviews what matters** - catches real bugs, skips nitpicks

The goal is momentum: understand enough → design something solid → build it → ship it.

## Command: `/feature-dev`

Launches a guided feature development workflow with 7 distinct phases.

**Usage:**
```bash
/feature-dev Add user authentication with OAuth
```

Or simply:
```bash
/feature-dev
```

The command will guide you through the entire process interactively.

## The Workflow

### Phase 1: Discovery & Brainstorm

**Goal**: Understand the feature and brainstorm ideas together

**What happens:**
- Shares initial take on what the feature involves
- Brainstorms approaches with you ("Here's what I'm thinking...")
- Asks about hard constraints (if any)
- Agrees on direction quickly

**Example:**
```
You: /feature-dev Add caching
Claude: Caching - got it. Looking at your codebase, you're using Redis elsewhere,
        so I'm thinking we add a cache layer to your API service using the same
        Redis setup. We could cache at the route level or the service level -
        I'd lean toward service level since that's where your data fetching happens.
        What do you think? Any specific endpoints you're most concerned about?
```

### Phase 2: Codebase Exploration

**Goal**: Understand relevant existing code and patterns

**What happens:**
- Launches `code-explorer` agents to analyze relevant parts of codebase
- Discovers testing patterns and conventions
- Reads key files to build understanding
- Presents summary of findings

**Example output:**
```
Found similar features:
- User authentication (src/auth/): JWT tokens, middleware pattern
- Session management (src/session/): Redis-backed

Testing: Jest with ts-jest, tests in __tests__/ directories
```

### Phase 3: Quick Clarifications

**Goal**: Resolve critical blockers (not every edge case)

**What happens:**
- Identifies only critical unknowns that affect architecture
- Asks 2-4 questions max
- Makes reasonable assumptions for non-critical decisions

**Example:**
```
A few quick questions before I design this:

1. Which OAuth providers do you need? (Google, GitHub, both?)
2. Should we use the existing session management or separate?

I'll assume unit tests only (no integration tests) unless you want otherwise.
```

### Phase 4: Architecture Design

**Goal**: Design ONE good approach with milestones

**What happens:**
- Launches `code-architect` agent focused on pragmatic approach
- Designs solution that fits existing patterns
- Breaks down into clear milestones
- Quick brainstorm: "Does this make sense? Any concerns?"

**Example output:**
```
Here's the approach:

Components:
- OAuthService: Handles OAuth flow (follows existing AuthService pattern)
- OAuthProvider: Provider abstraction for Google/GitHub
- AuthMiddleware: Hook into existing middleware chain

Milestones:
1. OAuthProvider interface + Google implementation
2. OAuthService with token handling
3. AuthMiddleware integration
4. Tests

This follows your existing auth patterns. Sound good?
```

### Phase 4.5: Impact Analysis (When Needed)

**Goal**: Understand blast radius for risky changes

Triggers when touching auth, payments, APIs, or many existing files.

**What happens:**
- Launches `impact-analyzer` agent
- Shows what depends on modified code
- Assesses risk
- Gets acknowledgment before proceeding

### Phase 5: Implementation

**Goal**: Build in milestones with verification

**What happens:**
- Implements each milestone
- Runs `quick-verifier` after each (type check, lint, tests)
- Fixes issues before moving on
- No ceremony - just build, verify, continue

**Example flow:**
```
Milestone 2/4: OAuthProvider abstraction

✓ Created src/auth/OAuthProvider.ts
✓ Created src/auth/providers/GoogleProvider.ts
✓ Verification: types pass, lint pass, tests pass

Moving to Milestone 3...
```

### Phase 6: Quality Review

**Goal**: Catch real issues, skip nitpicks

**What happens:**
1. Runs relevant tests
2. Launches `code-reviewer` (with security/performance focus if needed)
3. Fixes critical issues
4. Notes minor issues without blocking

**Example output:**
```
Tests: 47 passing

Review findings:
- Missing error handling in OAuth callback (src/auth/oauth.ts:67) - fixing now

No other critical issues. Minor: could simplify token refresh logic later.
```

### Phase 7: Wrap Up

**Goal**: Summarize and suggest next steps

**What happens:**
- Brief summary of what was built
- Files modified/created
- Suggests documentation updates (only if clearly needed)
- Mentions follow-up ideas

**Example:**
```
Done! Built OAuth authentication with Google and GitHub support.

Files: src/auth/OAuthProvider.ts (new), src/auth/AuthService.ts (modified),
       src/routes/auth.ts (modified), __tests__/auth/*.test.ts (new)

Tests passing. You'll want to add OAuth setup instructions to your README.

Follow-up ideas: Add Microsoft/Apple providers, set up prod credentials.
```

## Agents

### `code-explorer`
Analyzes existing codebase features by tracing execution paths. Finds patterns, architecture layers, and dependencies. Used in Phase 2.

### `code-architect`
Designs ONE good architecture with milestones and test strategy. Follows existing patterns. Used in Phase 4.

### `code-reviewer`
Reviews code for real bugs and quality issues. Confidence-filtered to skip nitpicks. Can focus on security or performance when needed. Used in Phase 6.

### `code-tester`
Discovers test patterns, plans tests, runs verification. Used in Phase 2 (discovery) and Phase 6 (quality review).

### `quick-verifier`
Fast verification: type check, lint, targeted tests. Runs after each milestone. Uses Haiku for speed.

### `impact-analyzer`
Analyzes blast radius of risky changes. Shows dependencies and breaking change risk. Used conditionally in Phase 4.5.

## Default Behavior

The plugin defaults to **lightweight mode**: verify each milestone (types, lint, tests), checkpoint only at the end. This keeps momentum while catching issues early.

If you want more oversight (mini-reviews at each step, user checkpoints), just ask.

## Usage

```bash
/feature-dev Add rate limiting to API endpoints
```

The workflow guides you through discovery → exploration → design → implementation → review.

You can also invoke agents directly:
- "Launch code-explorer to trace how authentication works"
- "Launch code-architect to design the caching layer"
- "Launch code-reviewer to check my changes"

## Tips

1. **Share your ideas early** - The plugin brainstorms with you, so speak up
2. **Don't over-answer questions** - Brief answers are fine; "whatever you think" is okay
3. **Trust the defaults** - Lightweight mode works for most features
4. **Course-correct during implementation** - If something doesn't feel right, say so

## When to Use

**Use for:** Features that need some thought - multiple files, architectural decisions, integrations.

**Don't use for:** Bug fixes, trivial changes, hotfixes. Just do those directly.

## Requirements

- Claude Code installed
- Git repository
- Existing codebase (the workflow learns from existing patterns)

## Troubleshooting

**Agents slow?** Normal for large codebases. They're thorough.

**Can't find test runner?** Make sure test config exists (jest.config.js, etc.).

**Too many questions?** Say "whatever you think" or be more specific upfront.

## Author

Sid Bidasaria (sbidasaria@anthropic.com)

## Version

2.1.0 - Pragmatic edition
