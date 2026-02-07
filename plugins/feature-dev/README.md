# Feature Development Plugin

A comprehensive, structured workflow for feature development with specialized agents for codebase exploration, architecture design, testing, and quality review.

## Overview

The Feature Development Plugin provides a systematic 7-phase approach to building new features. Instead of jumping straight into code, it guides you through understanding the codebase, asking clarifying questions, designing architecture with test strategies, implementing incrementally with verification, and ensuring quality—resulting in better-designed, well-tested features that integrate seamlessly with your existing code.

## Philosophy

Building features requires more than just writing code. You need to:
- **Understand the codebase** before making changes
- **Ask questions** to clarify ambiguous requirements
- **Design thoughtfully** with test strategies before implementing
- **Implement incrementally** with verification at each milestone
- **Review for quality** after building

This plugin embeds these practices into a structured workflow that runs automatically when you use the `/feature-dev` command.

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

## The 7-Phase Workflow

### Phase 1: Discovery

**Goal**: Understand what needs to be built

**What happens:**
- Clarifies the feature request if it's unclear
- Asks what problem you're solving
- Identifies constraints and requirements
- Summarizes understanding and confirms with you

**Example:**
```
You: /feature-dev Add caching
Claude: Let me understand what you need...
        - What should be cached? (API responses, computed values, etc.)
        - What are your performance requirements?
        - Do you have a preferred caching solution?
```

### Phase 2: Codebase Exploration

**Goal**: Understand relevant existing code, patterns, and testing approach

**What happens:**
- Launches 2-3 `code-explorer` agents in parallel
- **NEW**: Launches 1 `code-tester` agent for test pattern discovery
- Agents return comprehensive analyses with key files to read
- Claude reads all identified files to build deep understanding
- Presents comprehensive summary of findings **including testing conventions**

**Agents launched:**
- "Find features similar to [feature] and trace implementation"
- "Map the architecture and abstractions for [area]"
- "Discover testing patterns, frameworks, and conventions"

**Example output:**
```
Found similar features:
- User authentication (src/auth/): Uses JWT tokens, middleware pattern
- Session management (src/session/): Redis-backed, 24hr expiry

Testing approach discovered:
- Framework: Jest with ts-jest
- Location: __tests__/ directories alongside source
- Patterns: AAA pattern, mock factories in __mocks__/
- Coverage threshold: 80%
```

### Phase 3: Clarifying Questions

**Goal**: Fill in gaps and resolve all ambiguities

**What happens:**
- Reviews codebase findings and feature request
- Identifies underspecified aspects:
  - Edge cases, error handling, integration points
  - Backward compatibility, performance needs
  - **Testing requirements and preferences**
- Presents all questions in an organized list
- **Waits for your answers before proceeding**

**Example:**
```
Before designing the architecture, I need to clarify:

1. OAuth provider: Which OAuth providers? (Google, GitHub, custom?)
2. User data: Store OAuth tokens or just user profile?
3. Sessions: Integrate with existing session management?

Testing questions:
4. Test coverage: What level of test coverage is expected?
5. TDD: Should tests be written before or after implementation?
6. Integration tests: Required in addition to unit tests?
```

### Phase 4: Architecture Design

**Goal**: Design multiple implementation approaches with test strategies and milestones

**What happens:**
- Launches 2-3 `code-architect` agents with different focuses:
  - **Minimal changes**: Smallest change, maximum reuse
  - **Clean architecture**: Maintainability, elegant abstractions
  - **Pragmatic balance**: Speed + quality
- **NEW**: Each approach includes test strategy and milestone decomposition
- Reviews all approaches and forms recommendation
- Presents comparison with trade-offs
- **Asks which approach you prefer**
- **Asks about implementation mode** (Lightweight, Balanced, Thorough)

**Example output:**
```
Approach 2: Clean Architecture

Components:
- OAuthService: Handles OAuth flow
- OAuthProvider: Provider abstraction
- AuthMiddleware: Request authentication

Test Strategy:
- Unit tests: OAuthService with mocked providers
- Integration tests: Full OAuth flow with test server
- Mocking: Use nock for external OAuth endpoints

Milestones:
1. [S] Core types and interfaces
2. [M] OAuthProvider abstraction
3. [M] OAuthService implementation
4. [S] AuthMiddleware integration
5. [M] Tests and documentation

Which implementation mode?
- Lightweight: Verify all, checkpoint at end only
- Balanced (recommended): Verify all, mini-review medium+, checkpoint major
- Thorough: Verify all, mini-review all, checkpoint every milestone
```

### Phase 4.5: Impact Analysis (Conditional)

**Goal**: Understand blast radius before making changes

**NEW**: This phase triggers automatically when changes are risky:
- Modifying more than 5 existing files
- Touching auth, payments, or user data
- Changing API contracts or database schemas

**What happens:**
- Launches `impact-analyzer` agent
- Analyzes downstream dependencies
- Assesses breaking change risk
- Evaluates test coverage of affected paths
- Presents findings for acknowledgment

**Example output:**
```
Impact Analysis:

Direct dependents of AuthService:
- src/middleware/auth.ts (imports AuthService)
- src/routes/user.ts (calls authenticate())
- src/routes/admin.ts (calls requireRole())

Risk Assessment: MEDIUM
- 12 files depend on modified interfaces
- 8/12 have test coverage
- No breaking changes to public API

Proceed with implementation?
```

### Phase 5: Iterative Implementation

**Goal**: Build the feature incrementally with verification

**NEW**: Instead of "big bang" implementation, builds in milestones:

**What happens:**
- Presents milestones from architecture
- For each milestone:
  1. Implements the milestone code
  2. **Launches `quick-verifier`** (type check, lint, targeted tests)
  3. Mini-review (if Balanced/Thorough mode)
  4. Architecture alignment check
  5. User checkpoint (if configured)
  6. Marks complete, proceeds to next

**Example flow:**
```
Milestone 2/5: OAuthProvider abstraction [M]

Implementing...
✓ Created src/auth/OAuthProvider.ts
✓ Created src/auth/providers/GoogleProvider.ts

Verifying...
✓ Type check: PASS
✓ Lint: PASS
✓ Tests: 4/4 passing

Mini-review findings:
- No critical issues

Proceed to Milestone 3?
```

### Phase 6: Quality Review & Verification

**Goal**: Ensure code is simple, DRY, elegant, and verified

**What happens:**
1. **NEW**: Runs full test suite first
   - Must pass before proceeding to review
   - Fixes any failures
2. Launches 3 `code-reviewer` agents:
   - **Standard**: Simplicity, DRY, elegance
   - **Security mode**: For auth/data handling code
   - **Performance mode**: For database/algorithm code
3. **NEW**: Launches `code-tester` for test quality review
4. Consolidates all findings
5. **Presents findings with test status**
6. Asks what you want to do (fix now, fix later, proceed)

**Example output:**
```
Quality Review Results:

Test Status: ALL PASSING (47 tests)

Code Review Issues:
High Priority:
1. Missing error handling in OAuth callback (src/auth/oauth.ts:67)

Medium Priority:
1. Could simplify token refresh logic

Test Quality Assessment:
- Coverage: 85% (above 80% threshold)
- Quality score: 4/5
- Gap: No test for token expiry edge case

What would you like to do?
```

### Phase 7: Summary & Documentation

**Goal**: Document what was accomplished

**What happens:**
- Marks all todos complete
- **NEW**: Suggests documentation updates:
  - API docs (if new endpoints)
  - README updates (if user-facing changes)
  - Changelog entry
- Summarizes:
  - What was built
  - Key decisions made
  - **Tests written and coverage achieved**
  - **Verification status**
  - Files modified
  - Suggested next steps

**Example:**
```
Feature Complete: OAuth Authentication

What was built:
- OAuth provider abstraction supporting Google and GitHub
- OAuth routes and middleware
- Token refresh and session integration

Tests:
- 12 unit tests, 4 integration tests
- Coverage: 85% (target: 80%)
- All tests passing

Files modified:
- src/auth/OAuthProvider.ts (new)
- src/auth/AuthService.ts (modified)
- src/routes/auth.ts (modified)
- __tests__/auth/*.test.ts (new)

Suggested documentation:
- Add OAuth setup instructions to README
- Document new /auth/oauth/* endpoints

Suggested next steps:
- Add more OAuth providers (Microsoft, Apple)
- Set up OAuth app credentials in production
```

## Agents

### `code-explorer`

**Purpose**: Deeply analyzes existing codebase features by tracing execution paths

**Focus areas:**
- Entry points and call chains
- Data flow and transformations
- Architecture layers and patterns
- Dependencies and integrations

**When triggered:**
- Automatically in Phase 2
- Can be invoked manually when exploring code

### `code-architect`

**Purpose**: Designs feature architectures with test strategies and milestones

**Focus areas:**
- Codebase pattern analysis
- Architecture decisions with rationale
- Component design and data flow
- **Test strategy for each component**
- **Milestone decomposition**

**When triggered:**
- Automatically in Phase 4
- Can be invoked manually for architecture design

### `code-reviewer`

**Purpose**: Reviews code for bugs, quality, and project conventions

**Focus areas:**
- Project guideline compliance
- Bug detection with confidence scoring
- Code quality issues

**Review modes:**
- **Standard**: Full review of all responsibilities
- **Security**: OWASP Top 10, input validation, secrets, auth
- **Performance**: N+1 queries, complexity, memory, caching

**When triggered:**
- Automatically in Phase 5 (mini-reviews) and Phase 6
- Can be invoked manually after writing code

### `code-tester` (NEW)

**Purpose**: Analyzes test patterns, plans tests, runs verification, reviews test quality

**Modes:**
- **Discovery**: Find test frameworks, patterns, conventions
- **Planning**: Design test cases from requirements
- **Execution**: Run tests, analyze results
- **Quality Review**: Assess coverage and test quality

**When triggered:**
- Automatically in Phase 2 (discovery)
- Automatically in Phase 6 (quality review)
- Can be invoked manually for test planning

### `quick-verifier` (NEW)

**Purpose**: Fast automated verification after each milestone

**Checks:**
- Type checking (tsc, mypy, go build, etc.)
- Linting (eslint, ruff, etc.)
- Targeted tests (tests related to changed files)
- Import verification

**When triggered:**
- Automatically after each milestone in Phase 5
- Uses fast Haiku model for speed

### `impact-analyzer` (NEW)

**Purpose**: Analyzes blast radius of proposed changes

**Analysis:**
- Dependency graph (what depends on modified code)
- Consumer list (files importing modified modules)
- Breaking change risk assessment
- Test coverage of affected paths

**When triggered:**
- Conditionally in Phase 4.5 when changes are risky
- Can be invoked manually before major refactoring

### `auto-committer` (NEW)

**Purpose**: Executes git commits for completed milestones

**Responsibilities:**
- Generate conventional commit messages from milestone metadata
- Stage only milestone-specific files
- Handle pre-commit hook failures gracefully
- Report commit success/failure

**Features:**
- Auto-fixes formatting/lint issues when possible
- Retries up to 2 times on hook failure
- Never commits unrelated changes
- Atomic commits (one per milestone)

**When triggered:**
- Automatically after successful verification (if auto-commit enabled)
- Uses fast Haiku model for efficiency

## Session Persistence (Resume Support)

The Feature Development Plugin now supports **resuming work across sessions**. Your progress is automatically saved to `.claude/feature-dev.local.md`.

### How It Works

1. **Automatic State Saving**: After each phase transition and milestone completion, progress is saved
2. **Resume Detection**: When you run `/feature-dev`, it checks for existing work
3. **Context Restoration**: Resume from where you left off with full context

### Resume Options

When existing state is detected:
```
Found existing feature work: "OAuth Authentication"
- Current phase: Implementation (milestone 3/5)
- Last updated: 2 hours ago

Options:
1. **Resume** - Continue from implementation
2. **New Feature** - Archive current and start fresh
3. **Review State** - Show full state before deciding
```

### What Gets Persisted

- Current phase and milestone progress
- Discovery findings (similar features, patterns, testing conventions)
- Clarifying questions and answers
- Architecture decision and rationale
- Milestone completion status
- Files modified

### State File Location

```
project-root/
└── .claude/
    └── feature-dev.local.md        # Active feature state
    └── feature-dev.local.md.archived-*  # Previous features
```

Add to your `.gitignore`:
```
.claude/feature-dev.local.md
.claude/feature-dev.local.md.archived-*
```

---

## Auto-Commit Per Milestone

The plugin can **automatically commit** after each milestone passes verification.

### Configuration

During Phase 4 (Architecture Design), you'll be asked about auto-commit preferences:
- **Auto-commit enabled** (default): Commit after each verified milestone
- **Auto-commit disabled**: No automatic commits
- **Confirm each**: Prompt for confirmation before each commit

### Commit Format

Commits use conventional commit format:
```
feat(auth): OAuth Provider Abstraction

- Created OAuthProvider base class
- Added GoogleProvider implementation
- Integrated with auth middleware

Milestone: 2/5
Verification: type:PASS lint:PASS tests:4/4
Files: 3 changed
```

### When Commits Trigger

Auto-commit happens when ALL of:
- Milestone implementation complete
- Quick-verifier passes
- Mini-review passes (if applicable)
- Architecture alignment confirmed
- Auto-commit is enabled

### Error Handling

If a pre-commit hook fails:
1. Auto-fix attempted (formatting, lint errors)
2. Retry up to 2 times
3. If still failing, present error with options:
   - Fix manually and retry
   - Skip commit for this milestone
   - Abort and investigate

### Disabling Auto-Commit

**Per-project** (in `.claude/feature-dev.local.md`):
```yaml
auto_commit: false
```

**Per-session**: Choose "Auto-commit disabled" in Phase 4

**Per-milestone**: Template field `Auto-commit: Skip`

---

## Implementation Modes

When you reach Phase 4, you'll be asked to choose an implementation mode:

| Mode | Verification | Mini-Reviews | User Checkpoints |
|------|--------------|--------------|------------------|
| **Lightweight** | Every milestone | None | Final only |
| **Balanced** (default) | Every milestone | Medium+ milestones | Major milestones |
| **Thorough** | Every milestone | All milestones | Every milestone |

Choose based on:
- **Lightweight**: Trusted changes, tight deadlines, small features
- **Balanced**: Most features, good balance of speed and safety
- **Thorough**: Critical features, unfamiliar codebase, learning

## Usage Patterns

### Full workflow (recommended for new features):
```bash
/feature-dev Add rate limiting to API endpoints
```

Let the workflow guide you through all 7 phases.

### Manual agent invocation:

**Explore a feature:**
```
"Launch code-explorer to trace how authentication works"
```

**Design architecture:**
```
"Launch code-architect to design the caching layer"
```

**Review code:**
```
"Launch code-reviewer with security mode to check auth changes"
```

**Discover test patterns:**
```
"Launch code-tester in discovery mode to understand testing conventions"
```

**Analyze impact:**
```
"Launch impact-analyzer to assess the blast radius of refactoring UserService"
```

## Best Practices

1. **Use the full workflow for complex features**: The 7 phases ensure thorough planning and verification
2. **Answer clarifying questions thoughtfully**: Phase 3 prevents future confusion
3. **Choose architecture deliberately**: Phase 4 gives you options with test strategies
4. **Trust the verification**: Quick-verifier catches issues early
5. **Don't skip impact analysis**: Phase 4.5 prevents unexpected breakages
6. **Review test quality**: Good tests are as important as good code

## When to Use This Plugin

**Use for:**
- New features that touch multiple files
- Features requiring architectural decisions
- Complex integrations with existing code
- Features where requirements are unclear
- Features requiring test coverage

**Don't use for:**
- Single-line bug fixes
- Trivial changes
- Well-defined, simple tasks
- Urgent hotfixes

## Requirements

- Claude Code installed
- Git repository (for code review and verification)
- Project with existing codebase (workflow assumes existing code to learn from)
- Test framework configured (for full testing integration)

## Troubleshooting

### Agents take too long

**Issue**: Code exploration or architecture agents are slow

**Solution**:
- This is normal for large codebases
- Agents run in parallel when possible
- The thoroughness pays off in better understanding

### Quick-verifier can't find test runner

**Issue**: Verification phase can't run tests

**Solution**:
- Ensure test configuration exists (jest.config.js, pytest.ini, etc.)
- Check that test command works manually
- Agent will skip tests if no runner found

### Impact analysis triggers too often

**Issue**: Phase 4.5 runs when not needed

**Solution**:
- The triggers are intentionally conservative
- You can acknowledge and proceed quickly
- Awareness of impact is valuable even for smaller changes

### Too many clarifying questions

**Issue**: Phase 3 asks too many questions

**Solution**:
- Be more specific in your initial feature request
- Provide context about constraints upfront
- Say "whatever you think is best" if truly no preference

## Tips

- **Be specific in your feature request**: More detail = fewer clarifying questions
- **Trust the process**: Each phase builds on the previous one
- **Choose Balanced mode**: Good default for most features
- **Review agent outputs**: Agents provide valuable insights about your codebase
- **Don't skip verification**: Early catches save debugging time later
- **Use for learning**: The exploration phase teaches you about your own codebase

## Author

Sid Bidasaria (sbidasaria@anthropic.com)

## Version

2.1.0

### Changelog

**2.1.0** - Session Persistence & Auto-Commit
- Added session persistence (resume work across sessions)
- Added auto-commit per milestone (configurable)
- Added auto-committer agent
- Added state management documentation

**2.0.0** - Initial release with 7-phase workflow
