# Persistence

Use for SwiftData, Core Data, file storage, `UserDefaults`, or schema migrations.

## Choose the store

| Data | Prefer |
| --- | --- |
| Small preferences and flags | `UserDefaults` / `@AppStorage` |
| Secrets and tokens | Keychain (see `ios-platform-privacy`) |
| Documents, images, exported data | Files in the app container |
| Structured, queried, or related records | SwiftData (new code) or the project's existing Core Data stack |

Do not introduce a second database beside an existing one without a stated reason.

## SwiftData

- Create one `ModelContainer` at the app's composition root and inject it with `.modelContainer(_:)`.
- Read in views with `@Query`; write through the environment `ModelContext` or a repository.
- Do heavy imports and background writes in a `@ModelActor`; pass `PersistentIdentifier` values, not models, across actors.
- Version schemas with `VersionedSchema` and a `SchemaMigrationPlan` before changing stored properties.

## Core Data

- Use `viewContext` only on the main actor; do background work with `newBackgroundContext()` or `performBackgroundTask`, inside `perform`.
- Pass `NSManagedObjectID` across contexts, never managed objects.
- Use lightweight migration for additive changes; write a mapping model or staged migration for renames and type changes.

## Verify

- Test with an in-memory store per test.
- Test migration by opening a store created with the previous schema version.
- Confirm large data does not load on the main actor and that deletes cascade as intended.
