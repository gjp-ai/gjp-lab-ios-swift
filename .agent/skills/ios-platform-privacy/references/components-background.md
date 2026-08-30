# Platform components and background work

## App entry and external inputs

- Validate URL schemes, universal links, user activities, notifications, shortcut items, share-extension input, and file URLs at the receiving boundary.
- Keep internal navigation type-safe where practical; pass identifiers or minimal data rather than sensitive objects.
- Verify associated-domain ownership, route validation, authentication transitions, and safe fallback behavior for universal links.

## Notifications and background work

- Request notification authorization in context; register APNs only after the app has the needed authorization path.
- Define cancellation, expiration, retry, idempotency, constraints, and persisted inputs before using `BGTaskScheduler` or background `URLSession`.
- Do not assume background execution is guaranteed. Handle task expiration and avoid secrets or large payloads in notification content, user defaults, URLs, or task identifiers.

## Verify configuration

- Inspect capabilities, entitlements, generated Info.plist, URL handlers, background modes, extensions, and dependency-added configuration.
- Exercise notification interactions, termination/relaunch, deep links, task expiration, duplicate delivery, and availability differences when relevant.
