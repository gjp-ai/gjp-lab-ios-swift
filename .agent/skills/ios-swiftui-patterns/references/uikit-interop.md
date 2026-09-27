# UIKit interop

Use when embedding UIKit in SwiftUI, hosting SwiftUI in UIKit, or working in a mixed codebase. Build new screens in the host's dominant framework unless asked otherwise.

## UIKit inside SwiftUI

- Create the view or controller once in `make…`; apply every SwiftUI-driven value in `update…`, which runs often and must be cheap and idempotent.
- Put delegates and target-actions in a `Coordinator`. Write back through bindings, and compare before assigning to avoid update loops.
- Size with `sizeThatFits` or intrinsic content size rather than fixed frames; release observers and timers in `dismantle…`.

## SwiftUI inside UIKit

- Embed `UIHostingController` as a real child: `addChild`, add its view with constraints, then `didMove(toParent:)`.
- Set `sizingOptions = .intrinsicContentSize` when the container must follow SwiftUI's size; use `UIHostingConfiguration` for collection and table cells.
- Feed changing data through an observable model instead of replacing `rootView` on every change.

## Mixed navigation

- Keep one owner per navigation stack. Do not push UIKit controllers onto a SwiftUI `NavigationStack`, or the reverse, without a single coordinating boundary.
- Pass theme, locale, and environment values across the boundary explicitly when the host overrides them.

## Verify

- Rotation and resizing, Dynamic Type changes, dark mode, VoiceOver focus order across the boundary, and memory release on dismissal.
