---
description: Guided feature development with codebase understanding and architecture focus
argument-hint: Optional feature description
---

# Feature Development

You are helping a developer implement a new feature. Follow a pragmatic approach: understand just enough, brainstorm briefly, design one good approach, then build iteratively.

## Core Principles

- **Pragmatic over perfect**: Ship working code, then iterate. Don't over-plan.
- **Brainstorm collaboratively**: Share ideas early, get user input, refine together.
- **Ask only critical questions**: Focus on blockers, not exhaustive edge cases. When in doubt, make a reasonable choice and move on.
- **Understand before acting**: Read relevant code patterns, but don't boil the ocean.
- **One good approach**: Design a single solid architecture. Don't present menus of options.
- **Build and adjust**: Start implementing, course-correct as needed.
- **Read files identified by agents**: After agents complete, read key files they identify.
- **Use TodoWrite**: Track progress throughout

---

## Phase 1: Discovery & Brainstorm

**Goal**: Understand what needs to be built and brainstorm ideas together

Initial request: $ARGUMENTS

**Actions**:
1. Create todo list with phases
2. Share your initial take on the feature - what you think it involves, potential approaches
3. **Brainstorm briefly with user**:
   - "Here's what I'm thinking... what do you think?"
   - Offer 1-2 quick ideas if the approach isn't obvious
   - Ask if they have ideas or preferences
4. If anything is truly unclear, ask (keep it brief):
   - What problem are they solving?
   - Any hard constraints?
5. Agree on direction and move on - don't over-discuss

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

## Phase 3: Quick Clarifications

**Goal**: Resolve only critical blockers before designing

**Keep this phase SHORT**. Don't ask about every edge case.

**Actions**:
1. Review codebase findings and feature request
2. Identify only **critical** unknowns that would change the architecture:
   - Major scope decisions (e.g., "should this support X or just Y?")
   - Integration choices (e.g., "use existing auth system or new one?")
   - Hard constraints you discovered
3. Ask 2-4 questions max. Group them in one message.
4. For non-critical decisions, **make a reasonable choice and state it**:
   - "I'll assume we want unit tests but not integration tests - let me know if that's wrong"
   - "I'll follow the existing error handling pattern unless you want something different"

If the user says "whatever you think is best", just proceed with your judgment.

---

## Phase 4: Architecture Design

**Goal**: Design ONE good approach with milestones

**Actions**:
1. Launch 1 code-architect agent focused on a **pragmatic approach**:
   - Balance simplicity with maintainability
   - Reuse existing patterns where sensible
   - Include test strategy and milestone breakdown
2. Review the architecture and refine if needed
3. Present to user:
   - The approach (not multiple options)
   - Key components and why
   - Milestones for implementation
   - Brief rationale for major decisions
4. **Quick brainstorm**: "Does this approach make sense? Any concerns or ideas?"
5. Get thumbs up and proceed - don't belabor the discussion

**Implementation runs in Lightweight mode by default**: verify each milestone, checkpoint only at the end. If user wants more oversight, they can ask.

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

## Phase 5: Implementation

**Goal**: Build the feature in milestones

**Get user approval before starting, then move quickly.**

### 5.1: Setup

1. Briefly confirm milestones from architecture
2. Create todo entries
3. Start building

### 5.2: Per-Milestone Cycle

For each milestone:

**A. Implement**
- Read relevant files
- Implement following architecture and codebase conventions
- Write tests as you go (unless codebase doesn't have tests)
- Update todos

**B. Quick Verify**
- Launch quick-verifier: type check, lint, targeted tests
- Fix any failures before moving on

**C. Continue**
- Mark milestone complete
- Move to next milestone
- No mini-reviews or checkpoints unless user asked for them

### 5.3: Integration Check

After all milestones:
1. Run relevant tests
2. Quick sanity check that components integrate
3. Fix any issues

---

## Phase 6: Quality Review & Verification

**Goal**: Ensure code works and catch obvious issues

**Actions**:

### 6.1: Test Execution
1. Run relevant tests (not necessarily the full suite)
2. If tests fail: fix and re-run
3. Report test status

### 6.2: Code Review
1. Launch 1 code-reviewer agent with appropriate focus:
   - Standard review for most features
   - Add security focus if touching auth/payments/user data
   - Add performance focus if touching DB queries or hot paths
2. Focus on **high-confidence issues only** (don't nitpick)

### 6.3: Present Findings
1. Brief summary:
   - Tests: passing/failing
   - Review: critical issues (if any)
2. Fix critical issues
3. For minor issues: mention them, but don't block on them

---

## Phase 7: Wrap Up

**Goal**: Summarize and suggest next steps

**Actions**:
1. Mark todos complete
2. Brief summary:
   - What was built
   - Files modified/created
   - Tests passing
3. Suggest documentation updates only if clearly needed (new API endpoints, changed user behavior)
4. Mention any follow-up ideas that came up during implementation

---
