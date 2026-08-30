# Slate design system

Status: Implemented

## Intent

GJPLab uses a restrained, high-contrast Slate direction based on black, white, neutral `#E8E8E8`, and a warm canvas `#FFFCF8`. The result should feel direct and technical: strong hierarchy, neutral surfaces, generous contrast, and minimal decorative color. Error and success colors remain semantic status signals.

## Core palette

| Token | Light | Dark | Primary use |
| --- | --- | --- | --- |
| `primary` | `#000000` | `#FFFFFF` | Strongest action and brand tile |
| `onPrimary` | `#FFFFFF` | `#000000` | Content on the primary role |
| `primaryContainer` | `#E8E8E8` | `#343434` | Emphasized neutral grouping |
| `background` | `#FFFCF8` | `#0D0D0D` | Application canvas |
| `surface` | `#FFFFFF` | `#151515` | Cards and ordinary content |
| `onSurfaceVariant` | `#474747` | `#C6C6C6` | Supporting copy |

[`LabTheme.swift`](../../GJPLab/common/theme/LabTheme.swift) supplies dynamic SwiftUI `Color` values from these pairs. Feature code should consume the semantic roles rather than raw RGB values.

## SwiftUI role strategy

Use:

- `LabTheme.primary` / `LabTheme.onPrimary` for the brand tile and highest-emphasis action;
- `LabTheme.surface` / `LabTheme.onSurface` for normal content;
- `LabTheme.surfaceContainer` for quiet nested grouping;
- `LabTheme.onSurfaceVariant` for supporting copy;
- `LabTheme.errorContainer` / `LabTheme.onErrorContainer` for recoverable failures.

[`View.labScreenBackground`](../../GJPLab/common/theme/LabTheme.swift) establishes the canvas; [`View.labCard`](../../GJPLab/common/theme/LabTheme.swift) provides the white/charcoal, 24-point rounded elevated surface. Do not restore tinted category-card fills or use color alone for error, selection, disabled, or progress state.

## App icon and launch screen

The app icon is an iOS 1024-point asset with a black full-bleed background, white circular field, flask-shaped negative-space cutout, and liquid detail. iOS applies the final icon mask; the artwork deliberately stays within a safe central region.

Editable icon SVGs live in [`resources/design/app-icons/`](../../resources/design/app-icons/). [`scripts/render_app_icons.swift`](../../scripts/render_app_icons.swift) deterministically renders default, dark, and tinted PNG variants into `Assets.xcassets/AppIcon.appiconset`; do not hand-edit those rendered PNGs.

The system launch screen uses appearance-aware `LaunchBackground` and `LaunchMark` assets. The app-owned [`SplashScreen`](../../GJPLab/SplashScreen.swift) immediately continues the same semantic light/dark treatment using the reusable [`LabMark`](../../GJPLab/common/theme/LabMark.swift).

## Adaptive dashboard

[`MainScreen`](../../GJPLab/MainScreen.swift) selects grid columns from available view width, not device model:

| Available width | Layout |
| --- | --- |
| Under 600 points | Two columns with compact card content |
| 600–1099 points | Three columns |
| 1100 points and above | Five columns in one row |

Each category card has a six-point primary rail, one icon-title row, and concise supporting copy. The catalogue uses the same canvas, surface, 24-point corners, and rail but a denser table-like row structure. Implemented rows show a chevron; planned topics show a clock and do not imply availability.

## Accessibility and review checklist

- Check semantic foreground/background pairings in light and dark appearance.
- Support normal text contrast, Dynamic Type, text wrapping, and logical VoiceOver labels.
- Keep icons decorative unless their meaning is not already conveyed by nearby text.
- Preserve text or icon cues for status; never rely on color alone.
- Test phone and iPad previews/widths, then a simulator or device when system behavior matters.
- Rebuild after changing asset-catalog colors, SVGs, or app icon variants.
