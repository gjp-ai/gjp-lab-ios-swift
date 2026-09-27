# Concurrency review

Report findings without editing unless a fix is requested. For each, explain the interleaving or timing path that makes it reachable, and order by data corruption, crash, user-visible hang, then resource waste.

## Isolation

- [ ] Each mutable value has one owner: an actor, the main actor, or a documented lock.
- [ ] No main-actor blocking: synchronous I/O, large decoding, or heavy loops on the main actor.
- [ ] Callbacks from frameworks and SDKs hop to the right actor before touching isolated state.
- [ ] `@unchecked Sendable`, `nonisolated(unsafe)`, and `@preconcurrency` each have a stated invariant.

## Tasks

- [ ] Every `Task {}` has an owner that cancels it, or a reason it may outlive its creator.
- [ ] No `Task.detached` without a stated reason.
- [ ] Cancellation is checked in long loops and propagated, not swallowed or converted to generic errors.
- [ ] No state assumptions carried across `await` in actor methods (re-entrancy).
- [ ] Task captures do not create retain cycles for long-lived work.

## Verification

- [ ] Tests control timing (injected clock, awaited expectations) instead of sleeping.
- [ ] Thread Sanitizer has been run on tests covering the touched code, or the gap is reported.
