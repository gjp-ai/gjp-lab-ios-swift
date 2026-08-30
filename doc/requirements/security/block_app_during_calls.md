# Feature: Block App During Calls

Status: Implemented

## Goal

Prevent users from using the app while they are on an active phone or supported VoIP/video call. Add a setting to enable or disable this behavior.

## Scope

### In scope

- Detect system-exposed active calls and block the entire app while the feature is enabled.
- Provide the Security catalogue entry, settings screen, persisted preference, and simulated-call verification path.
- Disable monitoring safely for the China App Store storefront.

### Out of scope

- Detecting calls that iOS does not expose through CallKit.
- Placing, answering, recording, or otherwise controlling calls.
- Android implementation details.

## Behavior

- When an active phone call is detected, block access to the app.
- Also detect supported VoIP/video calls such as WhatsApp, WeChat, Telegram, FaceTime, and other calls where the OS provides call-state information.
- Show a full-screen blocking message while the call is active.
- When the call ends, automatically restore normal app access.
- Check the call status when the app launches, returns to the foreground, or the call status changes.

## UI & Navigation

- Add **Block App During Calls** as an item on the existing **Security** page.
- When tapped, navigate to a dedicated **Block App During Calls** page.
- The page should include:
  - An ON/OFF toggle.
  - Current feature status.
  - A test function to simulate and verify the blocking behavior without a real call.
- Follow the existing app design and navigation patterns.

## Rules & constraints

- Default: **ON**
- ON: block app usage during detectable active calls.
- OFF: allow normal app usage during calls.
- Persist the setting after app restart.
- Use official iOS/Android APIs only.
- Do not use private APIs or unsupported workarounds.
- If some third-party calls cannot be detected due to OS limitations, document the limitation.
- **iOS China App Store:** If CallKit is unavailable due to regional restrictions, disable this feature and do not initialize CallKit.

## Platform limitations

- iOS reports only call activity exposed through public CallKit APIs. WhatsApp, WeChat, Telegram, FaceTime, and other providers are detectable only when the operating system makes their call state available.
- The China App Store storefront must never initialize CallKit. A failed storefront lookup must use a safe unavailable state.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| BAC-AC-01 | An active system-exposed call begins while the setting is on | A full-screen message blocks every app route. |
| BAC-AC-02 | The active call ends | The overlay is removed automatically and access is restored. |
| BAC-AC-03 | The setting is off during an active call | The app remains usable. |
| BAC-AC-04 | The app launches or foregrounds during an active call | The call state is refreshed and the overlay appears when applicable. |
| BAC-AC-05 | The user enables the simulated-call test | The same blocking overlay appears without placing a real call. |
| BAC-AC-06 | The App Store storefront is China | The feature reports unavailable and CallKit is not initialized. |

## Technical implementation constraints

- Keep all feature-related code in a dedicated **Block App During Calls** folder.
- Trigger the feature only from the appropriate existing app lifecycle/navigation integration points.
- Keep iOS/Android platform logic separated from shared logic.
- Follow the existing project architecture and coding patterns.
- Avoid unnecessary dependencies or unrelated code changes.

## Related documents

- [Detailed design](../../detail-design/security/block_app_during_calls.md)
- [Application architecture](../../architecture/application.md)
