# Repository workflow

## Define the contract

- State whether callers need a snapshot, an observed value, or a durable operation; define freshness and actionable failures.
- Use `async` for one-shot work; use observation or `AsyncSequence` only for values that genuinely change. Document isolation and cancellation behavior.
- Preserve `CancellationError`. Translate only failures the boundary understands, and keep the underlying error for diagnostics.

## Separate responsibilities

- Transport and storage sources own mechanics; repositories own policy. Map models only where meaning or lifetime differs.
- Keep mutable caches private behind an actor or another explicit synchronization boundary.
- Inject a clock, `URLSession` configuration, or scheduler only when tests or policy need it.

## Networking details

- Validate the response: status code, content type when it matters, and empty bodies.
- Decode off the main actor; under default main-actor isolation, mark `Decodable` models `nonisolated` (see `swift-concurrency`).
- Set timeouts and cache policy on the request or session deliberately; do not rely on defaults for user-facing latency.
- Never log full request bodies, tokens, or personal data.

## Verify

- Test success, empty data, actionable failure, cancellation, stale data, and ordering or races relevant to the feature.
- Use fake sources or a `URLProtocol` stub registered on a per-test `URLSessionConfiguration`, not a global handler shared by parallel tests.
- Inspect callers for duplicate tasks, lost cancellation, extra actor hops, and assumptions the new contract breaks.
