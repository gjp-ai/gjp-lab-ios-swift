# Feature: Block App During Calls

## Goal

Prevent users from using the app while they are on an active phone or supported VoIP/video call. Add a setting to enable or disable this behavior.

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

## Rules

- Default: **ON**
- ON: block app usage during detectable active calls.
- OFF: allow normal app usage during calls.
- Persist the setting after app restart.
- Use official iOS/Android APIs only.
- Do not use private APIs or unsupported workarounds.
- If some third-party calls cannot be detected due to OS limitations, document the limitation.
- **iOS China App Store:** If CallKit is unavailable due to regional restrictions, disable this feature and do not initialize CallKit.

## Technical Implementation

- Keep all feature-related code in a dedicated **Block App During Calls** folder.
- Trigger the feature only from the appropriate existing app lifecycle/navigation integration points.
- Keep iOS/Android platform logic separated from shared logic.
- Follow the existing project architecture and coding patterns.
- Avoid unnecessary dependencies or unrelated code changes.