# PRD: Companies Feature

**Label:** ready-for-agent  
**Trello column:** Backlog

---

## Problem Statement

Administrators need a dedicated area to manage companies (organisations) within the app — creating, editing, deleting them, and assigning users to them. Currently there is no way for any user to perform these operations through the UI, even though the backend exposes a full companies API. Non-admin users should not see or access this area at all.

---

## Solution

Introduce a "Companies" tab in the sidebar, visible only to admin users (`is_admin: true` on the authenticated user's profile). The tab leads to a companies list screen with create and delete actions, and each company row navigates to a detail screen where admins can edit company details and assign users to the company via a searchable picker.

Admin access is enforced at two levels: the sidebar hides the tab for non-admins, and the router redirects any direct URL access to `/companies` back to `/projects` for non-admins.

---

## User Stories

1. As an admin, I want to see a "Companies" tab in the sidebar, so that I can navigate to company management without hunting for a URL.
2. As a non-admin, I want the Companies tab to be hidden from my sidebar, so that I am not confused by features I cannot use.
3. As a non-admin, I want to be redirected away from `/companies` if I navigate there directly, so that access control is enforced consistently.
4. As an admin, I want to see a list of all companies with their name, slot count, and active/inactive status, so that I can get a quick overview of all organisations.
5. As an admin, I want to search companies by name, so that I can quickly find a specific company in a long list.
6. As an admin, I want to filter companies by active/inactive status, so that I can focus on relevant companies.
7. As an admin, I want to create a new company from the companies list screen, so that I can onboard new organisations.
8. As an admin, I want to delete a company from the list, so that I can remove obsolete organisations.
9. As an admin, I want a confirmation step before deleting a company, so that I don't accidentally remove an organisation.
10. As an admin, I want to click a company row to navigate to its detail screen, so that I can view and manage it in depth.
11. As an admin, I want to see a company's name, creation date, active status, and user slot count on the detail screen, so that I have full context about the organisation.
12. As an admin, I want to edit a company's details (e.g. name) from the detail screen, so that I can keep company information up to date.
13. As an admin, I want to see the list of members assigned to a company on the detail screen, so that I know who belongs to it.
14. As an admin, I want to assign a user to a company from the detail screen via a searchable email picker, so that I can onboard users into the correct organisation.
15. As an admin, I want the user picker to fetch all available users from the backend, so that I can find any user regardless of how many exist.
16. As an admin, I want the app to reflect my `is_admin` status automatically after login, so that my sidebar and access rights are correct without a page refresh.
17. As an admin, I want error states and retry actions on the companies list and detail screens, so that transient failures don't leave me stuck.

---

## Implementation Decisions

### User entity cleanup
- The `User` domain entity is simplified to: `id`, `email`, `isAdmin`, `createdAt`, `updatedAt`.
- The `UserRole` enum (`admin`, `owner`, `member`) is removed entirely — it was an unused artifact never populated from the real API.
- `username`, `active`, `companyId`, and the `displayName` getter are removed.
- `isAdmin` maps from `is_admin: bool? ?? false` on the profile API response. The backend still needs to add this field; until then it defaults to `false`.
- Auth fallback construction (login failure, session restore) uses `isAdmin: false` as the default.

### UserSummary entity (new)
- A lightweight `UserSummary` entity (`id`, `email`, `createdAt`, `updatedAt`) is introduced for the assign-user picker, matching the slim response shape of the new `GET /api/v1/users` endpoint (provided by backend).
- This keeps the `User` entity (used by auth) separate from the picker's data needs.

### AuthState — expose isAdmin
- `AuthState` must expose the authenticated `User` (or at minimum `isAdmin: bool`) so that both the router and the sidebar can gate on it without additional BLoC dependencies.

### CompanyRepository — extend interface
- Add to the `CompanyRepository` abstract interface:
  - `Future<Company> create({required String name})`
  - `Future<void> update(int id, {String? name})`
  - `Future<void> delete(int id)`
  - `Future<void> assignUser(int companyId, int userId)`
  - `Future<List<UserSummary>> getAvailableUsers()`
- `CompanyWebApi` abstraction is updated to match (POST, PATCH, DELETE, assign_user, GET users).

### Screen renaming: organisation → company
- `OrganisationScreen` → `CompanyScreen` (detail view for one company)
- `OrganisationsListScreen` → `CompaniesScreen` (list of all companies)
- `OrganisationBloc/State/Event` → `CompanyBloc/State/Event`
- `OrganisationsListBloc/State/Event` → `CompaniesBloc/State/Event`
- All user-visible labels change from "Organisation/Organisations" to "Company/Companies".

### Companies list screen — CRUD additions
- Header: "Companies" title + search field + active/inactive filter (already built) + **"New Company" button**.
- New Company: opens a dialog with a name field, calls `CompanyRepository.create()`, reloads list on success.
- Each company row: tap → navigate to `/companies/:id`. Trailing delete icon → confirmation dialog → `CompanyRepository.delete()` → remove from list.

### Company detail screen — edit + assign user
- Edit: inline or dialog-based edit of company name, calls `CompanyRepository.update()`.
- Assign user: button opens a modal. Modal fetches `CompanyRepository.getAvailableUsers()` → displays a searchable dropdown by email → on confirm calls `CompanyRepository.assignUser()` → reloads members list.

### Routing
- New GoRouter branches added:
  - `/companies` → `CompaniesScreen` (wrapped with `CompaniesBloc`)
  - `/companies/:id` → `CompanyScreen` (wrapped with `CompanyBloc`, receives `id` param)
- Router redirect: if `authBloc.state.user?.isAdmin != true` and location starts with `/companies`, redirect to `/projects`.

### Sidebar
- New `SidebarItem` for "Companies" at index 2 (between Profile and whatever follows).
- Rendered conditionally: only shown when `authBloc.state.user?.isAdmin == true`.
- `MainShell` passes `isAdmin` into `Sidebar` (or `Sidebar` reads it from context).

### Dependency injection
- `CompaniesBloc` and `CompanyBloc` registered as factories in `Injector`.
- `UserSummaryResponseDto` and its `toDomain()` wired into `CompanyWebApiImpl`.

### API endpoints (backend-confirmed)
| Method | Path | Purpose |
|--------|------|---------|
| GET | `/api/v1/companies` | List all companies |
| POST | `/api/v1/companies` | Create a company |
| GET | `/api/v1/companies/{id}` | Get single company |
| PATCH | `/api/v1/companies/{id}` | Update a company |
| DELETE | `/api/v1/companies/{id}` | Delete a company |
| POST | `/api/v1/companies/{id}/assign_user` | Assign user to company |
| GET | `/api/v1/users` | List all users (for picker) — backend to implement |

---

## Testing Decisions

Good tests verify observable behavior at module boundaries — what data flows in and what comes out — without asserting on internal BLoC implementation details or widget structure.

### Modules to test

**`CompaniesBloc`**
- Given a repository that returns a list, loading emits success state with companies.
- Given a repository that throws, loading emits failure state.
- Search event filters `filteredCompanies` correctly.
- Filter event (active/inactive/all) filters correctly.
- Create event → success → companies list updated.
- Delete event → success → company removed from list.

**`CompanyBloc`**
- Load event fetches company + users in parallel, emits success with both.
- Assign user event calls repository and reloads users.
- Update event calls repository and updates company in state.

**`CompanyRepository` (integration, against mock `CompanyWebApi`)**
- `getAll()` maps DTOs to domain models correctly.
- `create()` passes correct payload and returns domain model.
- `delete()` calls correct endpoint.
- `assignUser()` calls correct endpoint with correct ids.
- `getAvailableUsers()` maps `UserSummary` DTOs correctly.

### Prior art
- `ProjectsBloc` tests (if they exist) are the closest structural analogue for list + CRUD BLoC tests.
- `OrganisationsListBloc` (to be renamed `CompaniesBloc`) is the direct predecessor — existing logic can be ported and extended.

### Out of scope for tests
- Widget/UI tests for the companies screens.
- Router redirect behavior (manual QA sufficient given GoRouter's redirect is a one-liner).

---

## Out of Scope

- Role-based permissions beyond `is_admin` (owner/member distinctions).
- Removing a user from a company (no backend endpoint for this).
- Pagination on companies list or users list.
- Company logo / avatar upload.
- Any non-admin user view of their own company membership.
- Email invitation flow — assign-user assumes the user already exists in the system.

---

## Further Notes

- The `is_admin` field on the profile response is pending backend work. Until it ships, all authenticated users will have `isAdmin: false` and the Companies tab will be invisible. This is the correct safe default.
- The new `GET /api/v1/users` endpoint shape is: `[{ "id": int, "email": string, "created_at": string, "updated_at": string }]`.
- The existing `organisation/` and `organisations/` screen code is well-structured and should be renamed in place rather than rewritten — only CRUD wiring and naming changes are needed.
