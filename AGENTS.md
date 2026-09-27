# AGENTS.md

## Your Role
- You are an experienced engineer specialized in Swift and familiar with the platform-specific details of iOS.
- You implement features and fix bugs.
- Your documentation and explanations are written for less experienced developer to ease understanding.

## Project Overview

GJPLab is an iOS lab for practising iOS features and third-party libraries, grouped into dashboard categories (SwiftUI, HTTP Client, Security, Integration, Others).

## Tech Stack

- Swift 5 and SwiftUI; iOS 26.6 deployment target, set once at project level (do not override it per target); bundle id `com.ganjianping.lab.is`.
- Concurrency: default `MainActor` isolation with approachable concurrency enabled; mark off-main work `nonisolated` or `@concurrent`.
- `GJPLab.xcodeproj` uses file-system synchronized groups: Swift files under `GJPLab/` join the app target automatically. Only `CODE_SIGN_ENTITLEMENTS` hardcodes source paths.
- Firebase (Analytics, Crashlytics, Messaging, Performance, Remote Config) via Swift Package Manager.
- Tests: Swift Testing in `GJPLabTests`; XCUITest in `GJPLabUITests`.

## Commands

- Build: `xcodebuild -project GJPLab.xcodeproj -scheme GJPLab -configuration Debug -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build`
- Test: `xcodebuild -project GJPLab.xcodeproj -scheme GJPLab -destination 'platform=iOS Simulator,name=<device>' CODE_SIGNING_ALLOWED=NO test`. Get `<device>` from `.agent/skills/ios-build-release/scripts/pick-simulator.sh` (it times out instead of hanging); add `-only-testing:GJPLabTests` for unit tests only.
- App icons: `swift scripts/render_app_icons.swift` from the repository root.

## Directory Structure

Folder names are lowercase and do not repeat their parent (`httpclient/urlsession`).

| Path | Contents |
| --- | --- |
| `GJPLab/app/` | `GJPLabApp`, `GJPLabAppDelegate`, root `ContentView`; `startup/` holds splash and maintenance |
| `GJPLab/navigation/` | `FeatureRoute`; `dashboard/` (`MainScreen`); `catalog/` (catalogue screen and models) |
| `GJPLab/features/<category>/<feature>/` | Screens and controllers, with `data/` and `model/` as needed; `<Category>Route` / `<Category>Catalog` sit in `<category>/` |
| `GJPLab/sdk/` | SDK bootstrap and adapters (`sdk/firebase/`); not the `features/integration/` category |
| `GJPLab/common/` | Shared `config/` and `theme/` |
| `GJPLab/` root | Assets, `GoogleService-Info.plist`, entitlements; no Swift source |
| `doc/` | `architecture/`, plus requirement and detailed-design docs that mirror code paths (`doc/features/<category>/<feature>/`) |
| `resources/design/app-icons/` | Editable app-icon SVG sources |

## Architecture

- Flow: `GJPLabApp` → splash/maintenance → dashboard → category catalogue → feature screen.
- `ContentView` owns the `NavigationStack` path. Route all feature navigation through `FeatureRoute` and keep existing cases stable.
- `@State` for screen state; `@StateObject` for a screen-owned observable integration. Do not add view models, coordinators, or dependency containers as incidental refactoring.
- Views do not call network, platform, or SDK APIs directly. Use the feature repository (`URLSessionRepository.execute` owns 15-second timeouts, JSON formatting, response headers, and cancellation) or `FirebaseIntegration`. APNs and notification wiring stays in `GJPLabAppDelegate` and `sdk/firebase/`.
- To add a feature, follow [Adding a feature](doc/architecture/application.md#adding-a-feature). Details: [application architecture](doc/architecture/application.md).

## Coding Standards

- Follow the closest existing feature and match the surrounding code.
- Use the Slate palette through `LabTheme` roles and `LabMark`; no raw brand colors or copied vector paths in feature views.
- Define Firebase events, Remote Config keys, trace names, and topics in `FirebaseConstants`.
- Info.plist is generated: add keys as `INFOPLIST_KEY_*` build settings in both Debug and Release.

## Boundaries

- **Always:** build before reporting done; keep tests deterministic (no live HTTP endpoint or Firebase project); update the matching `doc/` page when files move or documented behavior changes; report commands run and what was not verified (permissions, APNs, lifecycle, and system UI need a device).
- **Ask first:** new dependencies; entitlement, capability, or signing changes (keep `GJPLab.Debug.entitlements` and `GJPLab.Release.entitlements` in sync); manual project-file entries.
- **Never:** log complete FCM tokens or add client-side secrets; edit or regenerate `GoogleService-Info.plist` unless asked (it is client config, not a secret); add an `Info.plist` file; hand-edit rendered app-icon PNGs.

## Skills

Load the smallest set that covers the task, follow its mode routing, and load only the references you need. For cross-cutting work, coordinate skills around one outcome without duplicating layers, tests, or verification.

| Concern | Skill |
| --- | --- |
| Deployment target, `#available`, deprecated APIs, or Xcode/SDK upgrades | [`ios-api-availability`](.agent/skills/ios-api-availability/SKILL.md) |
| Feature boundaries, state ownership, navigation, lifecycle, dependency wiring, restructuring, or modularization | [`ios-architecture`](.agent/skills/ios-architecture/SKILL.md) |
| SwiftUI screens, theme, accessibility, localization, adaptive layout, UIKit interop, or previews | [`ios-swiftui-patterns`](.agent/skills/ios-swiftui-patterns/SKILL.md) |
| async/await, actors, MainActor isolation, Sendable, data races, or Swift 6 migration | [`swift-concurrency`](.agent/skills/swift-concurrency/SKILL.md) |
| Repositories, URLSession, JSON, persistence, caching, or synchronization | [`ios-data-layer`](.agent/skills/ios-data-layer/SKILL.md) |
| Swift Testing, XCTest, XCUITest, test doubles, or failing and flaky tests | [`ios-testing`](.agent/skills/ios-testing/SKILL.md) |
| Build failures and warnings, crashes, simulator hangs, SPM, signing, CI, or release checks | [`ios-build-release`](.agent/skills/ios-build-release/SKILL.md) |
| Permissions, entitlements, Info.plist, privacy manifests, Keychain, notifications, deep links, background work, or platform security | [`ios-platform-privacy`](.agent/skills/ios-platform-privacy/SKILL.md) |
| Commit all changes and push the current branch | [`commit-push`](.agent/skills/commit-push/SKILL.md) |
