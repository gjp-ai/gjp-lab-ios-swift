---
name: ios-api-availability
description: "Handle iOS API availability and SDK changes, including deployment targets, if #available and @available checks, deprecated APIs and their replacements, new Xcode or iOS SDK upgrades, and code that must run on older iOS versions. Use when the compiler reports something is deprecated or only available in a newer iOS, when adopting a new Xcode or SDK, when raising or lowering the minimum iOS version, or before using a new API. Not for general build failures (use ios-build-release)."
metadata:
  version: "0.3.0"
---

# iOS API Availability

Keep the app compiling cleanly on the current SDK while running correctly on every iOS version the deployment target allows. Replace deprecated APIs with their documented successors instead of silencing warnings.

Pairs with `ios-build-release` for builds and warnings, `ios-swiftui-patterns` and `ios-platform-privacy` for the APIs being adopted.

## Discover the host project

Record the Xcode and SDK versions (`xcodebuild -version`, `xcrun --sdk iphoneos --show-sdk-version`), each target's `IPHONEOS_DEPLOYMENT_TARGET` (project level and any target overrides), package `platforms`, and existing `#available` and `@available` uses. The deployment target decides which OS versions the code must run on; the SDK decides which APIs compile.

## Select a mode

- **New Xcode or SDK, or a changed deployment target:** [SDK upgrade workflow](references/sdk-upgrade.md).
- **Using a newer API or replacing a deprecated one:** [availability patterns](references/availability-patterns.md).

## Gotchas

- An API newer than the deployment target needs `if #available(iOS N, *)` or an `@available(iOS N, *)` caller, plus a fallback that keeps the feature usable.
- When the deployment target reaches an API's version, remove the now-dead `#available` branch and its fallback.
- A deprecation message usually names the replacement; check the replacement's minimum iOS against the deployment target before switching. Example: `UIScreen.main` (deprecated in iOS 26) is replaced by the screen of the view's window scene or by trait-collection values.
- Keep the deployment target in one place (project level); a test target lower than the app target breaks `@testable import`.
- A new SDK can change default behavior without any code change (for example, standard controls adopting a new visual style); review key screens after upgrading.
- Confirm API names and versions for new or beta SDKs in Apple's documentation or release notes; do not guess.

## Completion contract

- A clean build shows no new availability or deprecation warnings, and none are suppressed.
- Every `#available` branch has a working fallback, and dead checks are removed.
- The deployment target changes only when the user asked, and every target inherits the same value.
- Report the Xcode and SDK versions used, the checks run, and any OS versions not tested.
