# Application architecture

Status: Implemented snapshot, 2026-09-27

## Purpose

GJPLab is a single-target iOS learning application. It favors small, readable feature slices over production-scale abstraction: SwiftUI renders the interface, a `NavigationSplitView` driven by selection state handles navigation, feature views own small local state, repositories isolate data mechanics, and each external SDK keeps all its code in one `features/integration/<sdk>/` folder.

## Runtime flow

```mermaid
flowchart LR
    Launch[iOS launch screen] --> App[GJPLabApp]
    App --> Splash[SplashScreen]
    Splash -->|3-second minimum + config result| Sidebar[ContentView / CategorySidebar]
    Splash -->|maintenance enabled| Maintenance[MaintenanceScreen]
    Sidebar --> Catalog[FeatureCatalogScreen]
    Catalog --> Device[DeviceInfoScreen]
    Catalog --> HTTP[URLSessionScreen]
    Catalog --> Firebase[FirebaseFeatureScreen]
    HTTP --> Response[HttpResponseScreen]
    Catalog --> Calls[BlockAppDuringCallsScreen]
    Calls --> Overlay[CallBlockingOverlay]
```

[`GJPLabApp`](../../GJPLab/app/GJPLabApp.swift) is the SwiftUI entry point. It attaches [`GJPLabAppDelegate`](../../GJPLab/app/GJPLabAppDelegate.swift) for SDK lifecycle callbacks, coordinates splash timing and maintenance mode, then chooses the main navigation or the maintenance screen. [`ContentView`](../../GJPLab/app/ContentView.swift) owns the `NavigationSplitView` and its selection state.

## Code organization

| Path | Responsibility |
| --- | --- |
| `GJPLab/app/` | App entry point, app delegate, `AppSDKBootstrapper` (SDKs started at launch), and the root `ContentView` that owns the route path |
| `GJPLab/app/startup/` | Splash and maintenance screens |
| `GJPLab/app/navigation/` | `navigation.json` and its decoder `NavigationMenu`; `FeatureRoute` (topic selection) and `DetailRoute` (pushes inside the feature column); category sidebar (`CategorySidebar`) and catalogue (`FeatureCatalogScreen`) |
| `GJPLab/features/<category>/<feature>/` | Feature views and controllers |
| `GJPLab/features/integration/firebase/` | Firebase lab screen, constants, startup, messaging, and service boundary. Startup and the app delegate depend on it, so unlike other features it cannot be removed on its own |
| `GJPLab/common/config/` | Stable application behavior constants |
| `GJPLab/common/theme/` | Slate semantic colors, reusable surface treatment, and brand mark |
| Root `GJPLab/` | Asset catalog, `GoogleService-Info.plist`, and Debug/Release entitlements only |

New code should follow the closest feature pattern. Reusable app behavior belongs in `common/`; SDK-specific behavior belongs in that SDK's `features/integration/<sdk>/` folder, registered in `AppSDKBootstrapper`. Folder names are lowercase and do not repeat their parent (`httpclient/urlsession`, not `httpclient/httpurlsession`).

### Adding a feature

1. Write `doc/specs/features/<category>/<feature>/<feature>_requirement.md` from the [requirement template](../templates/requirement.md); add `<feature>_detail_design.md` beside it from the [detail design template](../templates/detail_design.md) when the feature has lifecycle, persistence, integration, platform, or security behavior.
2. Add the screen under `features/<category>/<feature>/`.
3. Add a `FeatureRoute` case and its view in `ContentView.feature(for:)`; screens that push further add a `DetailRoute` case.
4. In `app/navigation/navigation.json`, add the topic to its category, or give a planned topic a `"route"` equal to the new case's name. The unit tests fail if a route is missing from the JSON, listed twice, or misspelled.
5. Add previews (light, dark, and iPad where layout adapts), and a UI test when the feature is reachable from the catalogue.

## Dependency and event flow

```mermaid
flowchart TD
    App[GJPLabApp] --> Delegate[GJPLabAppDelegate]
    Delegate --> Bootstrapper[AppSDKBootstrapper]
    Bootstrapper --> FirebaseStartup[FirebaseStartupIntegration]
    Content[ContentView] --> Selection[Selected category and topic]
    Content --> Path[Feature column path]
    Sidebar[CategorySidebar] --> Catalog[FeatureCatalogScreen]
    Feature[Feature view] --> Repository[Repository or FirebaseIntegration]
    Repository --> Feature
```

- `GJPLabAppDelegate` owns process-level SDK callbacks and forwards them through `AppSDKBootstrapper`.
- `ContentView` owns navigation state: the selected `NavigationCategory` (from `navigation.json`), the selected `FeatureRoute`, and a `[DetailRoute]` path for the feature column.
- Views own private presentation state with `@State`. `GJPLabApp` owns, with `@StateObject`, the `FirebaseIntegration` used for the splash maintenance lookup and the shared call-blocking controller; `FirebaseFeatureScreen` owns its own `FirebaseIntegration` for the lab screen.
- `URLSessionRepository` performs request mechanics; views present state and invoke explicit actions.

## State and lifecycle model

The project intentionally uses SwiftUI-local state instead of a dedicated view-model layer. This keeps the lab readable but has limits:

- `@State` is view-lifetime state, not durable persistence or cross-screen shared state.
- App startup state lives in `GJPLabApp`; recreating the scene can repeat startup work.
- Navigation selection and the feature-column path are memory-backed and are not restored after termination.
- Feature state is intentionally isolated unless a requirement proves it must be shared.

Do not introduce a view model, coordinator, dependency container, domain layer, or module split as incidental refactoring. Add one only for a demonstrated requirement and include migration coverage.

## Platform and security boundaries

Push notification/APNs lifecycle callbacks reside in `GJPLabAppDelegate` and `features/integration/firebase/`. App capabilities are declared in `GJPLab.Debug.entitlements` and `GJPLab.Release.entitlements`; launch-screen configuration is generated from target build settings. Network behavior uses Apple transport security defaults—do not add exceptions or custom trust behavior merely to make a sample endpoint work.

Firebase client configuration in `GoogleService-Info.plist` is not server authority. Service accounts, APNs private keys, OAuth secrets, App Check debug tokens, and FCM server credentials must not enter the application or repository.

## Build and verification

| Setting | Value |
| --- | --- |
| Toolchain | Xcode 27.0 (iOS 27 SDK); Swift 5 language mode |
| Deployment target | iOS 26.6, set once at project level; no target overrides |
| Concurrency | `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor`, approachable concurrency enabled |
| Project model | File-system synchronized groups; Firebase Apple SDK through Swift Package Manager |
| Warning baseline | A clean build has zero warnings; keep it that way |

```bash
xcodebuild -project GJPLab.xcodeproj -scheme GJPLab -configuration Debug \
  -destination 'generic/platform=iOS Simulator' -derivedDataPath build/DerivedData \
  CODE_SIGNING_ALLOWED=NO build

DEVICE=$(.agent/skills/ios-build-release/scripts/pick-simulator.sh)
xcodebuild -project GJPLab.xcodeproj -scheme GJPLab \
  -destination "platform=iOS Simulator,name=$DEVICE" -derivedDataPath build/DerivedData \
  CODE_SIGNING_ALLOWED=NO \
  -only-testing:GJPLabTests test
```

Drop `-only-testing` to include UI tests. Use a physical device for APNs, authorization prompts, CallKit, and system lifecycle fidelity.

## Known architectural constraints

| Constraint | Consequence | Revisit when |
| --- | --- | --- |
| One app target | Fast discovery; weak compile-time feature boundaries | Build time or ownership becomes a problem |
| View-local state | Low ceremony; limited restoration and sharing guarantees | State must outlive a view or scene |
| In-memory navigation selection | Clear small-app routing; no durable restoration | Deep links or restoration become product requirements |
| Firebase callbacks/adapters | Small API surface; limited result detail and cancellation | Callers need richer structured outcomes |
| Minimal automated tests (call-blocking controller only) | Fast experimentation; startup, networking, and Firebase paths are unguarded | Behavior becomes important to preserve |

See [Slate design system](../specs/common/theme/theme_detail_design.md), [sidebar detailed design](../specs/app/navigation/sidebar_detail_design.md), [catalogue detailed design](../specs/app/navigation/catalog_detail_design.md), [OS & hardware detailed design](../specs/features/others/deviceinfo/deviceinfo_detail_design.md), [maintenance detailed design](../specs/app/startup/maintenance_detail_design.md), [URLSession detailed design](../specs/features/httpclient/urlsession/urlsession_detail_design.md), [splash detailed design](../specs/app/startup/splash_detail_design.md), [call-blocking detailed design](../specs/features/security/blockappduringcalls/blockappduringcalls_detail_design.md), and [Firebase integration](../specs/features/integration/firebase/firebase_detail_design.md) for feature-specific detail.
