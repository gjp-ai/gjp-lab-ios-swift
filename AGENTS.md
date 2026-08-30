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
- Feature code belongs in `GJPLab/features/<feature>/`; reusable app code in `GJPLab/common/`; SDK adapters in `GJPLab/integration/`.
- The Xcode project uses file-system synchronized groups, so Swift source added under `GJPLab/` is automatically included in the app target. Do not add manual build-file entries unless that project model changes.

## GJPLab adapter

- Keep screen-local state in `@State`; use `@StateObject` for a screen-owned observable integration. Do not introduce a view model, coordinator, or dependency container as incidental refactoring.
- `ContentView` owns the `NavigationStack` route path. Keep `FeatureRoute` values stable and route feature navigation through it.
- Keep platform, Firebase, and network operations outside leaf views. `URLSessionRepository.execute` owns 15-second request timeouts, JSON formatting, response headers, and cancellation propagation.
- Route Firebase calls through `FirebaseIntegration`; define stable events, Remote Config keys, trace names, and topics in `FirebaseConstants`.
- Keep notification/APNs wiring in `GJPLabAppDelegate` and `integration/firebase/`. Do not log complete FCM tokens or add client-side secrets.
- Preserve the Slate semantic palette in `common/theme/`. Use `LabTheme` roles and `LabMark` instead of raw brand colors or copied vector paths in feature views.
- The deterministic launcher-icon source is `doc/assets/app-icon*.svg`; regenerate PNG variants with `scripts/render_app_icons.swift` rather than editing rendered PNGs by hand.

## Verification

- Build with `xcodebuild -project GJPLab.xcodeproj -scheme GJPLab -configuration Debug -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build`.
- Run the matching `xcodebuild test` command when an iOS Simulator runtime is available. Use device checks for permissions, APNs, lifecycle, and system UI behavior.
- Keep automated checks deterministic; do not depend on a live HTTP endpoint or Firebase project.
- Report commands run and environment prerequisites that prevented relevant verification.
