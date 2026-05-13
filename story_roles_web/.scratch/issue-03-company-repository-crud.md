# Issue 3: Extend `CompanyRepository` with CRUD + assign-user

**Label:** ready-for-agent  
**Trello column:** Backlog

---

## What to build

Extend the `CompanyRepository` interface and its full data stack (web API abstraction, HTTP implementation, mock implementation, repository implementation) to support all mutating operations exposed by the backend.

The existing interface only has read methods (`getCompany`, `getUsers`, `getAll`). Add:

- `create({required String name})` → `Future<Company>` — POST `/api/v1/companies`
- `update(int id, {String? name})` → `Future<void>` — PATCH `/api/v1/companies/{id}`
- `delete(int id)` → `Future<void>` — DELETE `/api/v1/companies/{id}`
- `assignUser(int companyId, int userId)` → `Future<void>` — POST `/api/v1/companies/{id}/assign_user`

No UI in this slice — deliverable is a working data layer verified by repository unit tests.

## Acceptance criteria

- [ ] `CompanyRepository` abstract interface includes `create`, `update`, `delete`, `assignUser`
- [ ] `CompanyWebApi` abstraction includes matching method signatures
- [ ] `CompanyWebApiImpl` implements all four methods hitting the correct backend endpoints
- [ ] Mock `CompanyWebApi` implements all four methods with stub responses
- [ ] `CompanyRepositoryImpl` delegates to the web API and maps responses correctly
- [ ] Unit test: `create` calls web API and returns mapped `Company`
- [ ] Unit test: `delete` calls web API with correct company id
- [ ] Unit test: `assignUser` calls web API with correct company id and user id
- [ ] App compiles without errors

## Blocked by

- Issue 2 (`UserSummary` + `getAvailableUsers` shares the `CompanyRepository` interface — complete that first to avoid merge conflicts on the interface file)
