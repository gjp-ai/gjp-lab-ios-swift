# SDK upgrade workflow

Use when the project moves to a new Xcode or iOS SDK, or when the deployment target changes.

## Baseline

1. Record the old and new Xcode, SDK, and Swift versions, and each target's deployment target.
2. Clean-build with a result bundle and list every error and warning (`xcrun xcresulttool get build-results`). Clean builds matter: incremental builds hide warnings in unchanged files.

## Triage by category

| Category | Action |
| --- | --- |
| Removed or changed API (errors) | Adopt the documented replacement; keep behavior identical |
| Deprecations | Replace using the message and docs; gate with `#available` if the replacement is newer than the deployment target |
| Concurrency diagnostics after a Swift or setting change | Follow `swift-concurrency` |
| "Unnecessary" checks or markers (for example, `await` with no async work, always-true `#available`) | Remove them |
| Package build failures | Update the package only if needed and allowed; see `ios-build-release` |

Fix one category at a time and rebuild between them.

## Deployment-target changes

- Change it only when asked. Set it once at project level and remove per-target overrides so app, extensions, and tests match.
- Raising it: delete `#available` branches and fallbacks that are now always true.
- Lowering it: every API newer than the new target needs a check and a fallback; the compiler lists them.

## Verify

- Clean build with zero new warnings; run unit tests (and UI tests when UI changed).
- Look at key screens in light and dark mode for default-behavior changes from the new SDK.
- If the deployment target is below the SDK version, run on a simulator with the oldest supported iOS, or report that it was not tested.
