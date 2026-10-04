# AGENTS.md

## Your Role

- You are an experienced Swift engineer who knows iOS platform details. You implement features and fix bugs.
- Write code, docs, and explanations for less experienced developers: plain words, one idea per sentence, and the reason behind a rule.

## Project Overview

GJPLab is an iOS app for practising iOS features and third-party libraries, grouped into sidebar categories: Swift, SwiftUI, HTTP Client, Security, Integration, and Others. Swift topics are pages of runnable code samples; SwiftUI topics are pages of live demos; the other categories hold one screen per feature.

It is one of several lab apps (`gjp-lab-android-kotlin`, `gjp-lab-web-react`, and `gjp-lab-cordova` sit beside this repository). The splash and Block App During Calls requirements are shared with the Android app, which keeps its own copy.

## Tech Stack

- Swift 5 language mode and SwiftUI; iOS 26.6 deployment target, set once at project level (never per target); Xcode 27; bundle id `com.ganjianping.lab.is`.
- Concurrency: the app target uses default `MainActor` isolation with approachable concurrency. Mark off-main work `nonisolated` or `@concurrent`. Test targets do not use default isolation, so mark test suites that touch app types `@MainActor`.
- `GJPLab.xcodeproj` uses file-system synchronized groups: Swift files under `GJPLab/`, `GJPLabTests/`, and `GJPLabUITests/` join their target automatically. Only `CODE_SIGN_ENTITLEMENTS` hardcodes source paths.
- Firebase (Analytics, Crashlytics, Messaging, Performance, Remote Config) via Swift Package Manager; `Package.resolved` is committed.
- Tests: Swift Testing in `GJPLabTests`; XCUITest in `GJPLabUITests`.

## Commands

- Build: `xcodebuild -project GJPLab.xcodeproj -scheme GJPLab -configuration Debug -destination 'generic/platform=iOS Simulator' -derivedDataPath build/DerivedData CODE_SIGNING_ALLOWED=NO build`. Add `clean` before `build` when counting warnings; incremental builds hide warnings in unchanged files.
- Unit tests: `xcodebuild -project GJPLab.xcodeproj -scheme GJPLab -testPlan Unit -destination 'platform=iOS Simulator,name=<device>' -derivedDataPath build/DerivedData CODE_SIGNING_ALLOWED=NO test` (about a minute). Get `<device>` from `.agent/skills/ios-build-release/scripts/pick-simulator.sh`, which times out instead of hanging.
- UI tests: the same command with `-testPlan UI` (about 8 minutes). Run them when a change touches screens, navigation, or `navigation.json`. Run one test with `-only-testing:GJPLabUITests/<Suite>/<test>`.
- Test failures: add `-resultBundlePath build/<name>.xcresult`, then read `xcrun xcresulttool get test-results tests --path …`. For a UI failure, `xcrun xcresulttool export attachments --path … --output-path …` saves the screen's accessibility hierarchy at the moment it failed.
- CI: `.github/workflows/ci.yml` builds and runs the `Unit` plan on every push to `main` and every pull request; start it manually with *ui_tests* checked to add the `UI` plan.
- Command-line builds use `build/DerivedData` (git-ignored) so they do not clash with Xcode's own DerivedData ([decision 0001](doc/decisions/0001-separate-derived-data-for-cli-builds.md)). Run one `xcodebuild` at a time against it.
- App icons: `swift scripts/render_app_icons.swift` from the repository root.

## Directory Structure

Folder names are lowercase and do not repeat their parent (`httpclient/urlsession`). Each feature is one flat folder ([decision 0002](doc/decisions/0002-flat-feature-folders.md)).

| Path | Contents |
| --- | --- |
| `GJPLab/app/` | `GJPLabApp`, `GJPLabAppDelegate`, `AppSDKBootstrapper` (SDKs started at launch), root `ContentView`; `startup/` holds splash and maintenance |
| `GJPLab/app/navigation/` | `navigation.json` (sidebar categories and catalogue topics), `NavigationMenu` (its decoder), `FeatureRoute` and `DetailRoute`, `CategorySidebar`, and `FeatureCatalogScreen` |
| `GJPLab/features/<category>/<feature>/` | Screens, controllers, repositories, and models in one flat folder. Categories: `swift/`, `swiftui/`, `httpclient/`, `security/`, `integration/`, `others/` |
| `GJPLab/features/integration/<sdk>/` | All code for one SDK: lab screen, startup integration, service boundary, constants. The app shell uses it, so it is not removable like other features |
| `GJPLab/common/` | `config/` (`AppConfig`), `theme/` (`LabTheme`, `LabMark`, `LabButtonStyle`, `LabDemoPage`), and `codesample/` (the runnable sample card used by Swift topics) |
| `GJPLab/` root | Assets, `GoogleService-Info.plist`, entitlements; no Swift source |
| `GJPLabUITests/UITestSupport.swift` | `launchLab()` and the catalogue helpers every UI test uses |
| `TestPlans/` | `Unit.xctestplan` (default) and `UI.xctestplan`, used by the shared scheme in `GJPLab.xcodeproj/xcshareddata/` |
| `doc/` | `architecture/`, `specs/` (mirrors `GJPLab/`: docs for `GJPLab/<path>/` live in `doc/specs/<path>/`), `templates/`, `decisions/`, and `guides/` (Swift and SwiftUI tutorials). Start at [`doc/README.md`](doc/README.md) |
| `resources/design/app-icons/` | Editable app-icon SVG sources |
| `.github/workflows/` | CI workflow |

## Architecture

- Flow: `GJPLabApp` → splash/maintenance → sidebar → category catalogue → feature screen.
- `ContentView` owns a `NavigationSplitView` driven by selection: sidebar category, catalogue topic (`FeatureRoute`), and a `[DetailRoute]` path for pushes inside a feature. Do not add separate `NavigationStack`s or per-device navigation. A feature pushes with `NavigationLink(value: DetailRoute…)` or by reporting a result through a closure that `ContentView` turns into a push.
- `@State` for screen state; `@StateObject` for a screen-owned observable integration. Do not add view models, coordinators, or dependency containers as incidental refactoring.
- Views do not call network, platform, or SDK APIs directly. Use the feature repository (`URLSessionRepository.execute` owns 15-second timeouts, JSON formatting, response headers, and cancellation) or `FirebaseIntegration`. APNs and notification wiring stays in `GJPLabAppDelegate` and `features/integration/firebase/`.
- Sidebar and catalogue content lives only in `navigation.json`; a topic's `route` string must match a `FeatureRoute` raw value ([decision 0004](doc/decisions/0004-navigation-menu-in-json.md)).
- A Swift topic is a `<Topic>Samples` list of `CodeSample` values plus a small screen; a SwiftUI topic is a `LabDemoPage` of `LabDemoSection` cards ([decision 0006](doc/decisions/0006-topic-pages-and-runnable-samples.md)).
- UI tests launch with `-ui-testing`; `AppConfig.isUITesting` then starts no SDKs and skips the splash ([decision 0005](doc/decisions/0005-ui-testing-launch-mode.md)). A new SDK must be skipped in that mode, and its screen must handle the SDK not being started.
- To add a feature, follow [Adding a feature](doc/architecture/application.md#adding-a-feature).

## Coding Standards

- Follow the closest existing feature and match the surrounding code.
- Use the Slate palette through `LabTheme` roles and `LabMark`; no raw brand colors or copied vector paths in feature views.
- Every screen uses the same background in each appearance: apply `.labScreenBackground()`; a `List` or `Form` also needs `.scrollContentBackground(.hidden)`. Do not leave system grouped or plain list backgrounds visible.
- Main action buttons use `.buttonStyle(.labPrimary)`, never `.borderedProminent` (white text on a white fill in dark mode).
- Every public view has previews, and every preview comes as a pair: `#Preview("<name> – light")` and `#Preview("<name> – dark")` (the dark one adds `.preferredColorScheme(.dark)`). Preview each distinct state (for example available and unavailable).
- Tie async work to the view with `.task` or `.task(id:)`, so leaving the screen cancels it; do not start it from `onAppear { Task { … } }`.
- Keep logic that can be tested out of `body`: a pure function or type in the feature folder (for example `FlowLayout.arrange`, `SignUpForm`).
- Define Firebase events, Remote Config keys, trace names, and topics in `FirebaseConstants`.
- Info.plist is generated: add keys as `INFOPLIST_KEY_*` build settings in both Debug and Release.
- A clean build has zero warnings; fix warnings at their source.

## Known Pitfalls

Each of these has cost a failed build or test in this project:

- `ContentView` has two `switch` statements: `feature(for:)` returns topic screens, and the `navigationDestination` closure handles `DetailRoute`. New topics go in `feature(for:)`.
- `.inspector(isPresented:)` drops a `.navigationTitle` or `.toolbar` set inside it on iPhone; apply them after `.inspector`.
- A `static let` initializer is not main-actor isolated. Passing a main-actor method directly as a closure value there warns; wrap it: `run: { arrays($0) }`.
- `deinit` does not run on the main actor; a class that logs from `deinit` must be `nonisolated`.
- Swift cannot declare a protocol inside a function. Sample types live at file level as `fileprivate`, which also stops names like `Square` or `Circle` clashing with SwiftUI.
- UI tests: rows in a lazy `List` do not exist until scrolled into view, and a partly visible row may not respond to a tap. Use `tapRow(titled:in:)`. Query by `accessibilityIdentifier` or by the row label prefix `"<title>,"`, never by fixed sleeps.

## Documentation

- Every feature has a requirement and a detailed design in `doc/specs/<path>/`, started from `doc/templates/`. Shared behavior is written once in `doc/specs/common/` and linked, not repeated.
- Open work lives in each detailed design's **Known gaps** table; remove a row in the change that fixes it.
- When a change moves files or changes documented behavior, update the matching spec, the [documentation map](doc/README.md#document-map), and the tutorials if they quote the changed code.
- Changes to the splash or Block App During Calls requirements must stay in step with the Android app's copy.
- Add a decision record (next number in `doc/decisions/`) when a change adds or reverses a project-wide choice. Read the existing records before reversing one.
- Check that local Markdown links resolve before handing off.

## Boundaries

- **Always:** build before reporting done; keep tests deterministic (no live HTTP endpoint or Firebase project; UI tests launch through `launchLab()`); update docs as described above; report the commands run, their results, and what was not verified (permissions, APNs, CallKit, lifecycle, and system UI need a device).
- **Ask first:** new dependencies; entitlement, capability, or signing changes (keep `GJPLab.Debug.entitlements` and `GJPLab.Release.entitlements` in sync); manual project-file entries; changes to the shared scheme, test plans, or CI workflow; product behavior changes such as when a permission is requested.
- **Never:** log complete FCM tokens or add client-side secrets; edit or regenerate `GoogleService-Info.plist` unless asked (it is client config, not a secret); add an `Info.plist` file; hand-edit rendered app-icon PNGs; silence warnings or skip tests to make a build pass.

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
