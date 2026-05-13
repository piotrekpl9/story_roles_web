# Issue 1: Slim `User` entity + auth wiring

**Label:** ready-for-agent  
**Trello column:** Backlog

---

## What to build

Simplify the `User` domain entity to match the actual API response shape, and expose `isAdmin` through `AuthState` so the rest of the app can gate on it.

The `UserRole` enum (`admin`, `owner`, `member`) is an unused artifact — the backend never sends a role field, so remove it entirely. The fields `username`, `active`, `companyId`, and the `displayName` getter are likewise never populated from real API responses and should be removed.

The new `User` entity has exactly: `id`, `email`, `isAdmin`, `createdAt`, `updatedAt`. The `isAdmin` field maps from `is_admin: bool? ?? false` on the profile response — the backend still needs to add this field, so `false` is the correct safe default until it ships.

`AuthState` must expose the authenticated `User` (or at minimum `isAdmin: bool`) so that the router and sidebar can read it without introducing additional BLoC dependencies. Auth fallback paths (login failure, session restore) construct `User` with `isAdmin: false`.

No UI changes in this slice — the deliverable is the data model compiling cleanly with all call sites updated.

## Acceptance criteria

- [ ] `UserRole` enum is deleted from the codebase
- [ ] `User` entity fields are exactly: `id`, `email`, `isAdmin`, `createdAt`, `updatedAt`
- [ ] `UserResponseDto` maps `is_admin: bool? ?? false` to `User.isAdmin`
- [ ] `AuthRepositoryImpl` login fallback and `getSession()` construct `User` with `isAdmin: false`
- [ ] `AuthState` exposes the authenticated `User` or `isAdmin: bool`
- [ ] All files that previously referenced `user.role`, `user.username`, `user.active`, or `user.companyId` compile without errors
- [ ] App runs without runtime errors after login

## Blocked by

None — can start immediately.
