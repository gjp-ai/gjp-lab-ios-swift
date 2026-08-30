# Repository workflow

## Define the contract

- State whether callers need a snapshot, an observed value, or a durable operation; define freshness and actionable failures.
- Use `async` for one-shot work and observation or `AsyncSequence` only for values that genuinely change. Document actor isolation and cancellation behavior.
- Preserve `CancellationError`; translate only failures the boundary understands and retain useful underlying context.

## Separate responsibilities

- Let transport and storage sources own mechanics; let repositories coordinate policy. Map models where their meaning or lifetime differs.
- Keep mutable caches private. Use an actor or another explicit synchronization boundary for concurrent mutation.
- Inject clocks, URL protocol/session seams, or schedulers only when deterministic tests or policy require them.

## Verify

- Test success, empty data, actionable failure, cancellation, stale-data behavior, and ordering/races relevant to the feature.
- Use fake sources or a custom `URLProtocol`; do not make unit tests depend on production endpoints.
- Inspect callers for duplicate tasks, lost cancellation, incorrect actor hops, and assumptions invalidated by the new contract.
