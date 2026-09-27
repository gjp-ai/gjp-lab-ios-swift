# Authorization workflow

## Minimize the request

- First confirm a system picker (`PhotosPicker`, document picker, contact picker), limited access, or a less sensitive API cannot meet the need.
- Add the exact usage description and entitlement only when the feature needs them. Keep authorization checks next to the protected operation.

## Design the user flow

- Ask in context after the user starts a feature, explaining the benefit before the system prompt.
- Handle not-determined, denied, restricted, limited, provisional, revoked, unavailable, and missing-entitlement states as applicable.
- Keep the feature useful without access where possible. Do not loop prompts or pressure users toward Settings.
- Read the current status right before the protected action; earlier grants can change.

## Privacy manifest

- Declare required-reason API usage and collected data types in the app's `PrivacyInfo.xcprivacy`, and keep it consistent with the App Store privacy labels.
- When adding an SDK, confirm it ships its own manifest (and signature, if Apple requires one for that SDK).

## Verify

- Test first request, grant, denial, a change in Settings, an interrupted prompt, and relevant OS versions; use a device when framework fidelity matters. `xcrun simctl privacy` resets simulator permissions between runs.
- Inspect the generated Info.plist and signed entitlements so privacy strings and capabilities match the target.
