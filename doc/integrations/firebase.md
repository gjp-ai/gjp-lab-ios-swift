# Firebase integration

Status: Implemented lab integration

## Scope

GJPLab connects application ID `com.ganjianping.lab.is` to Firebase Analytics, Remote Config, Crashlytics, Performance Monitoring, and Cloud Messaging. It is intentionally small and demonstrative, not a production observability or security blueprint.

## Architecture

```mermaid
flowchart TD
    App[GJPLabApp] --> Delegate[GJPLabAppDelegate]
    Delegate --> Bootstrapper[AppSDKBootstrapper]
    Bootstrapper --> Startup[FirebaseStartupIntegration]
    Startup --> Analytics
    Startup --> RemoteConfig
    Startup --> Crashlytics
    Startup --> Performance
    Startup --> Messaging
    App --> Integration[FirebaseIntegration]
    FirebaseScreen[FirebaseFeatureScreen] --> Integration
    MessagingHandler[FirebaseMessagingHandler] --> Messaging
```

`GJPLabAppDelegate` delegates process-level setup to `AppSDKBootstrapper`. `FirebaseStartupIntegration` configures Firebase once, while `FirebaseIntegration` is the screen-facing service boundary. `FirebaseMessagingHandler` owns Messaging and foreground-notification delegate callbacks.

## Build configuration

| Concern | Source of truth |
| --- | --- |
| Firebase client configuration | [`GoogleService-Info.plist`](../../GJPLab/GoogleService-Info.plist) |
| Firebase package pin | [`Package.resolved`](../../GJPLab.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved) |
| Swift packages / linker flags | [`project.pbxproj`](../../GJPLab.xcodeproj/project.pbxproj) |
| Push entitlement | [`GJPLab.Debug.entitlements`](../../GJPLab/GJPLab.Debug.entitlements) and release counterpart |

Do not copy package versions into this guide; inspect the resolved package when exact versions matter.

## Stable contracts

[`FirebaseConstants`](../../GJPLab/integration/firebase/FirebaseConstants.swift) owns names that must remain stable across app code and Firebase configuration:

| Service | Contract |
| --- | --- |
| Analytics | `app_started`, `feature_firebase_opened` |
| Crashlytics | `app_version`, `firebase_demo` |
| Remote Config | `gjp_lab_maintenance_enabled` |
| Performance | `firebase_demo_trace` |
| Messaging | Topic `gjp_lab_demo` |

Renaming one of these values is an integration change and must update configuration, tests, and documentation together.

## Service behavior

### Analytics

Startup logs `app_started`; the Firebase screen logs `feature_firebase_opened`. Do not add credentials, full identifiers, or personal information as event parameters.

### Remote Config

Startup sets a zero debug fetch interval, one-hour release interval, and `gjp_lab_maintenance_enabled = false` local default. `fetchMaintenanceMode()` calls `fetchAndActivate()` and returns the current Boolean. It does not distinguish a fresh value, cached value, or failed fetch with an active/default value; [the splash detailed design](../detail-design/splash-screen.md) documents the resulting fallback behavior.

### Crashlytics

Startup records the app version under `app_version`. The Firebase lab can write a non-sensitive log, set `firebase_demo = true`, and record a non-fatal `NSError`; it does not deliberately crash the app. Production symbolication needs the Firebase Crashlytics dSYM upload build phase.

### Performance Monitoring

Firebase Performance automatically collects supported app, rendering, and network metrics after configuration. The lab also records a short `firebase_demo_trace`; all real traces must stop on every completion path. Use `-FIRDebugEnabled` for SDK collection diagnosis.

### Cloud Messaging

Startup configures the Messaging delegate, requests notification authorization, registers APNs after authorization, and assigns the APNs token to Firebase Messaging. The feature screen can fetch the FCM token and subscribe to `gjp_lab_demo`.

For physical-device delivery, enable Push Notifications, upload an APNs key/certificate in Firebase Console, and grant notification authorization. Do not put sending credentials, service accounts, or APNs private keys in the app.

## Lab screen

The Firebase feature exposes controlled actions for Analytics, non-fatal Crashlytics, Remote Config, a custom performance trace, FCM token retrieval/copying, and demo-topic subscription. These are learning/setup controls, not production user-facing behavior.

## Privacy and security notes

- `GoogleService-Info.plist` is client configuration, not server authority; protect Firebase resources with service-specific controls.
- The implementation logs only the FCM-token length on refresh, but the lab screen can retrieve and copy the full token. Clipboard exposure is demo-only behavior.
- Push payloads must not include secrets or sensitive personal data.
- Service accounts, server keys, OAuth secrets, APNs private keys, and App Check debug tokens must remain outside version control.

## Verification

```bash
xcodebuild -project GJPLab.xcodeproj -scheme GJPLab -configuration Debug \
  -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

Runtime checks should cover Analytics DebugView, enabled/disabled/failed Remote Config, non-fatal Crashlytics delivery, custom trace upload, notification grant/denial, and FCM token/topic behavior. APNs delivery needs a configured physical device. Firebase console data can be delayed.

## Known limitations

| Limitation | Impact |
| --- | --- |
| Remote Config API returns only a Boolean | Callers cannot distinguish fresh, cached, default, or failed value |
| Startup authorization request is automatic | Notification timing is not tied to a user action |
| No Firebase emulator-backed tests | Integration confidence depends on manual/device checks |
| No Crashlytics dSYM upload phase documented in project build config | Release crash stacks may not symbolicate until configured |

## Official references

- [Add Firebase to Apple projects](https://firebase.google.com/docs/ios/setup)
- [Analytics events](https://firebase.google.com/docs/analytics/ios/events)
- [Crashlytics](https://firebase.google.com/docs/crashlytics/ios/get-started)
- [Remote Config](https://firebase.google.com/docs/remote-config/ios/get-started)
- [Performance Monitoring](https://firebase.google.com/docs/perf-mon/get-started-ios)
- [Cloud Messaging](https://firebase.google.com/docs/cloud-messaging/ios/client)
