# Issue 2: `UserSummary` entity + `GET /api/v1/users` datasource

**Label:** ready-for-agent  
**Trello column:** Backlog

---

## What to build

Introduce a lightweight `UserSummary` entity and wire it through the data layer to support the assign-user picker. This entity represents a user as returned by the new `GET /api/v1/users` endpoint (implemented by the backend developer).

The response shape is an array of:
```json
{
  "id": 0,
  "email": "string",
  "created_at": "2026-05-13T09:32:15.020Z",
  "updated_at": "2026-05-13T09:32:15.020Z"
}
```

`UserSummary` is a separate entity from `User` (which is used by auth). It intentionally carries only what the picker needs. Add `getAvailableUsers()` to the `CompanyWebApi` abstraction and `CompanyRepository` interface, implement it in `CompanyWebApiImpl` and `CompanyRepositoryImpl`, and add a corresponding mock implementation.

No UI in this slice — deliverable is a working data layer method verified by a repository unit test against a mock web API.

## Acceptance criteria

- [ ] `UserSummary` domain entity exists with fields: `id`, `email`, `createdAt`, `updatedAt`
- [ ] `UserSummaryResponseDto` parses the JSON shape above and converts to `UserSummary` via `toDomain()`
- [ ] `CompanyWebApi` abstraction includes `Future<List<UserSummaryResponseDto>> getAvailableUsers()`
- [ ] `CompanyWebApiImpl` calls `GET /api/v1/users` and returns parsed DTOs
- [ ] `CompanyRepository` interface includes `Future<List<UserSummary>> getAvailableUsers()`
- [ ] `CompanyRepositoryImpl` maps DTOs to domain models
- [ ] Mock `CompanyWebApi` returns a stub list for `getAvailableUsers()`
- [ ] Unit test: `CompanyRepository.getAvailableUsers()` against mock web API returns correctly mapped `UserSummary` list

## Blocked by

None — can start immediately.
