# Issue 7: Company detail — assign user picker

**Label:** ready-for-agent  
**Trello column:** Backlog

---

## What to build

Add an assign-user flow to the company detail screen so admins can add existing users to a company.

An "Assign User" button on the detail screen opens a modal dialog. The modal fetches all available users via `CompanyRepository.getAvailableUsers()` (returns `List<UserSummary>`) and displays a searchable dropdown or list filtered by email. Selecting a user and confirming calls `CompanyRepository.assignUser(companyId, userId)`. On success, the members list on the detail screen reloads to reflect the new member. On failure, an error is shown inside the modal.

The `CompanyBloc` handles an `AssignUserEvent` that calls the repository and, on success, re-fetches the users list (or appends the assigned user to state directly if the detail endpoint is not needed again).

## Acceptance criteria

- [ ] Company detail screen has an "Assign User" button
- [ ] Tapping it opens a modal that fetches and displays all available users by email
- [ ] The user list in the modal is searchable/filterable by email
- [ ] Selecting a user and confirming calls `CompanyRepository.assignUser()` with the correct ids
- [ ] On success, the members list on the detail screen updates to include the newly assigned user
- [ ] On failure, an error message is shown inside the modal
- [ ] The modal shows a loading indicator while fetching users
- [ ] The modal shows an error state with retry if the users fetch fails
- [ ] `CompanyBloc` has `AssignUserEvent` with corresponding state transition
- [ ] Unit test: `AssignUserEvent` → success → users list reloads in state
- [ ] Unit test: `AssignUserEvent` → failure → failure status emitted

## Blocked by

- Issue 2 (`UserSummary` entity + `getAvailableUsers()`)
- Issue 3 (`assignUser()` on `CompanyRepository`)
- Issue 4 (Company detail screen exists and is routed)
- Issue 6 (Company detail BLoC is fully shaped before adding another event)
