# gjp-lab-ios-swift agent guide

This repository is a small iOS learning lab and the practice host for a portable Swift skill library. User instructions define the task; this file defines local project constraints; each skill supplies a reusable workflow for one engineering concern.

## Skill routing

Activate the smallest set of skills that fully covers the request:

| Concern | Skill |
| --- | --- |
| SwiftUI screens, theme, accessibility, adaptive layout, previews, or UI tests | [`ios-swiftui-design`](.agent/skills/ios-swiftui-design/SKILL.md) |
| Feature boundaries, state ownership, navigation, lifecycle, dependency wiring, or restructuring | [`ios-feature-architecture`](.agent/skills/ios-feature-architecture/SKILL.md) |
| Repositories, URLSession, persistence, Swift concurrency, caching, or synchronization | [`ios-data-concurrency`](.agent/skills/ios-data-concurrency/SKILL.md) |
| Permissions, entitlements, Info.plist, notifications, deep links, background work, privacy, or platform security | [`ios-platform-privacy`](.agent/skills/ios-platform-privacy/SKILL.md) |
| Diagnosis, XCTest/Swift Testing, Xcode builds, Swift Package Manager, CI, performance, or release verification | [`ios-quality-build`](.agent/skills/ios-quality-build/SKILL.md) |

- Follow the selected skill's mode routing and load only references relevant to the task.
- This file takes precedence when it differs from a portable skill.
- For cross-cutting work, coordinate selected skills around one user outcome; do not duplicate layers, tests, or verification.
- Improve a portable skill only when observed evidence reveals a lesson that applies beyond this repository.

## Project profile

- Bundle identifier `com.ganjianping.lab.is`; iOS deployment target 26.4; Swift 5; Xcode project `GJPLab.xcodeproj`.
- SwiftUI UI with `NavigationStack`: `GJPLabApp` → splash/maintenance/dashboard → category catalogue → feature screen.
- Folder names are lowercase and do not repeat their parent (`httpclient/urlsession`, not `httpclient/httpurlsession`). Layout:

| Path | Contents |
| --- | --- |
| `GJPLab/app/` | `GJPLabApp`, `GJPLabAppDelegate`, and root `ContentView`; `startup/` holds splash and maintenance |
| `GJPLab/navigation/` | `FeatureRoute`; `dashboard/` (`MainScreen`) and `catalog/` (catalogue screen and models) |
| `GJPLab/features/<category>/` | Category-level `<Category>Route` / `<Category>Catalog` when a category needs them |
| `GJPLab/features/<category>/<feature>/` | Screens and controllers, with `data/` and `model/` subfolders as needed |
| `GJPLab/sdk/` | SDK bootstrap and adapters (e.g. `sdk/firebase/`); distinct from the `features/integration/` dashboard category |
| `GJPLab/common/` | Reusable app code: `config/`, `theme/` |
| `GJPLab/` root | Asset catalog, `GoogleService-Info.plist`, and entitlements only; no Swift source |

- The Xcode project uses file-system synchronized groups, so Swift source added under `GJPLab/` is automatically included in the app target. Do not add manual build-file entries unless that project model changes. The only hardcoded source paths are the `CODE_SIGN_ENTITLEMENTS` build settings; update them if entitlements move.
- Architecture, design-system, integration, and per-feature requirement/design notes live in `doc/`. Update the matching doc when a change moves files or alters documented behavior.

## Adding a feature

1. Add the screen under `features/<category>/<feature>/`.
2. Add a `FeatureRoute` case (or a case on the category's nested route, such as `SecurityRoute`) and its destination in `ContentView`.
3. Add or enable the catalogue entry (`DashboardCategory.items` or the category's `<Category>Catalog`).
4. Add previews, and a UI test when the feature is reachable from the dashboard.

## GJPLab adapter

- Keep screen-local state in `@State`; use `@StateObject` for a screen-owned observable integration. Do not introduce a view model, coordinator, or dependency container as incidental refactoring.
- `ContentView` owns the `NavigationStack` route path. Keep `FeatureRoute` values stable and route feature navigation through it.
- Keep platform, Firebase, and network operations outside leaf views. `URLSessionRepository.execute` owns 15-second request timeouts, JSON formatting, response headers, and cancellation propagation.
- Route Firebase calls through `FirebaseIntegration`; define stable events, Remote Config keys, trace names, and topics in `FirebaseConstants`.
- Keep notification/APNs wiring in `GJPLabAppDelegate` and `sdk/firebase/`. Do not log complete FCM tokens or add client-side secrets.
- `GoogleService-Info.plist` is Firebase client configuration, not a secret; do not edit or regenerate it unless asked.
- The Info.plist is generated (`GENERATE_INFOPLIST_FILE = YES`). Add usage descriptions and plist keys as `INFOPLIST_KEY_*` build settings in both Debug and Release; do not add an `Info.plist` file. Keep `GJPLab.Debug.entitlements` and `GJPLab.Release.entitlements` in sync unless a difference is intentional.
- Preserve the Slate semantic palette in `common/theme/`. Use `LabTheme` roles and `LabMark` instead of raw brand colors or copied vector paths in feature views.
- Editable launcher-icon SVGs live in `resources/design/app-icons/`; regenerate PNG variants with `scripts/render_app_icons.swift` rather than editing rendered PNGs by hand.

## Verification

- Build with `xcodebuild -project GJPLab.xcodeproj -scheme GJPLab -configuration Debug -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build`.
- Run tests when an iOS Simulator runtime is available: `xcodebuild -project GJPLab.xcodeproj -scheme GJPLab -destination 'platform=iOS Simulator,name=<device>' CODE_SIGNING_ALLOWED=NO test`, choosing `<device>` from `xcrun simctl list devices available`. Add `-only-testing:GJPLabTests` for a fast unit-only run. Use device checks for permissions, APNs, lifecycle, and system UI behavior.
- Keep automated checks deterministic; do not depend on a live HTTP endpoint or Firebase project.
- Report commands run and environment prerequisites that prevented relevant verification.
