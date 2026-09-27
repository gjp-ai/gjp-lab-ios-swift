---
name: swift-concurrency
description: Write, fix, migrate, or review Swift concurrency in iOS code, including async/await, Task and cancellation, actors, MainActor and default actor isolation, nonisolated and @concurrent, Sendable, AsyncSequence, and Swift 6 strict-concurrency migration. Use for data races, actor-isolation or Sendable errors, work blocking the main thread, "run this in the background" requests, or Swift 6 language-mode changes. Not for choosing a networking or storage design.
metadata:
  version: "0.3.0"
---

# Swift Concurrency

Make it obvious where each piece of code runs, who owns each mutable value, and how work is cancelled. Fit the target's concurrency settings instead of assuming Swift 5 or Swift 6 defaults.

Pairs with `ios-data-layer` for repositories and storage, and `ios-testing` for concurrency tests.

## Discover the host project

Read each affected target's `SWIFT_VERSION`, `SWIFT_STRICT_CONCURRENCY`, `SWIFT_DEFAULT_ACTOR_ISOLATION`, `SWIFT_APPROACHABLE_CONCURRENCY`, and enabled upcoming features; the same code means different things under each. Then read the callers, existing actors and `@MainActor` types, task creation sites, and third-party APIs that deliver callbacks.

## Select a mode

- **Swift 6 mode, strict-concurrency diagnostics, or isolation settings:** [Swift 6 migration guide](references/swift6-migration.md).
- **Review or race diagnosis:** [concurrency review checklist](references/review.md); diagnose before editing unless a fix is requested.
- **New async code:** follow the gotchas and completion contract below.

## Gotchas

- With `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`, unannotated types and functions are main-actor isolated. Mark pure models, parsers, and decoding `nonisolated`; use `@concurrent` for CPU-heavy async work.
- With approachable concurrency, a `nonisolated async` function runs on the caller's actor. It does not leave the main actor unless it is `@concurrent`.
- `Task {}` inherits the current actor, so `await` on a synchronous same-actor call is unnecessary (the compiler warns). `Task.detached` drops priority, task locals, and structured cancellation; use it only with a stated reason.
- Unstructured tasks are not cancelled with their creator. Store the `Task` and cancel it, or prefer `.task`, `async let`, and task groups.
- Actor methods are re-entrant: state can change across every `await`. Re-check assumptions after suspension points.
- `@unchecked Sendable`, `nonisolated(unsafe)`, and `@preconcurrency` silence the compiler. Use them only with a comment stating the invariant that makes them safe.

## Completion contract

- Keep blocking and CPU-heavy work off the main actor; document the isolation of public APIs.
- Preserve structured concurrency and cancellation; never turn `CancellationError` into an ordinary failure.
- Give shared mutable state exactly one owner (an actor, the main actor, or a lock with a stated invariant).
- Build with no new concurrency warnings, and run tests (with the Thread Sanitizer for touched concurrent code) or report why not.
