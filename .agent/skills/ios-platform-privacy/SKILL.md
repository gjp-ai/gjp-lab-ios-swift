---
name: ios-platform-privacy
description: Implement or review iOS platform integrations that touch permissions, privacy, or security, including camera, photos, location, contacts, Face ID, Keychain, push notifications and APNs, deep links and universal links, background tasks, extensions, entitlements, Info.plist usage descriptions, privacy manifests, and ATS. For OS-version checks and deprecations use ios-api-availability. Use for protected APIs, sensitive data, capability or entitlement changes, or privacy and security reviews. Not for pure SwiftUI layout or repository-only work.
metadata:
  version: "0.3.0"
---

# iOS Platform and Privacy

Integrate iOS capabilities with the minimum data, entitlement, and permission scope the outcome needs. Treat privacy strings, authorization UX, scene behavior, and sensitive-data handling as one end-to-end contract.

Pairs with `ios-testing` for device checks, `ios-architecture` for where platform code lives, and `ios-api-availability` for OS-version gating.

## Discover the host project

Read project instructions, deployment target, capabilities and entitlements (per configuration), Info.plist build settings, privacy manifests, app and scene delegates, permission wrappers, background tasks, and tests. Identify the protected capability, its user-visible purpose, sensitive data, OS availability, and behavior when access is unavailable. Prefer a system picker, limited authorization, or a lower-privilege API when it meets the need. Check uncertain requirements against Apple documentation.

## Select a mode

- **Permissions, usage descriptions, or privacy manifests:** [authorization workflow](references/permissions.md).
- **Notifications, deep links, extensions, or background work:** [platform components guide](references/components-background.md).
- **Privacy or security review:** [security review checklist](references/security-review.md); report without editing unless asked.

## Gotchas

- A missing `NS…UsageDescription` crashes the app on first use of the API, including calls made inside SDKs.
- Required-reason APIs (such as `UserDefaults`, file timestamps, system boot time, and disk space) need a `PrivacyInfo.xcprivacy` declaration; third-party SDKs must ship their own manifests.
- Store tokens and credentials in the Keychain, not `UserDefaults`, files, or logs. Choose the accessibility class the feature needs; background access needs an `AfterFirstUnlock` class.
- `aps-environment` differs between development and distribution signing; check every configuration's entitlements.
- Authorization can change while the app is in the background; re-check status when the scene becomes active and right before the protected action.
- Simulator helpers: `xcrun simctl push booted <bundle-id> <payload.apns>`, `xcrun simctl openurl booted <url>`, and `xcrun simctl privacy booted grant|revoke|reset <service> <bundle-id>`. Real APNs delivery and some hardware still need a device.

## Completion contract

- Request only the needed capability, in context, after a user action where the platform permits.
- Make denial, restriction, revocation, missing entitlement, and unavailable hardware understandable and safe.
- Minimize sensitive data in logs, analytics, pasteboard, URLs, `UserDefaults`, files, notifications, and app-group storage.
- Keep secrets, APNs keys, signing material, service credentials, and debug tokens out of source and build artifacts.
- Inspect the resulting app configuration, and run device checks when framework behavior cannot be proven locally.
