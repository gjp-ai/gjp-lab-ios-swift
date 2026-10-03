# 0003: SDK code lives in `features/integration/<sdk>/`

Status: Accepted, 2026-10-03

## Context

Firebase code was split between a top-level `sdk/firebase/` folder (startup, messaging, service boundary, constants) and `features/integration/firebase/` (the lab screen). Readers learning one SDK had to look in two places, and the docs lived under the feature while describing both.

## Decision

All code for one SDK lives in `features/integration/<sdk>/`. `AppSDKBootstrapper`, which lists the SDKs started at launch, lives in `app/` because only `GJPLabAppDelegate` calls it. The top-level `sdk/` folder is removed.

## Consequences

- One folder, and one pair of specs, covers everything about an SDK.
- Adding an SDK means a new `features/integration/<sdk>/` folder plus one line in `AppSDKBootstrapper`.
- The app shell depends on this feature folder: startup reads Remote Config for maintenance mode, and the app delegate starts Firebase and forwards APNs callbacks. Unlike other features, the Firebase folder cannot be deleted on its own. This is acceptable because Firebase is itself a subject of the lab.
- APNs and notification wiring stays in `GJPLabAppDelegate` and `features/integration/firebase/`.
