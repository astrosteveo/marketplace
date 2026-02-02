---
name: feature-development
description: This skill should be used when the user asks to "implement a feature", "build a feature", "add functionality", "guided feature development", "feature workflow", "help me build", "develop this feature", or mentions needing a systematic approach to feature implementation. Provides a structured 6-phase workflow for feature development with codebase exploration, architecture design, and iterative implementation.
---

# Feature Development Workflow

Collaborate with the user to implement features through a systematic approach: understand the codebase deeply, identify and ask about all underspecified details, design elegant architectures with test strategies, then implement incrementally with verification.

## Core Principles

- **Ask clarifying questions**: Identify all ambiguities, edge cases, and underspecified behaviors. Ask specific, concrete questions rather than making assumptions. Wait for user answers before proceeding.
- **Understand before acting**: Read and comprehend existing code patterns first
- **Read files identified by agents**: When launching agents, request lists of important files. After agents complete, read those files to build detailed context.
- **Simple and elegant**: Prioritize readable, maintainable, architecturally sound code
- **Test-aware development**: Integrate testing throughout the workflow
- **Incremental implementation**: Build in milestones with verification, not "big bang"
- **Use TodoWrite**: Track all progress throughout

## Workflow Overview

The feature development workflow consists of 6 phases:

| Phase | Goal | Key Actions |
|-------|------|-------------|
| 1. Discovery & Exploration | Understand feature AND codebase | Launch explorer/tester agents, read key files |
| 2. Clarifying Questions | Resolve ambiguities | Present informed questions, wait for answers |
| 3. Architecture | Design approaches | Launch architect agents, present options |
| 3.5. Impact | Assess blast radius | Analyze downstream effects (conditional) |
| 4. Implementation | Build incrementally | Per-milestone cycle with verification |
| 5. Review | Ensure quality | Run tests, launch reviewers, address issues |
| 6. Summary | Document completion | Summarize, suggest docs, list next steps |

---

## Phase 1: Discovery & Exploration

**Goal**: Understand what needs to be built AND the relevant codebase

**IMPORTANT**: When a feature description is provided, start exploring the codebase immediately. Do NOT ask clarifying questions before understanding the existing code - exploration informs what questions to ask.

**Actions**:
1. Create todo list with all phases
2. If feature request is so vague that exploration targets are unclear (e.g., "make it better"), ask for minimal clarification to enable exploration
3. **Immediately launch exploration** (do not wait for user confirmation):

   Launch 2-3 **code-explorer** agents in parallel targeting different aspects:
   - Similar features and their implementations
   - Architecture and abstractions for the feature area
   - Current implementation of related functionality

4. Launch 1 **code-tester** agent for test pattern discovery

5. Read all files identified by agents to build deep understanding

6. Present comprehensive summary including:
   - Similar features found and their patterns
   - Architecture and conventions to follow
   - Testing approach and conventions
   - Key files for this feature

**Skip exploration when**: Working on isolated bug fix in known code path, or user provides comprehensive codebase context

For detailed agent prompts by feature type, see `references/agent-prompts.md`.

---

## Phase 2: Clarifying Questions

**Goal**: Fill in gaps and resolve all ambiguities before designing

**CRITICAL**: Do not skip this phase. Ask questions early, before designing architecture.

**Actions**:
1. Review codebase findings and original feature request
2. Identify underspecified aspects: edge cases, error handling, integration points, scope boundaries, design preferences, backward compatibility, performance needs
3. Include testing-related questions (coverage expectations, TDD preference, integration tests needed)
4. Present all questions in organized list
5. Wait for answers before proceeding

If user says "whatever you think is best", provide recommendation and get explicit confirmation.

For question templates organized by category, see `examples/clarifying-questions.md`.

---

## Phase 3: Architecture Design

**Goal**: Design multiple implementation approaches with test strategies and milestones

**Actions**:
1. Launch 2-3 **code-architect** agents in parallel with different focuses:
   - **Minimal changes**: Smallest change, maximum reuse
   - **Clean architecture**: Maintainability, elegant abstractions
   - **Pragmatic balance**: Speed + quality

   Each agent must include test strategy and milestone decomposition.

2. Review approaches and form opinion on best fit for this task

3. Present to user: summary of each approach, trade-offs, recommendation with reasoning

4. Ask user which approach they prefer

5. Ask about implementation mode:
   - **Lightweight**: Verify milestones, no mini-reviews, final checkpoint only. *Best for: bug fixes, small features (<3 milestones)*
   - **Balanced** (default): Verify all, mini-review medium+ milestones, checkpoint major milestones. *Best for: standard features, moderate complexity*
   - **Thorough**: Verify all, mini-review all, checkpoint every milestone. *Best for: critical features, security-sensitive, unfamiliar codebase*

For milestone structure templates, see `examples/milestone-templates.md`.

---

## Phase 3.5: Impact Analysis (Conditional)

**Goal**: Understand blast radius before making changes to existing code

**Trigger when ANY of**:
- Architecture modifies more than 5 existing files
- Changes touch authentication, authorization, payments, or user data
- API contracts are being modified
- Database schema changes proposed
- Changes affect shared utilities or core abstractions

**Skip when**:
- New feature with minimal integration
- Bug fixes in isolated code paths
- Documentation-only changes
- Test file changes only

**Actions**:
1. Launch **impact-analyzer** agent with chosen architecture
2. Review impact analysis
3. Present findings: dependency graph, consumer list, breaking change risk, test coverage of affected areas
4. If high risk identified, discuss with user and potentially adjust architecture
5. Proceed only after user acknowledges impact

---

## Phase 4: Iterative Implementation

**Goal**: Build incrementally with verification at each milestone

**DO NOT START WITHOUT USER APPROVAL**

### 4.1: Milestone Planning
1. Present milestones from chosen architecture
2. Confirm checkpoint preferences
3. Create todo entries for each milestone

### 4.2-N: Per-Milestone Cycle

For each milestone:

**A. Implement**
- Read all relevant files
- Implement following chosen architecture and codebase conventions
- Write clean code with tests
- Update todos as progress is made

**B. Quick Verify**
- Launch **quick-verifier** agent
- If fails: fix issues before proceeding
- If passes: continue

**C. Mini-Review** (Medium+ milestones in Balanced/Thorough mode)
- Launch **code-reviewer** agent focused on milestone changes
- Address critical issues before proceeding

**D. Architecture Alignment**
- Verify implementation matches chosen architecture
- Document any necessary deviations

**E. User Checkpoint** (if configured)
- Present milestone completion
- Get approval before next milestone

**F. Mark Complete**
- Update todo status
- Proceed to next milestone

### Integration Verification
After all milestones: run full feature test suite, verify component integration, fix any issues.

---

## Phase 5: Quality Review & Verification

**Goal**: Ensure code is simple, DRY, elegant, correct, and verified

### 5.1: Test Execution
1. Run full test suite (or feature-relevant subset)
2. If tests fail: analyze, fix, re-run
3. **Do not proceed to code review until tests pass**

### 5.2: Code Review
Launch 3 **code-reviewer** agents in parallel:
- **Standard**: Simplicity, DRY, elegance, readability
- **Security mode**: If feature handles auth, user data, payments, or APIs
- **Performance mode**: If feature involves database queries, high-traffic paths, or algorithms

### 5.3: Test Quality Review
Launch **code-tester** agent in quality review mode

### 5.4: Present Findings
1. Present consolidated findings: test status, code review issues by severity, test quality assessment
2. Ask what user wants to do (fix now, fix later, proceed as-is)
3. Address issues based on user decision

---

## Phase 6: Summary & Documentation

**Goal**: Document accomplishments and suggest follow-up

**Actions**:
1. Mark all todos complete
2. Suggest documentation updates (if applicable):
   - API documentation for new endpoints
   - README updates for user-facing behavior changes
   - Changelog entry
3. Summarize: what was built, key decisions, tests written, verification status, files modified, suggested next steps

---

## Additional Resources

### Reference Files
- **`references/agent-prompts.md`** - Detailed agent prompts by feature type
- **`references/phase-details.md`** - Extended guidance for each phase

### Example Files
- **`examples/clarifying-questions.md`** - Question templates by category
- **`examples/milestone-templates.md`** - Milestone structure and examples
