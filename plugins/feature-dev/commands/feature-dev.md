---
description: Guided feature development with codebase understanding and architecture focus
argument-hint: Optional feature description
---

# Feature Development

You are helping a developer implement a new feature. Follow a systematic approach: understand the codebase deeply, identify and ask about all underspecified details, design elegant architectures with test strategies, then implement incrementally with verification.

## Core Principles

- **Ask clarifying questions**: Identify all ambiguities, edge cases, and underspecified behaviors. Ask specific, concrete questions rather than making assumptions. Wait for user answers before proceeding with implementation. Ask questions early (after understanding the codebase, before designing architecture).
- **Understand before acting**: Read and comprehend existing code patterns first
- **Read files identified by agents**: When launching agents, ask them to return lists of the most important files to read. After agents complete, read those files to build detailed context before proceeding.
- **Simple and elegant**: Prioritize readable, maintainable, architecturally sound code
- **Test-aware development**: Integrate testing throughout the workflow
- **Incremental implementation**: Build in milestones with verification, not "big bang"
- **Use TodoWrite**: Track all progress throughout

---

## Phase 1: Discovery

**Goal**: Understand what needs to be built

Initial request: $ARGUMENTS

**Actions**:
1. Create todo list with all phases
2. If feature unclear, ask user for:
   - What problem are they solving?
   - What should the feature do?
   - Any constraints or requirements?
3. Summarize understanding and confirm with user

---

## Phase 2: Codebase Exploration

**Goal**: Understand relevant existing code, patterns, and testing approach

**Actions**:
1. Launch 2-3 code-explorer agents in parallel. Each agent should:
   - Trace through the code comprehensively and focus on getting a comprehensive understanding of abstractions, architecture and flow of control
   - Target a different aspect of the codebase (eg. similar features, high level understanding, architectural understanding, user experience, etc)
   - Include a list of 5-10 key files to read

   **Example agent prompts**:
   - "Find features similar to [feature] and trace through their implementation comprehensively"
   - "Map the architecture and abstractions for [feature area], tracing through the code comprehensively"
   - "Analyze the current implementation of [existing feature/area], tracing through the code comprehensively"

2. **Launch 1 code-tester agent** for test pattern discovery:
   - "Discover the testing patterns, frameworks, and conventions in this codebase. Find test configuration files, identify the test directory structure, document mocking strategies and fixture patterns, and provide examples of well-written tests to follow."

3. Once the agents return, please read all files identified by agents to build deep understanding
4. Present comprehensive summary of findings **including testing approach and conventions**

---

## Phase 3: Clarifying Questions

**Goal**: Fill in gaps and resolve all ambiguities before designing

**CRITICAL**: This is one of the most important phases. DO NOT SKIP.

**Actions**:
1. Review the codebase findings and original feature request
2. Identify underspecified aspects: edge cases, error handling, integration points, scope boundaries, design preferences, backward compatibility, performance needs
3. **Include testing-related questions**:
   - What level of test coverage is expected for this feature?
   - Should tests be written first (TDD) or after implementation?
   - Are integration tests required in addition to unit tests?
   - Any specific scenarios or edge cases that must be tested?
4. **Present all questions to the user in a clear, organized list**
5. **Wait for answers before proceeding to architecture design**

If the user says "whatever you think is best", provide your recommendation and get explicit confirmation.

---

## Phase 4: Architecture Design

**Goal**: Design multiple implementation approaches with test strategies and milestones

**Actions**:
1. Launch 2-3 code-architect agents in parallel with different focuses: minimal changes (smallest change, maximum reuse), clean architecture (maintainability, elegant abstractions), or pragmatic balance (speed + quality)
   - Each agent MUST include:
     - **Test strategy**: How to test the components
     - **Milestone decomposition**: Breakdown into verifiable milestones
2. Review all approaches and form your opinion on which fits best for this specific task (consider: small fix vs large feature, urgency, complexity, team context)
3. Present to user: brief summary of each approach, trade-offs comparison, **your recommendation with reasoning**, concrete implementation differences
4. **Ask user which approach they prefer**
5. **Ask user about implementation mode preference**:
   - **Lightweight**: Verify every milestone, no mini-reviews, final checkpoint only
   - **Balanced** (default): Verify all, mini-review medium+ milestones, checkpoint major milestones
   - **Thorough**: Verify all, mini-review all, checkpoint every milestone

---

## Phase 4.5: Impact Analysis (Conditional)

**Goal**: Understand blast radius before making changes to existing code

**Trigger this phase when ANY of**:
- Architecture modifies more than 5 existing files
- Changes touch authentication, authorization, payments, or user data
- API contracts are being modified (request/response shapes, endpoints)
- Database schema changes are proposed
- Changes affect shared utilities or core abstractions

**Skip this phase when**:
- New feature with minimal integration to existing code
- Bug fixes in isolated code paths
- Documentation-only changes
- Changes to test files only

**Actions**:
1. Launch impact-analyzer agent with the chosen architecture:
   - "Analyze the impact of the proposed changes: [summarize what files/interfaces will change]. Identify all downstream dependents, assess breaking change risk, and evaluate test coverage of affected paths."
2. Review the impact analysis
3. Present findings to user:
   - Dependency graph (what depends on modified code)
   - Consumer list (files importing modified modules)
   - Breaking change risk assessment
   - Test coverage of affected areas
4. **If high risk identified**: Discuss with user and potentially adjust architecture
5. Proceed to implementation only after user acknowledges the impact

---

## Phase 5: Iterative Implementation

**Goal**: Build the feature incrementally with verification at each milestone

**DO NOT START WITHOUT USER APPROVAL**

### 5.1: Milestone Planning

1. Present the milestones from the chosen architecture
2. Confirm checkpoint preferences from Phase 4
3. Create todo entries for each milestone

### 5.2-N: Per-Milestone Cycle

For each milestone, execute this cycle:

**A. Implement**
- Read all relevant files for this milestone
- Implement following chosen architecture
- Follow codebase conventions strictly
- Write clean code with tests (if TDD was chosen, tests first)
- Update todos as you progress

**B. Quick Verify**
- Launch quick-verifier agent:
  - "Verify the changes from milestone [N]: [list changed files]. Run type checking, linting, and targeted tests."
- If verification fails: Fix issues before proceeding
- If verification passes: Continue

**C. Mini-Review** (for Medium+ milestones, if Balanced or Thorough mode)
- Launch 1 code-reviewer agent focused on the milestone's changes:
  - "Review the changes in [files] for this milestone. Focus on [relevant concerns]."
- Address any critical issues before proceeding

**D. Architecture Alignment Check**
- Verify implementation matches the chosen architecture
- If deviations were necessary, document why

**E. User Checkpoint** (if configured for this milestone)
- Present milestone completion to user
- Show what was built and verified
- Get approval before proceeding to next milestone

**F. Mark Complete**
- Mark milestone todo as complete
- Proceed to next milestone

### Integration Verification

After all milestones complete:
1. Run full test suite related to the feature
2. Verify all components integrate correctly
3. If issues found, create targeted fixes

---

## Phase 6: Quality Review & Verification

**Goal**: Ensure code is simple, DRY, elegant, functionally correct, and verified

**Actions**:

### 6.1: Test Execution
1. **Run the full test suite** (or feature-relevant subset for large codebases)
2. If tests fail:
   - Analyze failures
   - Fix issues
   - Re-run tests
   - **DO NOT proceed to code review until tests pass**
3. Report test status

### 6.2: Code Review
1. Launch 3 code-reviewer agents in parallel with different focuses:
   - **Standard**: Simplicity, DRY, elegance, readability
   - **Security mode**: If the feature handles auth, user data, payments, or API endpoints
   - **Performance mode**: If the feature involves database queries, high-traffic paths, or algorithms
2. Consolidate findings and identify highest severity issues that you recommend fixing

### 6.3: Test Quality Review
1. Launch code-tester agent in quality review mode:
   - "Review the quality of tests written for [feature]. Assess coverage, test clarity, assertion quality, and identify any gaps."
2. Include test quality findings in the review

### 6.4: Present Findings
1. Present consolidated findings to user:
   - **Test status**: All passing / failures addressed
   - **Code review issues**: By severity
   - **Test quality assessment**: Coverage and quality scores
2. **Ask what they want to do** (fix now, fix later, or proceed as-is)
3. Address issues based on user decision

---

## Phase 7: Summary & Documentation

**Goal**: Document what was accomplished and suggest follow-up

**Actions**:
1. Mark all todos complete
2. **Suggest documentation updates** (if applicable):
   - API documentation (if new endpoints were added)
   - README updates (if user-facing behavior changed)
   - Changelog entry for the feature
   - Present documentation suggestions for user approval
3. Summarize:
   - What was built
   - Key decisions made
   - **Tests written and coverage achieved**
   - **Verification status** (all tests passing, review complete)
   - Files modified/created
   - Suggested next steps

---
