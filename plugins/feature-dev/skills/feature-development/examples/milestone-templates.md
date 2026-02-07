# Milestone Templates

Templates and examples for structuring implementation milestones.

---

## Milestone Template

```
### Milestone [N]: [Name]

**Scope**: [What's included in this milestone]

**Files**:
- Create: [New files to create]
- Modify: [Existing files to change]

**Deliverables**:
- [ ] [Specific deliverable 1]
- [ ] [Specific deliverable 2]
- [ ] [Tests for this milestone]

**Verification**:
- [ ] Type check passes
- [ ] Lint passes
- [ ] [Specific tests] pass
- [ ] [Manual verification if needed]

**Dependencies**: [Previous milestones required, or "None"]

**Checkpoint**: [Yes/No - does user approve before next milestone?]

**Estimated complexity**: [Small/Medium/Large]

**Auto-commit**: [Default/Skip/Ask - override project auto-commit setting for this milestone]
```

---

## Milestone Sizing Guide

### Small Milestone
- 1-2 files changed
- Single, focused change
- ~30 minutes to implement
- Low risk of breaking existing code

**Example**: Add validation to existing form field

### Medium Milestone
- 2-4 files changed
- Coherent feature component
- ~1-2 hours to implement
- May touch integration points

**Example**: Add new API endpoint with tests

### Large Milestone
- 4-6 files changed
- Significant feature piece
- ~2-4 hours to implement
- Touches multiple layers

**Example**: Implement data layer with caching

---

## Example: API Feature Milestones

### Feature: User Profile API

```
### Milestone 1: Database Schema & Model

**Scope**: Create user profile database schema and model layer

**Files**:
- Create: `src/models/UserProfile.ts`
- Create: `migrations/001_create_user_profiles.sql`
- Modify: `src/models/index.ts` (add export)

**Deliverables**:
- [ ] UserProfile model with fields: userId, displayName, bio, avatarUrl, preferences
- [ ] Database migration with proper indexes
- [ ] Model validation rules

**Verification**:
- [ ] Migration runs successfully
- [ ] Model unit tests pass
- [ ] Type definitions correct

**Dependencies**: None
**Checkpoint**: No
**Estimated complexity**: Small


### Milestone 2: Service Layer

**Scope**: Implement profile service with CRUD operations

**Files**:
- Create: `src/services/ProfileService.ts`
- Create: `src/services/__tests__/ProfileService.test.ts`
- Modify: `src/services/index.ts` (add export)

**Deliverables**:
- [ ] getProfile(userId) - fetch user profile
- [ ] updateProfile(userId, data) - update profile fields
- [ ] Service-level validation
- [ ] Error handling for not found, validation errors

**Verification**:
- [ ] Unit tests for all service methods
- [ ] Edge cases covered (not found, invalid data)

**Dependencies**: Milestone 1
**Checkpoint**: No
**Estimated complexity**: Medium


### Milestone 3: API Endpoints

**Scope**: Implement REST endpoints for profile operations

**Files**:
- Create: `src/routes/profile.ts`
- Create: `src/routes/__tests__/profile.test.ts`
- Modify: `src/routes/index.ts` (register routes)

**Deliverables**:
- [ ] GET /api/users/:id/profile
- [ ] PUT /api/users/:id/profile
- [ ] Request validation middleware
- [ ] Authorization (users can only edit own profile)

**Verification**:
- [ ] Integration tests for both endpoints
- [ ] Auth tests (own profile vs. others)
- [ ] Validation error responses correct

**Dependencies**: Milestone 2
**Checkpoint**: Yes (API contract review)
**Estimated complexity**: Medium


### Milestone 4: Integration & Documentation

**Scope**: Final integration testing and API documentation

**Files**:
- Modify: `docs/api/users.md`
- Create: `src/routes/__tests__/profile.integration.test.ts`

**Deliverables**:
- [ ] End-to-end integration tests
- [ ] API documentation with examples
- [ ] OpenAPI spec updated

**Verification**:
- [ ] Full test suite passes
- [ ] Manual API testing complete
- [ ] Documentation reviewed

**Dependencies**: Milestone 3
**Checkpoint**: Yes (final review)
**Estimated complexity**: Small
```

---

## Example: UI Feature Milestones

### Feature: Dashboard Filter Component

```
### Milestone 1: Filter State Management

**Scope**: Set up filter state and URL synchronization

**Files**:
- Create: `src/store/filters/dashboardFilters.ts`
- Create: `src/hooks/useDashboardFilters.ts`
- Create: `src/store/filters/__tests__/dashboardFilters.test.ts`

**Deliverables**:
- [ ] Filter state shape (dateRange, status, category)
- [ ] Actions: setFilter, clearFilters, loadFromUrl
- [ ] URL sync hook for shareable filter state
- [ ] Default values

**Verification**:
- [ ] Unit tests for reducers and selectors
- [ ] URL encoding/decoding works correctly

**Dependencies**: None
**Checkpoint**: No
**Estimated complexity**: Medium


### Milestone 2: Filter UI Components

**Scope**: Build reusable filter input components

**Files**:
- Create: `src/components/filters/DateRangeFilter.tsx`
- Create: `src/components/filters/StatusFilter.tsx`
- Create: `src/components/filters/CategoryFilter.tsx`
- Create: `src/components/filters/__tests__/`

**Deliverables**:
- [ ] DateRangeFilter with presets (Today, Week, Month, Custom)
- [ ] StatusFilter multi-select dropdown
- [ ] CategoryFilter searchable dropdown
- [ ] Consistent styling with design system

**Verification**:
- [ ] Component unit tests
- [ ] Accessibility audit (keyboard nav, screen reader)
- [ ] Visual review

**Dependencies**: Milestone 1
**Checkpoint**: Yes (UI review)
**Estimated complexity**: Medium


### Milestone 3: Filter Bar Integration

**Scope**: Integrate filters into dashboard with data fetching

**Files**:
- Create: `src/components/DashboardFilterBar.tsx`
- Modify: `src/pages/Dashboard.tsx`
- Modify: `src/api/dashboard.ts` (add filter params)

**Deliverables**:
- [ ] FilterBar component combining all filters
- [ ] Apply/Clear buttons
- [ ] Loading state during data fetch
- [ ] Debounced filter application

**Verification**:
- [ ] Integration tests with mock data
- [ ] Performance check (no excessive re-renders)
- [ ] URL state persists on refresh

**Dependencies**: Milestone 2
**Checkpoint**: Yes (functionality review)
**Estimated complexity**: Medium


### Milestone 4: Polish & Edge Cases

**Scope**: Handle edge cases and improve UX

**Files**:
- Modify: `src/components/DashboardFilterBar.tsx`
- Create: `src/components/filters/FilterChips.tsx`

**Deliverables**:
- [ ] Active filter chips with remove buttons
- [ ] Empty state when no results match
- [ ] Filter count badge
- [ ] Mobile responsive layout

**Verification**:
- [ ] E2E tests for full filter flow
- [ ] Mobile layout review
- [ ] Edge case tests (no results, many filters)

**Dependencies**: Milestone 3
**Checkpoint**: Yes (final review)
**Estimated complexity**: Small
```

---

## Example: Data Processing Milestones

### Feature: CSV Import Pipeline

```
### Milestone 1: File Upload & Validation

**Scope**: Accept CSV upload and validate structure

**Files**:
- Create: `src/services/import/CsvValidator.ts`
- Create: `src/services/import/__tests__/CsvValidator.test.ts`
- Create: `src/routes/import.ts`

**Deliverables**:
- [ ] File size validation (max 10MB)
- [ ] CSV structure validation (required columns)
- [ ] Row count validation (max 10,000 rows)
- [ ] Upload endpoint with progress

**Verification**:
- [ ] Unit tests for all validation rules
- [ ] Integration test for upload endpoint
- [ ] Error messages are clear

**Dependencies**: None
**Checkpoint**: No
**Estimated complexity**: Medium


### Milestone 2: Data Transformation

**Scope**: Parse and transform CSV data to internal format

**Files**:
- Create: `src/services/import/CsvTransformer.ts`
- Create: `src/services/import/__tests__/CsvTransformer.test.ts`
- Create: `src/types/ImportTypes.ts`

**Deliverables**:
- [ ] Column mapping configuration
- [ ] Data type coercion (dates, numbers)
- [ ] Row-level validation with error collection
- [ ] Transformation pipeline

**Verification**:
- [ ] Unit tests for each transformation
- [ ] Edge cases: empty values, malformed data
- [ ] Performance test with 10k rows

**Dependencies**: Milestone 1
**Checkpoint**: No
**Estimated complexity**: Medium


### Milestone 3: Database Import

**Scope**: Batch insert transformed data with transaction safety

**Files**:
- Create: `src/services/import/CsvImporter.ts`
- Create: `src/services/import/__tests__/CsvImporter.test.ts`
- Modify: `src/routes/import.ts` (add import endpoint)

**Deliverables**:
- [ ] Batch insert with configurable chunk size
- [ ] Transaction wrapper for atomicity
- [ ] Duplicate detection/handling
- [ ] Import progress tracking

**Verification**:
- [ ] Integration tests with test database
- [ ] Rollback works on failure
- [ ] Performance acceptable for large imports

**Dependencies**: Milestone 2
**Checkpoint**: Yes (data integrity review)
**Estimated complexity**: Large


### Milestone 4: Import Status & History

**Scope**: Track import jobs and provide status API

**Files**:
- Create: `src/models/ImportJob.ts`
- Create: `migrations/002_create_import_jobs.sql`
- Modify: `src/routes/import.ts` (add status endpoint)

**Deliverables**:
- [ ] ImportJob model (status, progress, errors)
- [ ] Status endpoint: GET /api/imports/:id
- [ ] Import history: GET /api/imports
- [ ] Error download for failed rows

**Verification**:
- [ ] Status updates correctly during import
- [ ] Error export works
- [ ] History pagination works

**Dependencies**: Milestone 3
**Checkpoint**: Yes (final review)
**Estimated complexity**: Medium
```

---

## Milestone Checklist Before Implementation

Before starting implementation, verify:

- [ ] All milestones have clear scope boundaries
- [ ] Dependencies are correctly ordered
- [ ] No milestone is too large (>6 files or >4 hours)
- [ ] Checkpoints are at logical review points
- [ ] Test deliverables are included in each milestone
- [ ] Verification criteria are specific and measurable
