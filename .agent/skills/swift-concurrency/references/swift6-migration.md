# Swift 6 and strict-concurrency migration

Use when moving a target to the Swift 6 language mode, fixing strict-concurrency diagnostics, or changing default actor isolation. Treat migration as scoped work the user asked for, not incidental cleanup.

## Plan

- Record each target's `SWIFT_VERSION`, `SWIFT_STRICT_CONCURRENCY`, `SWIFT_DEFAULT_ACTOR_ISOLATION`, enabled upcoming features, and the concurrency readiness of third-party packages.
- Migrate one target at a time: leaf modules (models, utilities) first, the app target last.
- In Swift 5 mode, raise strict concurrency from minimal to targeted to complete, fix diagnostics, then set `SWIFT_VERSION = 6`. Keep the app building after every step.

## Fix diagnostics in this order

1. Value types: make models `Sendable` (implicit for internal structs and enums with `Sendable` members; explicit for public ones).
2. Ownership: put UI-facing classes on `@MainActor`; give shared mutable state one actor owner.
3. Placement: `nonisolated` for pure logic, `@concurrent` for heavy async work, `sending` for values handed across an isolation boundary.
4. Callbacks: use `MainActor.assumeIsolated` only where the framework documents main-thread delivery; otherwise hop explicitly with `await` or `Task { @MainActor in … }`.
5. Unannotated dependencies: `@preconcurrency import`, with a follow-up to remove it.

## Avoid

- Blanket `@MainActor` to silence warnings on CPU-bound code.
- `@unchecked Sendable` or `nonisolated(unsafe)` without a lock or immutability invariant stated in a comment.
- Changing delivery thread or ordering while "only" fixing diagnostics. If behavior changes, say so.

## Verify

- Build every configuration with no new concurrency warnings, and run unit tests.
- Run the Thread Sanitizer (`-enableThreadSanitizer YES`) on tests that cover touched concurrent code.
- Exercise UI paths whose delivery thread changed.
