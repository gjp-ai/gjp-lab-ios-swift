---
name: ios-data-concurrency
description: Design, implement, migrate, or review iOS data layers using repositories, URLSession, persistence, Swift concurrency, actors, caching, synchronization, and error handling. Use for networking, storage, offline behavior, background transfer, source-of-truth decisions, or concurrency bugs; not UI-only work.
metadata:
  version: "0.1.0"
---

# iOS Data and Concurrency

Produce a data path with an explicit source of truth, isolation the caller can understand, and failure behavior the UI can handle. Fit the project's installed stack rather than assuming a database, networking library, or offline-first design.

## Discover the host project

Read project instructions, package dependencies, models, repositories, transport and storage sources, actor isolation, callers, and tests. Identify freshness, offline expectations, mutation ownership, error contract, cancellation boundary, and data sensitivity. Determine whether each operation is one-shot, observable, durable, or deferrable before choosing `async`, `AsyncSequence`, observation, an actor, or a background task.

## Select a mode

- **Repository, persistence, or network work:** Read [the repository workflow](references/repository-workflow.md).
- **Offline or synchronization work:** Also read [the offline and synchronization guide](references/offline-sync.md).
- **Review or concurrency diagnosis:** Read [the review guide](references/review.md); diagnose before editing unless a fix is requested.

## Completion contract

- Keep blocking work away from the main actor and document public actor-isolation expectations.
- Preserve structured concurrency and cancellation; never silently translate `CancellationError` into ordinary failure.
- Define cache freshness and conflict behavior when data has more than one writable source.
- Map transport, SDK, storage, and feature models only where semantics or lifetime differ.
- Use deterministic fakes or URL protocols for tests; report any behavior that still depends on a live service or device.
