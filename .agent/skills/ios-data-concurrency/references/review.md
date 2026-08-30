# Data and concurrency review

- Identify each mutable source, its actor/isolation boundary, and the authoritative value.
- Follow calls across SwiftUI, repositories, transport, storage, SDK callbacks, and background boundaries. Confirm cancellation and errors retain meaning.
- Look for main-actor blocking, unstructured tasks without ownership, data races, unsynchronized caches, retain cycles, duplicate observation, undefined freshness, silent conflict resolution, and unbounded retries.
- Check that SDK/transport objects do not leak as mutable feature state, logs do not expose sensitive data, and tests do not use live services.
- Order findings by data loss, user-visible failure, security exposure, and resource risk; explain the timing path that makes each one reachable.
