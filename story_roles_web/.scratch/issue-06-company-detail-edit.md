# Issue 6: Company detail — edit company

**Label:** ready-for-agent  
**Trello column:** Backlog

---

## What to build

Add edit capability to the company detail screen so admins can update a company's name.

An edit action (button or icon) on the company card opens a dialog or inline edit field pre-filled with the current company name. On confirm, calls `CompanyRepository.update()` with the new name. On success, the detail screen reflects the updated name immediately without a full reload. On failure, an error is shown to the user.

The `CompanyBloc` receives an `UpdateCompanyEvent`, calls the repository, and on success emits an updated `CompanyState` with the modified `Company` object. No full re-fetch is required — the state is updated in place.

## Acceptance criteria

- [ ] Company detail screen has an edit action (button or icon) on the company card
- [ ] Triggering edit opens a dialog or inline field pre-filled with the current company name
- [ ] Submitting with a changed name calls `CompanyRepository.update()` with the correct id and new name
- [ ] Submitting with an empty name shows a validation error and does not call the repository
- [ ] On success, the displayed company name updates immediately
- [ ] On failure, an error message is shown to the user
- [ ] `CompanyBloc` has `UpdateCompanyEvent` with corresponding state transition
- [ ] Unit test: `UpdateCompanyEvent` → success → `company.name` updated in state
- [ ] Unit test: `UpdateCompanyEvent` → failure → failure status emitted

## Blocked by

- Issue 3 (CRUD methods on `CompanyRepository`)
- Issue 4 (Company detail screen exists and is routed)
