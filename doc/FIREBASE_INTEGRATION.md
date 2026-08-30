# Firebase integration

GJPLab uses Firebase Apple SDK `12.17.0` through Swift Package Manager. The app is configured for the Firebase project identified by the checked-in `GJPLab/GoogleService-Info.plist`.

## Included Firebase products

The app target links these Swift Package Manager products from `https://github.com/firebase/firebase-ios-sdk`:

- `FirebaseCore`
- `FirebaseAnalytics`
- `FirebaseCrashlytics`
- `FirebaseMessaging`
- `FirebasePerformance`
- `FirebaseRemoteConfig`

The package resolution file is stored at `GJPLab.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved`.

The app target also sets the `-ObjC` linker flag required by the Crashlytics and Performance Monitoring setup.

## Startup configuration

`GJPLab/GJPLabAppDelegate.swift` is attached to the SwiftUI app through `UIApplicationDelegateAdaptor`. It delegates SDK startup to `GJPLab/integration/AppSDKBootstrapper.swift`, which registers `FirebaseStartupIntegration` and can accept additional SDK integrations without expanding the app delegate.

On launch, the Firebase startup integration:

1. calls `FirebaseApp.configure()` using `GoogleService-Info.plist`;
2. logs the `app_started` Analytics event;
3. stores the app version as a Crashlytics custom value;
4. configures Remote Config with a zero-second debug fetch interval, a one-hour release fetch interval, and a safe `gjp_lab_maintenance_enabled = false` default;
5. sets the Messaging delegate and registers for APNs notifications.

The plist contains Firebase client configuration identifiers, not server credentials. Keep service-account keys, APNs private keys, and other server secrets out of the repository.

## Feature demonstrations

`GJPLab/integration/firebase/FirebaseIntegration.swift` is the service boundary used by `FirebaseFeatureScreen`.

### Analytics

The Firebase screen logs `feature_firebase_opened` through `Analytics.logEvent`. The name intentionally avoids Firebase's reserved `firebase_`, `google_`, and `ga_` prefixes. The same service logs `app_started` during application startup.

### Crashlytics

The demo records a non-fatal `NSError` with `Crashlytics.crashlytics().record(error:)`, adds a log entry, and sets a `firebase_demo` custom key. It does not intentionally crash the app.

For production Crashlytics symbolication, add the Firebase Crashlytics “Run Script” build phase that uploads dSYM files. The required script is provided by the Firebase package/Xcode integration and should run after the app is built.

### Remote Config

The demo calls `RemoteConfig.remoteConfig().fetchAndActivate()` and reads the boolean `gjp_lab_maintenance_enabled` parameter. Configure that parameter in the Firebase console when testing maintenance mode.

The local default is `false`, so a network or fetch failure does not put the app into maintenance mode automatically.

### Performance Monitoring

Firebase Performance automatically collects supported app lifecycle, rendering, and HTTP/S network metrics after `FirebaseApp.configure()`. The Firebase screen additionally starts a custom `firebase_demo_trace` trace, waits briefly, and stops it.

Performance data is batched, so console results may not appear immediately. Use the `-FIRDebugEnabled` launch argument when debugging SDK collection in Xcode.

### Cloud Messaging

The app requests notification permission once during startup, registers with APNs, assigns the APNs token to `Messaging.messaging().apnsToken`, and implements `MessagingDelegate` for refreshed FCM tokens. The Firebase screen can fetch the current FCM token and subscribe to `gjp_lab_demo`.

To receive notifications on a physical device:

1. Enable the Push Notifications capability for the app target.
2. Upload an APNs authentication key or certificate in Firebase Console > Project Settings > Cloud Messaging.
3. Run on a physical Apple device; simulator support is not sufficient for APNs delivery.
4. Grant notification permission when prompted.

## Verification

Build the app target without signing:

```bash
xcodebuild -project GJPLab.xcodeproj \
  -scheme GJPLab \
  -sdk iphonesimulator \
  -configuration Debug \
  -derivedDataPath /tmp/gjplab-derived \
  CODE_SIGNING_ALLOWED=NO build
```

For runtime verification, run on a device or simulator and use the Firebase console:

- Analytics: DebugView should show `app_started` and `feature_firebase_opened`.
- Crashlytics: the non-fatal demo appears after the next app launch; symbol upload is needed for readable production stacks.
- Remote Config: the fetched value should match `gjp_lab_maintenance_enabled` in the console.
- Performance: the custom trace appears after Firebase batches and uploads data.
- Messaging: the token request should succeed on a configured device, and topic subscription should complete.

## Official references

- [Add Firebase to your Apple project](https://firebase.google.com/docs/ios/setup)
- [Analytics events](https://firebase.google.com/docs/analytics/ios/events)
- [Crashlytics for Apple platforms](https://firebase.google.com/docs/crashlytics/ios/get-started)
- [Remote Config for iOS](https://firebase.google.com/docs/remote-config/ios/get-started)
- [Performance Monitoring for Apple platforms](https://firebase.google.com/docs/perf-mon/get-started-ios)
- [Cloud Messaging for Apple platforms](https://firebase.google.com/docs/cloud-messaging/ios/get-started)
