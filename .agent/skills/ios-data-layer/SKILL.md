---
name: ios-data-layer
description: Design, implement, migrate, or review iOS data layers, including repositories, URLSession API calls, REST and JSON decoding, error handling, SwiftData, Core Data, UserDefaults, file storage, caching, and offline sync. Use for calling an API, parsing a response, saving or loading data, choosing a source of truth, cache or stale-data bugs, schema migrations, or sync conflicts. Not for UI-only work; for isolation and data-race questions use swift-concurrency.
metadata:
  version: "0.3.0"
---

# iOS Data Layer

Produce a data path with an explicit source of truth, a clear error contract, and failure behavior the UI can handle. Fit the project's installed stack instead of assuming a database, networking library, or offline-first design.

Pairs with `swift-concurrency` for isolation, `ios-architecture` for ownership, and `ios-testing` for fakes and stubs.

## Discover the host project

Read project instructions, packages, models, repositories, transport and storage code, callers, and tests. Identify freshness needs, offline expectations, who may mutate each value, the error contract, the cancellation boundary, data sensitivity, and existing schema versions. Decide whether each operation is one-shot, observed, durable, or deferrable.

## Select a mode

- **Networking or repository work:** [repository workflow](references/repository-workflow.md).
- **SwiftData, Core Data, files, or migrations:** [persistence guide](references/persistence.md).
- **Offline or synchronization work:** also [offline and synchronization guide](references/offline-sync.md).
- **Review:** [data-layer review checklist](references/review.md); report without editing unless asked.

## Gotchas

- `URLSession` does not throw for 4xx or 5xx responses; check `HTTPURLResponse.statusCode`.
- Under default main-actor isolation, `Decodable` models inherit `@MainActor`; mark them `nonisolated` so decoding can run off the main actor.
- `ModelContext`, `NSManagedObjectContext`, and managed objects are not `Sendable`. Pass persistent IDs across actors; use `@ModelActor` or `perform`.
- Changing a SwiftData `@Model` or Core Data entity changes the on-disk schema. Plan a migration before renaming or retyping stored properties; test with a store created by the previous version.
- `UserDefaults` is for small preferences, not tokens (use the Keychain) or large or structured data (use files or a database).

## Completion contract

- Every value has one source of truth; caches define freshness and invalidation.
- Failures are actionable for the caller and keep the underlying error for diagnostics; cancellation is not reported as failure.
- Map transport, SDK, storage, and feature models only where their meaning or lifetime differs.
- Existing user data survives the change, or the migration is stated and tested.
- Tests use fakes or per-test `URLProtocol` stubs, never live services; report anything that still needs a device or live backend.
