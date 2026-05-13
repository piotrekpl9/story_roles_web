# Issue 5: Companies list — create + delete

**Label:** ready-for-agent  
**Trello column:** Backlog

---

## What to build

Add create and delete capabilities to the companies list screen, making it a fully functional CRUD list for admin users.

**Create:** A "New Company" button in the list header opens a dialog with a company name text field. On confirm, calls `CompanyRepository.create()`. On success, the new company appears in the list without a full page reload. On failure, an error message is shown inside the dialog.

**Delete:** Each company row has a trailing delete icon. Tapping it opens a confirmation dialog ("Delete company X? This cannot be undone."). On confirm, calls `CompanyRepository.delete()`. On success, the row is removed from the list. On failure, a snackbar or inline error is shown.

Both actions are handled via new `CompaniesBloc` events. The BLoC optimistically updates state on success and emits a failure sub-state on error so the UI can react without a full reload.

## Acceptance criteria

- [ ] "New Company" button is visible in the companies list header
- [ ] Clicking "New Company" opens a dialog with a name input field and confirm/cancel buttons
- [ ] Submitting the dialog with a valid name calls `CompanyRepository.create()` and adds the company to the list
- [ ] Submitting with an empty name shows a validation error and does not call the repository
- [ ] Each company row has a delete action (icon button or similar)
- [ ] Tapping delete shows a confirmation dialog before proceeding
- [ ] Confirming deletion calls `CompanyRepository.delete()` and removes the row from the list
- [ ] API errors during create or delete are surfaced to the user (inline or snackbar)
- [ ] `CompaniesBloc` has `CreateCompanyEvent` and `DeleteCompanyEvent` with corresponding state transitions
- [ ] Unit test: `CreateCompanyEvent` → success → company added to `allCompanies` in state
- [ ] Unit test: `CreateCompanyEvent` → failure → failure status emitted
- [ ] Unit test: `DeleteCompanyEvent` → success → company removed from `allCompanies` in state

## Blocked by

- Issue 3 (CRUD methods on `CompanyRepository`)
- Issue 4 (Companies screen exists and is routed)
