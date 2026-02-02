# Phase Details Reference

Extended guidance for each phase of the feature development workflow.

---

## Phase 1: Discovery - Extended Guidance

### When to Ask for Clarification

Ask clarifying questions when:
- The feature description is vague or high-level ("make it better", "add search")
- Multiple interpretations are possible
- Scope boundaries are unclear
- Success criteria aren't defined

### Discovery Questions Framework

**Problem Space:**
- What problem is this solving?
- Who is the primary user?
- What happens if this feature doesn't exist?

**Solution Space:**
- What should the feature do in the happy path?
- What are the key user interactions?
- Are there any UI/UX preferences?

**Constraints:**
- Timeline or urgency considerations?
- Technical constraints (browser support, performance requirements)?
- Integration requirements with external systems?

### Confirming Understanding

Present understanding in this format:
```
Based on our discussion, here's my understanding:

**Feature**: [Name]
**Purpose**: [What problem it solves]
**Scope**: [What's included and excluded]
**Key behaviors**: [Bullet list of main functionality]
**Constraints**: [Any limitations or requirements]

Is this accurate?
```

---

## Phase 2: Exploration - Extended Guidance

### Agent Selection Strategy

**For UI Features:**
- Explorer 1: Find similar UI components and their state management
- Explorer 2: Map component hierarchy and styling patterns
- Tester: Discover component testing patterns (RTL, Enzyme, etc.)

**For API Features:**
- Explorer 1: Trace existing endpoints and middleware patterns
- Explorer 2: Map authentication/authorization flow
- Tester: Discover API testing patterns (supertest, mocking)

**For Data Processing:**
- Explorer 1: Trace data pipelines and transformation patterns
- Explorer 2: Map database access patterns and ORMs
- Tester: Discover data testing patterns (fixtures, factories)

**For Infrastructure/DevOps:**
- Explorer 1: Map deployment and configuration patterns
- Explorer 2: Trace logging, monitoring, and error handling
- Tester: Discover integration testing patterns

### Reading Agent-Identified Files

After agents return, prioritize reading:
1. Files mentioned by multiple agents (high relevance)
2. Files in the direct code path of the feature
3. Test files showing patterns to follow
4. Configuration files affecting the feature area

### Presenting Exploration Summary

Structure the summary as:
```
## Codebase Exploration Summary

### Similar Features Found
- [Feature 1]: Located in [path], uses [pattern]
- [Feature 2]: Located in [path], uses [pattern]

### Architecture Patterns
- [Pattern 1]: Used for [purpose], example: [file]
- [Pattern 2]: Used for [purpose], example: [file]

### Testing Approach
- Framework: [Jest/Mocha/etc.]
- Patterns: [Unit tests location, mocking approach]
- Conventions: [Naming, organization]

### Key Files for This Feature
- [file1.ts]: [Why it's relevant]
- [file2.ts]: [Why it's relevant]
```

---

## Phase 3: Clarifying Questions - Extended Guidance

### Question Categories

**Functional Requirements:**
- Edge cases and boundary conditions
- Error states and handling
- Default values and fallbacks
- Input validation rules

**Non-Functional Requirements:**
- Performance expectations
- Scalability considerations
- Accessibility requirements
- Internationalization needs

**Integration Points:**
- External service dependencies
- API contracts and versioning
- Event emission and consumption
- Cache invalidation

**Testing Requirements:**
- Coverage expectations
- TDD vs test-after preference
- Integration test scope
- E2E test requirements

**Design Preferences:**
- Backward compatibility needs
- Migration strategy for existing data
- Feature flag requirements
- Rollback strategy

### Question Prioritization

Ask questions in order of:
1. **Blockers**: Questions that prevent any progress
2. **Architecture-impacting**: Questions that change the approach
3. **Implementation details**: Questions about specific behaviors
4. **Nice-to-know**: Questions that help but aren't essential

### Handling "Whatever you think is best"

When user defers to your judgment:
1. State your recommendation clearly
2. Explain the reasoning
3. Mention trade-offs of the chosen approach
4. Get explicit confirmation before proceeding

Example:
```
For error handling, I recommend using toast notifications for user-facing errors
and logging to the existing error service for debugging. This matches the pattern
in [similar-feature.ts].

The trade-off is that transient errors won't be persisted, but this keeps the
implementation simpler.

Does this approach work for you?
```

---

## Phase 4: Architecture Design - Extended Guidance

### Architect Agent Focuses

**Minimal Changes Agent:**
- Maximize reuse of existing components
- Minimize files touched
- Prefer extension over modification
- Fastest path to working feature

**Clean Architecture Agent:**
- Proper separation of concerns
- Future maintainability
- Testability as first-class concern
- May require more refactoring

**Pragmatic Balance Agent:**
- 80/20 approach: most benefit for reasonable effort
- Reuse where natural, refactor where needed
- Consider team velocity and deadline

### Presenting Architecture Options

Structure the presentation as:
```
## Architecture Options

### Option A: Minimal Changes
**Approach**: [Brief description]
**Files touched**: [Number and list]
**Pros**: [Bullet points]
**Cons**: [Bullet points]
**Test strategy**: [How to test]
**Milestones**: [List]

### Option B: Clean Architecture
[Same structure]

### Option C: Pragmatic Balance
[Same structure]

## My Recommendation

I recommend **Option [X]** because:
- [Reason 1]
- [Reason 2]
- [Reason 3]

The key trade-off is [trade-off], which I believe is acceptable because [reasoning].

Which approach would you prefer?
```

### Implementation Mode Selection

Guide mode selection based on context:

| Context | Recommended Mode |
|---------|------------------|
| Bug fix, isolated change | Lightweight |
| Standard feature, familiar codebase | Balanced |
| New to codebase, learning patterns | Balanced |
| Security-sensitive feature | Thorough |
| Payment/financial feature | Thorough |
| Core infrastructure change | Thorough |
| Experimental/prototype | Lightweight |
| Production-critical path | Thorough |

---

## Phase 4.5: Impact Analysis - Extended Guidance

### Determining When to Run

**Always run when:**
- Modifying shared utilities imported by >5 files
- Changing database schemas
- Modifying API request/response shapes
- Touching authentication or authorization
- Changing core abstractions or base classes

**Safe to skip when:**
- Adding new files only
- Modifying test files only
- Updating documentation
- Bug fix in clearly isolated code
- Adding new endpoint with no existing consumers

### Impact Analysis Request Format

```
Analyze the impact of the proposed changes:

Files to modify:
- [file1.ts]: [What changes]
- [file2.ts]: [What changes]

Interfaces changing:
- [Interface1]: [Field added/removed/modified]

Please identify:
1. All files importing modified modules
2. Downstream dependents of changed interfaces
3. Breaking change risk assessment
4. Test coverage of affected code paths
```

### Presenting Impact Findings

```
## Impact Analysis Results

### Dependency Graph
[Modified File] -> [Consumer 1] -> [Consumer 2]
                -> [Consumer 3]

### Files Affected
- **Direct consumers** (import modified code): [count]
- **Indirect consumers** (use affected components): [count]

### Breaking Change Risk

| Change | Risk Level | Affected | Mitigation |
|--------|------------|----------|------------|
| [Change 1] | High/Medium/Low | [Count] files | [Strategy] |

### Test Coverage of Affected Paths
- [Path 1]: [Coverage %]
- [Path 2]: [Coverage %]

### Recommendation
[Proceed as planned / Adjust approach / Add migration]
```

---

## Phase 5: Implementation - Extended Guidance

### Milestone Granularity

Good milestone size:
- 1-3 hours of implementation work
- 1-5 files modified
- Single coherent piece of functionality
- Independently verifiable

Too small: "Add import statement"
Too large: "Implement entire feature"
Just right: "Add API endpoint with validation and tests"

### Per-Milestone Cycle Details

**A. Implement**
- Read files fresh before each milestone (context may have changed)
- Follow architecture decisions exactly
- Match codebase conventions for naming, formatting, patterns
- Write tests as specified (TDD = tests first)

**B. Quick Verify**
- Type checking catches interface mismatches
- Linting catches style violations
- Targeted tests verify specific functionality
- Fix any failures before proceeding

**C. Mini-Review Triggers**
- Milestone touches >3 files
- Milestone includes security-relevant code
- Milestone modifies shared utilities
- Milestone changes public APIs

**D. Architecture Alignment**
Check for:
- Component placement matches design
- Data flow follows planned pattern
- Naming conventions followed
- Test structure matches plan

**E. User Checkpoint Content**
```
## Milestone [N] Complete: [Name]

### What was built
- [Feature/component 1]
- [Feature/component 2]

### Files changed
- [file1.ts]: [Brief description]
- [file2.ts]: [Brief description]

### Verification status
- Type check: Pass
- Lint: Pass
- Tests: [X] passing, [Y] new

### Ready for next milestone?
```

---

## Phase 6: Quality Review - Extended Guidance

### Test Failure Triage

When tests fail:
1. **Categorize**: New test failures vs. existing failures
2. **Isolate**: Run failed tests individually
3. **Diagnose**: Check for environment issues, race conditions, or actual bugs
4. **Fix**: Address in order of severity
5. **Verify**: Run full suite again

### Code Review Focus Areas

**Standard Review:**
- Code duplication (DRY violations)
- Function/method complexity
- Naming clarity
- Error handling completeness
- Comment necessity and accuracy

**Security Review:**
- Input validation and sanitization
- Authentication/authorization checks
- Sensitive data handling
- SQL/NoSQL injection vectors
- XSS vulnerabilities

**Performance Review:**
- N+1 query patterns
- Unnecessary re-renders
- Large object allocations
- Missing indexes
- Inefficient algorithms

### Presenting Review Findings

```
## Quality Review Results

### Test Status
- Total: [X] tests
- Passing: [Y]
- New tests added: [Z]
- Coverage: [%] (was [%])

### Code Review Issues

**Critical** (must fix):
- [Issue 1]: [File:line] - [Description]

**Major** (should fix):
- [Issue 2]: [File:line] - [Description]

**Minor** (consider fixing):
- [Issue 3]: [File:line] - [Description]

### Test Quality
- Coverage adequate: Yes/No
- Edge cases covered: Yes/No
- Assertions meaningful: Yes/No

### Recommendation
[What I suggest addressing and what can be deferred]

What would you like to do?
1. Fix all issues now
2. Fix critical/major only
3. Proceed as-is and create follow-up tasks
```

---

## Phase 7: Summary - Extended Guidance

### Documentation Suggestions

Only suggest documentation when:
- New public API endpoints added
- User-facing behavior changed
- Configuration options added
- Breaking changes introduced

Do NOT suggest documentation for:
- Internal refactoring
- Bug fixes
- Test additions
- Code cleanup

### Summary Structure

```
## Feature Complete: [Feature Name]

### What Was Built
[2-3 sentence summary of the feature]

### Key Decisions
- [Decision 1]: [Why this choice]
- [Decision 2]: [Why this choice]

### Testing
- [X] unit tests added
- [Y] integration tests added
- Coverage: [%]
- All tests passing: Yes

### Files Changed
**Created:**
- [file1.ts]: [Purpose]

**Modified:**
- [file2.ts]: [What changed]

### Suggested Follow-ups
- [Optional improvement 1]
- [Optional improvement 2]

### Documentation (if applicable)
- [ ] API docs: [Specific update needed]
- [ ] README: [Specific update needed]
- [ ] CHANGELOG: [Entry text]
```
