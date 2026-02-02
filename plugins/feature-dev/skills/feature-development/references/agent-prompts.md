# Agent Prompts Reference

Detailed agent prompts organized by feature type and phase.

---

## Code Explorer Agent Prompts

### By Feature Type

#### API/Backend Features

**Similar Features:**
```
Find API endpoints similar to [feature description] and trace through their
implementation comprehensively. Focus on:
- Route definition and middleware chain
- Request validation and parsing
- Business logic organization
- Response formatting and error handling
- Database interactions

Return a list of 5-10 key files that best demonstrate these patterns.
```

**Architecture Mapping:**
```
Map the backend architecture for [feature area], tracing through the code
comprehensively. Document:
- Layer organization (routes, controllers, services, repositories)
- Dependency injection patterns
- Configuration management
- Logging and monitoring integration
- Transaction handling

Return a list of 5-10 key files that define this architecture.
```

**Data Flow:**
```
Analyze the data flow for [existing feature/area], tracing from API request
to database and back. Document:
- Request/response transformations
- Validation checkpoints
- Caching layers
- Event emission points
- Error propagation

Return a list of 5-10 key files in this flow.
```

#### UI/Frontend Features

**Similar Components:**
```
Find UI components similar to [feature description] and trace through their
implementation comprehensively. Focus on:
- Component structure and composition
- State management approach
- Props interface and defaults
- Event handling patterns
- Styling methodology

Return a list of 5-10 key files that best demonstrate these patterns.
```

**State Management:**
```
Map the state management architecture for [feature area], tracing through
the code comprehensively. Document:
- Store structure and organization
- Action/reducer patterns
- Selector usage
- Side effect handling
- State persistence

Return a list of 5-10 key files that define state management.
```

**User Interaction Flow:**
```
Trace the user interaction flow for [existing feature], from user action
to UI update. Document:
- Event handlers and their organization
- Form handling and validation
- Loading and error states
- Optimistic updates
- Accessibility considerations

Return a list of 5-10 key files in this flow.
```

#### Data Processing Features

**Pipeline Patterns:**
```
Find data processing pipelines similar to [feature description] and trace
through their implementation. Focus on:
- Input parsing and validation
- Transformation steps
- Error handling and recovery
- Output formatting
- Progress tracking

Return a list of 5-10 key files demonstrating these patterns.
```

**Database Access:**
```
Map the database access patterns for [feature area], tracing through the
code comprehensively. Document:
- ORM/query builder usage
- Connection management
- Migration patterns
- Index usage
- Query optimization

Return a list of 5-10 key files for database access.
```

#### Infrastructure Features

**Configuration Patterns:**
```
Map the configuration and environment management patterns, tracing through
the code comprehensively. Document:
- Environment variable handling
- Secret management
- Feature flags
- Configuration validation
- Environment-specific overrides

Return a list of 5-10 key configuration files and handlers.
```

**Deployment Pipeline:**
```
Trace the deployment and CI/CD patterns in this codebase. Document:
- Build process
- Test execution
- Deployment stages
- Rollback mechanisms
- Monitoring integration

Return a list of 5-10 key files for deployment.
```

---

## Code Tester Agent Prompts

### Test Pattern Discovery

```
Discover the testing patterns, frameworks, and conventions in this codebase.
Find and document:

1. Test configuration files (jest.config, vitest.config, etc.)
2. Test directory structure and naming conventions
3. Mocking strategies and mock file locations
4. Fixture and factory patterns
5. Test utilities and helpers
6. Integration test setup
7. E2E test configuration (if present)

Provide examples of well-written tests to follow as templates.

Return a list of 5-10 key test files demonstrating best practices.
```

### Test Quality Review

```
Review the quality of tests written for [feature/files]. Assess:

1. **Coverage**: Are all code paths tested?
2. **Clarity**: Are test descriptions clear and specific?
3. **Isolation**: Are tests independent and deterministic?
4. **Assertions**: Are assertions meaningful and complete?
5. **Edge cases**: Are boundary conditions covered?
6. **Error paths**: Are error scenarios tested?
7. **Setup/teardown**: Is test setup clean and minimal?

Identify gaps and suggest improvements.
```

---

## Code Architect Agent Prompts

### Minimal Changes Approach

```
Design an implementation for [feature description] that minimizes changes
to existing code. Prioritize:

1. Maximum reuse of existing components/utilities
2. Minimal files touched
3. Extension over modification
4. Fastest path to working feature

Include:
- Files to create (with purpose)
- Files to modify (with specific changes)
- Test strategy
- Milestone breakdown (2-5 milestones)

Trade-offs to acknowledge: [potential tech debt, less ideal patterns]
```

### Clean Architecture Approach

```
Design an implementation for [feature description] prioritizing
maintainability and clean architecture. Focus on:

1. Proper separation of concerns
2. Clear interfaces and contracts
3. Testability as first-class concern
4. Future extensibility

Include:
- Files to create (with purpose)
- Files to modify/refactor (with rationale)
- Test strategy (unit, integration, e2e)
- Milestone breakdown (3-7 milestones)

Trade-offs to acknowledge: [more initial work, potential over-engineering]
```

### Pragmatic Balance Approach

```
Design an implementation for [feature description] balancing speed
and quality. Apply 80/20 thinking:

1. Reuse where natural, don't force it
2. Refactor where it pays off
3. Keep scope focused
4. Consider team velocity

Include:
- Files to create (with purpose)
- Files to modify (with specific changes)
- Test strategy
- Milestone breakdown (3-5 milestones)

Trade-offs to acknowledge: [what's deferred, what's good enough]
```

---

## Code Reviewer Agent Prompts

### Standard Review

```
Review the changes in [files] for code quality. Focus on:

1. **Simplicity**: Is the code as simple as it can be?
2. **DRY**: Is there unnecessary duplication?
3. **Clarity**: Is the code self-documenting?
4. **Correctness**: Are there logic errors?
5. **Conventions**: Does it follow codebase patterns?

Rate issues by severity:
- Critical: Bugs, security issues, data loss risk
- Major: Significant code quality issues
- Minor: Style, naming, small improvements

Only report issues with confidence >70%.
```

### Security Review

```
Review the changes in [files] for security vulnerabilities. Check for:

1. **Input validation**: Are all inputs validated and sanitized?
2. **Authentication**: Are auth checks in place and correct?
3. **Authorization**: Are permissions properly enforced?
4. **Data exposure**: Is sensitive data protected?
5. **Injection**: SQL, NoSQL, command injection vectors?
6. **XSS**: Cross-site scripting vulnerabilities?
7. **CSRF**: Cross-site request forgery protection?

Rate issues by severity and provide specific remediation.
```

### Performance Review

```
Review the changes in [files] for performance issues. Check for:

1. **Database**: N+1 queries, missing indexes, large result sets
2. **Memory**: Large allocations, memory leaks, unbounded growth
3. **CPU**: Inefficient algorithms, unnecessary computation
4. **Network**: Excessive API calls, large payloads
5. **Rendering**: Unnecessary re-renders, layout thrashing

Rate issues by impact and provide optimization suggestions.
```

---

## Impact Analyzer Agent Prompts

### Standard Impact Analysis

```
Analyze the impact of the proposed changes:

Changes planned:
[List files and what will change]

Identify:
1. All files that import/depend on modified modules
2. Downstream consumers of changed interfaces
3. Breaking change risk for each modification
4. Test coverage of affected code paths
5. Runtime impact (performance, memory)

Provide a dependency graph and risk assessment.
```

### API Change Impact

```
Analyze the impact of API changes:

Endpoint changes:
[List endpoint modifications]

Request/response changes:
[List interface modifications]

Identify:
1. All API consumers (internal and external)
2. Breaking changes requiring migration
3. Backward compatibility options
4. Versioning requirements
5. Documentation updates needed

Provide migration path if breaking changes exist.
```

### Database Schema Impact

```
Analyze the impact of database schema changes:

Schema modifications:
[List table/column changes]

Identify:
1. All queries affected by schema changes
2. Migration complexity and risk
3. Data migration requirements
4. Index implications
5. Performance impact on existing queries
6. Rollback strategy

Provide migration script outline if needed.
```

---

## Quick Verifier Agent Prompts

### Standard Verification

```
Verify the changes from milestone [N]: [description]

Changed files:
[List files]

Run:
1. Type checking (tsc, mypy, etc.)
2. Linting (eslint, prettier, etc.)
3. Unit tests for changed files
4. Integration tests for affected features

Report any failures with specific errors and suggested fixes.
```

### Pre-Commit Verification

```
Run pre-commit verification on all staged changes:

1. Type check entire project
2. Lint changed files
3. Run affected test suites
4. Check for console.log/debugger statements
5. Verify no secrets in code

Report pass/fail status with actionable feedback.
```
