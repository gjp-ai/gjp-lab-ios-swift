---
name: ios-platform-privacy
description: Implement or review iOS platform integrations involving permissions, entitlements, Info.plist privacy usage, notifications, deep links, background execution, files, sensors, sharing, API availability, privacy, and secure configuration. Use for protected APIs or sensitive data, not pure SwiftUI layout or repository-only work.
metadata:
  version: "0.1.0"
---

# iOS Platform and Privacy

Integrate iOS capabilities with the minimum user data, entitlement, and permission scope needed for the requested outcome. Treat privacy strings, authorization UX, scene behavior, and sensitive-data handling as one end-to-end contract.

## Discover the host project

Read project instructions, deployment target, target capabilities and entitlements, Info.plist build settings, app/scene delegates, permission wrappers, background tasks, and tests. Identify the protected capability, user-visible purpose, sensitive data, availability differences, and behavior when access is unavailable.

Prefer a system picker, limited authorization, or lower-privilege API when it satisfies the outcome. Verify uncertain platform requirements against official Apple documentation.

## Select a mode

- **Permissions or privacy usage descriptions:** Read [the authorization workflow](references/permissions.md).
- **Notifications, deep links, extensions, or background work:** Read [the platform components guide](references/components-background.md).
- **Privacy or security review:** Read [the security review guide](references/security-review.md); report without editing unless asked.

## Completion contract

- Request only the needed capability, in context, after a user action where the platform permits.
- Make denial, restricted authorization, revocation, missing entitlement, and unavailable hardware understandable and safe.
- Minimize sensitive data in logs, analytics, pasteboard, URLs, UserDefaults, files, notifications, and app-group storage.
- Keep secrets, APNs keys, signing material, service credentials, and debug tokens out of source and artifacts.
- Inspect resulting app configuration and run device checks when framework behavior cannot be proven locally.
