# Architecture migration

Use migration only when explicitly requested or when a documented requirement cannot be met safely in the existing structure.

- Record current routes, state ownership, observable behavior, scene/lifecycle behavior, dependency lifetime, persistence, and tests.
- State the concrete limitation and success criteria; architectural fashion is not a rationale.
- Create one safe seam—such as a screen, route, feature model, repository contract, or composition root—and add characterization tests around likely regressions.
- Migrate one responsibility at a time while keeping the app buildable. Preserve route data, restoration keys, analytics contracts, and public interfaces unless their change is in scope.
- Remove obsolete wiring after callers move. Stop for a product decision, public API break, data migration, entitlement change, or dependency change outside the requested scope.
