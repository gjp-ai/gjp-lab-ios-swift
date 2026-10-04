# 0005: UI tests run the app in a UI-testing mode

Status: Accepted, 2026-10-04

## Context

UI tests launched the app exactly as a user does. Each launch waited for the three-second splash and a live Remote Config fetch (up to five seconds), configured Firebase against the author's project, and requested notification permission. That made every UI test slow, sent test traffic to a live service against the project rule that tests must not use one, and let the system permission alert block taps on a fresh simulator. Separately, running UI tests on cloned simulators (Xcode's parallel testing) failed twice to launch the test runner.

## Decision

- UI tests launch the app with the `-ui-testing` argument through `launchLab()` in `GJPLabUITests/UITestSupport.swift`.
- `AppConfig.isUITesting` reads it. In that mode `AppSDKBootstrapper` starts no SDKs and `GJPLabApp` skips the splash and the maintenance lookup. Screens that need an SDK check whether it is started (`FirebaseIntegration.isConfigured`) and disable their actions instead of crashing.
- A shared scheme runs two test plans from `TestPlans/`: `Unit` (default) and `UI`, both with parallel execution (simulator clones) turned off.

## Consequences

- UI tests start at the sidebar within seconds, never call live services, and see no system alerts.
- UI tests no longer cover startup (splash, maintenance mode, SDK setup); those stay manual or need their own tests with injected timing and a fake Remote Config.
- New SDK integrations must be skipped in UI-testing mode, and any screen that uses one must handle it not being started.
- `-ui-testing` is defined twice (in `AppConfig` and in `launchLab()`), because UI tests cannot import the app module; change both together.
