# Architecture review

- Trace every mutable source to rendering and each user event back to its responsible owner.
- Check duplicated state, invalid state combinations, stale captures, repeated effects, and navigation encoded as durable state.
- Inspect navigation paths, deep links, scene changes, restoration, dependency scopes, and framework/data leakage into view contracts.
- Distinguish layers that contain reusable policy from layers that only forward calls.
- Report concrete findings by user impact and regression risk; distinguish defects from optional simplification and label unverified lifecycle paths.
