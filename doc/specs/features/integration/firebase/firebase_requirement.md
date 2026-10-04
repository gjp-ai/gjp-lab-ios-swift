# Feature: Firebase lab

Status: Implemented

## Goal

Let a developer trigger each Firebase service used by GJP Lab on demand and see the result, to verify the integration and learn how each service behaves.

## Scope

### In scope

- One action per service: Analytics, Crashlytics, Remote Config, Performance Monitoring, and Cloud Messaging.
- A status line per service showing the last result.
- Showing, selecting, and copying the FCM registration token, and subscribing to the demo topic.

### Out of scope

- App startup configuration and the maintenance decision (see the [Firebase detailed design](firebase_detail_design.md) and the [splash requirement](../../../app/startup/splash_requirement.md)).
- Sending push notifications, editing Remote Config values, or viewing console data.
- Forcing a real crash.

## Behavior

- The screen shows the Firebase project ID from the bundled configuration.
- **Log event** sends `feature_firebase_opened`.
- **Record exception** records a non-fatal error with a log line and a `firebase_demo` custom key; the app keeps running.
- **Fetch flag** fetches and activates Remote Config and shows the `gjp_lab_maintenance_enabled` value, or the failure.
- **Run trace** runs the short `firebase_demo_trace` custom trace and shows its duration.
- **Get token** loads the FCM registration token and shows it with a **Copy** button.
- **Subscribe to demo topic** subscribes to `gjp_lab_demo` and shows the result.
- When Firebase is not started (in previews and when UI tests launch the app), the screen says so and every action is disabled, because calling Firebase before it is configured would crash.

## UI & Navigation

- Entry point: **Integration** category → **Firebase** catalogue item.
- Navigation title "Firebase", an introduction, the project ID, one card per service (title, description, status, action button), the token row when loaded, and the subscribe button.
- Content width is limited on iPad; light and dark appearance and Dynamic Type are supported.

## Rules & Constraints

- Event names, keys, trace names, and topics come from `FirebaseConstants`; renaming one is an integration change.
- Actions send no personal data and no event parameters.
- The full FCM token is shown only on this screen and copied only on request; it is never logged.
- No credentials, service accounts, or APNs keys in the app.

## Platform limitations

- Console data (Analytics, Crashlytics, Performance) can take minutes to appear.
- An FCM token requires APNs registration, which needs notification permission; real push delivery needs a physical device.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| FB-AC-01 | Open the screen | The project ID and all five service cards are shown. |
| FB-AC-02 | Tap **Log event** | The Analytics status reports the event was sent. |
| FB-AC-03 | Tap **Record exception** | The Crashlytics status reports a recorded non-fatal; the app does not crash. |
| FB-AC-04 | Tap **Fetch flag** with and without network | The status shows the flag value, or the failure message. |
| FB-AC-05 | Tap **Run trace** | The status shows the trace completed with a duration. |
| FB-AC-06 | Tap **Get token**, then **Copy** | The token is shown, the button reads "Copied", and the pasteboard holds the token. |
| FB-AC-07 | Tap **Subscribe to demo topic** | The Messaging status reports success or the failure. |
| FB-AC-08 | Open the screen in a preview or in a UI test | A notice explains that Firebase is not started, and every action is disabled. |

## Technical implementation constraints

- All Firebase source lives in `GJPLab/features/integration/firebase/`; the screen calls Firebase only through `FirebaseIntegration`.
- The screen owns its own `FirebaseIntegration` instance.
- No new dependencies.

## Related documents

- [Detailed design](firebase_detail_design.md)
- [Application architecture](../../../../architecture/application.md)
