# Feature workflow

## Define the vertical slice

- Describe the entry point, successful outcome, recoverable failures, back/exit behavior, and any deep-link contract.
- Identify the existing owners of UI, state, data, navigation, and dependencies. Prefer extending the nearest feature pattern.

## Model state and effects

- Represent only product-reachable states. Make mutually exclusive states explicit when it prevents impossible combinations.
- Keep durable view state separate from transient navigation, alert, sheet, haptic, and authorization effects.
- Put state in the lowest owner satisfying sharing and lifetime requirements: view-local state, a parent route, an observable feature model, or durable storage.
- Use `SceneStorage` or `AppStorage` only for small values whose restoration/lifetime contract is clear; reload durable data from its source of truth.

## Wire boundaries and verify

1. Establish route, state, and event contracts.
2. Construct dependencies at the project's established composition boundary.
3. Connect data and platform adapters without leaking them into reusable UI contracts.
4. Test state transitions and critical navigation/lifecycle behavior at the cheapest useful layer.
5. Build the affected scheme and exercise back navigation, re-entry, scene phase, and restoration when relevant.
