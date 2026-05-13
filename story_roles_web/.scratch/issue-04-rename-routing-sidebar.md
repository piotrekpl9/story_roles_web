# Issue 4: Rename organisation → company + admin-gated sidebar + routing

**Label:** ready-for-agent  
**Trello column:** Backlog

---

## What to build

Rename all `organisation`/`organisations` identifiers to `company`/`companies` throughout the codebase (classes, files, labels, strings), then wire the Companies tab into the sidebar and router with an admin-only guard.

This is a mechanical rename plus routing integration — no new business logic. The existing read behavior (list companies, view company detail) must continue working end-to-end after this slice.

**Rename scope:**
- `OrganisationsListScreen` → `CompaniesScreen`
- `OrganisationsListBloc/State/Event` → `CompaniesBloc/State/Event`
- `OrganisationScreen` → `CompanyScreen`
- `OrganisationBloc/State/Event` → `CompanyBloc/State/Event`
- Directories: `organisations/` → `companies/`, `organisation/` → `company/`
- All user-visible strings: "Organisation/Organisations" → "Company/Companies"

**Routing:**
- Add `/companies` branch to `StatefulShellRoute` → `CompaniesScreen` (wrapped with `CompaniesBloc`)
- Add `/companies/:id` nested route → `CompanyScreen` (wrapped with `CompanyBloc`)
- Router redirect: if the authenticated user's `isAdmin` is `false` and the matched location starts with `/companies`, redirect to `/projects`

**Sidebar:**
- Add a Companies `SidebarItem` (index 2)
- Render it only when the authenticated user's `isAdmin` is `true`
- `MainShell` passes `isAdmin` into `Sidebar`, or `Sidebar` reads it from `AuthBloc` via context

## Acceptance criteria

- [ ] No files or classes named `organisation` or `organisations` remain
- [ ] All user-visible text reads "Company" / "Companies" (not "Organisation")
- [ ] `/companies` route renders the companies list for admin users
- [ ] `/companies/:id` route renders the company detail screen for admin users
- [ ] Non-admin navigating to `/companies` (directly or via URL) is redirected to `/projects`
- [ ] Companies sidebar item is visible when logged in as admin, hidden otherwise
- [ ] Existing read behavior (list, detail) works end-to-end with no regressions
- [ ] `CompaniesBloc` and `CompanyBloc` registered in `Injector`
- [ ] App compiles and runs without errors

## Blocked by

- Issue 1 (slim `User` entity — `isAdmin` field needed for the sidebar and router guard)
