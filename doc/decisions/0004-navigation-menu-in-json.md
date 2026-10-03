# 0004: Sidebar and catalogue content in `navigation.json`; routes stay in Swift

Status: Accepted, 2026-10-03

## Context

Category and topic text lived in a Swift enum (`DashboardCategory`), except Security, which supplied its topics and routes from its own folder (`SecurityCatalog`, `SecurityRoute`). Two patterns did the same job, and editing menu text meant editing Swift.

## Decision

- All categories and topics, in display order, live in `GJPLab/app/navigation/navigation.json`, decoded by `NavigationMenu`.
- A topic's optional `"route"` string is the raw value of a flat `FeatureRoute` case. A topic without a route is shown as planned.
- The mapping from route to screen stays in Swift, in `ContentView.feature(for:)`. The JSON never names a screen type.
- The bundled JSON is trusted app content: if it fails to decode, the app stops at launch with a clear message.

## Consequences

- Menu text, icons, order, and planned topics change without touching Swift.
- A feature is still a code change: a `FeatureRoute` case, its screen in `ContentView`, and the JSON entry.
- Unit tests guard the link between the two: the bundled JSON decodes, every `FeatureRoute` appears exactly once, and an unknown route string fails to decode. A typo cannot silently hide a feature.
- The JSON is bundled, not downloaded. Serving it remotely (for example through Remote Config) would need a fallback and a new decision, because an invalid remote file must not crash the app.
- Sidebar rows tag themselves with the `NavigationCategory` explicitly, because the implicit `List` tag is the String `id`.
