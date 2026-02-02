# Clarifying Questions Templates

Organized question templates for Phase 3 of feature development.

---

## Feature Scope Questions

### Boundaries
- What is the minimum viable version of this feature?
- Are there any features explicitly out of scope for this iteration?
- Should this be behind a feature flag for gradual rollout?
- What's the migration path for existing users/data?

### Success Criteria
- How will we know this feature is working correctly?
- What metrics should we track?
- Are there performance requirements (response time, throughput)?
- What's the expected usage volume?

---

## Functional Requirements

### Happy Path
- What's the primary user flow through this feature?
- What inputs are required vs. optional?
- What are the default values for optional fields?
- What format should outputs be in?

### Edge Cases
- What happens with empty inputs?
- How should we handle very large inputs?
- What about special characters or Unicode?
- Should there be rate limiting?

### Error Handling
- What errors can users recover from vs. fatal errors?
- How should errors be communicated to users?
- Should we retry transient failures automatically?
- What's the fallback if a dependency is unavailable?

### Validation
- What input validation rules apply?
- Should validation happen client-side, server-side, or both?
- How strict should validation be?
- What feedback should users get for invalid inputs?

---

## Integration Questions

### External Dependencies
- What external services does this feature depend on?
- What happens if an external service is slow or unavailable?
- Are there API rate limits to consider?
- Do we need to handle webhook/callback responses?

### Internal Integration
- How should this integrate with [existing feature X]?
- Should this emit events for other systems to consume?
- Are there shared components we should reuse?
- Does this need to work with the existing caching layer?

### Data Integration
- Where should this data be stored?
- Are there existing tables/collections to extend?
- Do we need new indexes?
- What's the data retention policy?

---

## User Experience Questions

### Interface
- Is this a new page/view or an addition to existing UI?
- Are there mockups or wireframes to follow?
- Should this be mobile-responsive?
- Are there accessibility requirements?

### Feedback
- What loading states should we show?
- How should success be communicated?
- Should there be confirmation dialogs for destructive actions?
- What progress indicators are needed for long operations?

### Navigation
- How do users discover this feature?
- Where should this appear in the navigation?
- Are there links to/from other features?
- Should there be breadcrumbs or back buttons?

---

## Technical Questions

### Performance
- Are there specific performance targets?
- Should this be optimized for read or write heavy usage?
- Is caching appropriate?
- Are there pagination requirements?

### Security
- What authentication is required?
- What authorization rules apply (who can do what)?
- Is there sensitive data that needs encryption?
- Should there be audit logging?

### Compatibility
- What browsers/versions must be supported?
- Are there backward compatibility requirements?
- Should the API be versioned?
- Are there internationalization requirements?

---

## Testing Questions

### Coverage
- What level of test coverage is expected?
- Are integration tests required in addition to unit tests?
- Should we add E2E tests?
- Are there specific scenarios that must be tested?

### Approach
- Should tests be written first (TDD) or after implementation?
- Are there existing test patterns to follow?
- Should we add performance tests?
- Are there manual testing requirements?

### Data
- What test data/fixtures are needed?
- Should tests use mocks or real integrations?
- Are there specific edge cases to test?
- Should we test with production-like data volumes?

---

## Project Questions

### Timeline
- Are there deadline considerations?
- Should this be delivered in phases?
- What's the priority relative to other work?
- Are there dependencies on other teams/features?

### Deployment
- How should this be deployed (all at once, gradual rollout)?
- Are there specific environments to deploy to first?
- What rollback strategy is needed?
- Are there deployment windows to consider?

### Documentation
- What documentation is needed?
- Should there be inline help or tooltips?
- Is API documentation required?
- Are there changelog requirements?

---

## Template: Presenting Questions

When presenting questions, organize by priority and category:

```
## Questions Before We Proceed

### Must Answer (blocking architecture)

**Scope:**
1. [Question 1]?
2. [Question 2]?

**Integration:**
3. [Question 3]?

### Should Answer (affects implementation)

**Error Handling:**
4. [Question 4]?

**Testing:**
5. [Question 5]?

### Nice to Know (can proceed without)

6. [Question 6]?
```

---

## Example: API Feature Questions

```
## Questions: User Profile API

### Must Answer

**Scope:**
1. Should the profile include user preferences, or just basic info (name, email)?
2. Is this read-only, or can users update their profile through this API?

**Authorization:**
3. Can users only view their own profile, or can admins view any profile?

### Should Answer

**Data:**
4. Should we include the user's avatar URL, and if so, where are avatars stored?
5. What fields are required vs. optional on profile update?

**Error Handling:**
6. If a user doesn't exist, should we return 404 or an empty response?

### Testing

7. What level of test coverage is expected for this endpoint?
8. Should we add integration tests against a test database?
```

---

## Example: UI Feature Questions

```
## Questions: Dashboard Filters

### Must Answer

**Scope:**
1. Which fields should be filterable (date range, status, category)?
2. Should filter state persist across page refreshes?

**UX:**
3. Should filters apply immediately on change, or require a "Apply" button?

### Should Answer

**Integration:**
4. Should filters be reflected in the URL for shareable links?
5. Are there existing filter components we should reuse?

**Performance:**
6. With large datasets, should we debounce filter changes?

### Testing

7. Should we add E2E tests for the filter combinations?
```
