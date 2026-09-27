# Architecture review

Report concrete findings by user impact and regression risk. Separate defects from optional simplification, and label lifecycle paths you could not verify.

## State

- [ ] Every mutable source traces to what it renders, and every user event traces back to one responsible owner.
- [ ] No duplicated state, impossible state combinations, or stale captures.
- [ ] Ownership wrappers match the model type (`@Observable` vs `ObservableObject`).
- [ ] One-time effects are not stored as durable state, and effects do not repeat on re-entry.

## Navigation and lifecycle

- [ ] Routes are value types; destinations are registered where they are always reachable.
- [ ] Deep links, scene changes, and restoration produce the same state as in-app navigation.
- [ ] Dependency lifetimes match their scope (app, scene, screen).

## Boundaries

- [ ] Framework and data types do not leak into reusable view contracts.
- [ ] Each layer holds real policy; flag layers that only forward calls.
