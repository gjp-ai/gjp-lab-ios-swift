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

[`LabTheme.swift`](../../../../GJPLab/common/theme/LabTheme.swift) supplies dynamic SwiftUI `Color` values from these pairs. Feature code should consume the semantic roles rather than raw RGB values.

## SwiftUI role strategy

Use:

- `LabTheme.primary` / `LabTheme.onPrimary` for the brand tile and highest-emphasis action;
- `LabTheme.surface` / `LabTheme.onSurface` for normal content;
- `LabTheme.surfaceContainer` for quiet nested grouping;
- `LabTheme.onSurfaceVariant` for supporting copy;
- `LabTheme.errorContainer` / `LabTheme.onErrorContainer` for recoverable failures.

[`View.labScreenBackground`](../../../../GJPLab/common/theme/LabTheme.swift) establishes the canvas; [`View.labCard`](../../../../GJPLab/common/theme/LabTheme.swift) provides the white/charcoal, 24-point rounded elevated surface.

Every full-screen view (sidebar, catalogue, feature screens, splash, maintenance, and the call overlay) uses `.labScreenBackground()`, which sets both the canvas and the default `onSurface` text colour. A `Form` also needs `.scrollContentBackground(.hidden)` so the canvas shows behind its rows; because the default text becomes `onSurface`, give section headers, footers, and `LabeledContent` values `onSurfaceVariant` explicitly (see `BlockAppDuringCallsScreen`).

[`.buttonStyle(.labPrimary)`](../../../../GJPLab/common/theme/LabButtonStyle.swift) is the main action button: a `primary` capsule with `onPrimary` text (black with white text in light mode, white with black text in dark mode), dimmed while pressed, and a `primaryContainer` fill with `onSurfaceVariant` text when disabled. Do not use `.borderedProminent` with the Slate tint: in dark mode it draws white text on a white fill. Plain text buttons keep the default style and take the `primary` tint, or the container's `on…` colour when they sit on a coloured surface (for example **Dismiss** uses `onErrorContainer` on the error banner).

[`LabDemoPage`](../../../../GJPLab/common/theme/LabDemoSection.swift) is a scrolling screen with a supporting-copy introduction, width-limited to 720 points and centred on iPad, on the canvas. [`LabDemoSection`](../../../../GJPLab/common/theme/LabDemoSection.swift) is an 18-point `labCard` with a headline title (a VoiceOver heading), an `onSurfaceVariant` caption, and the live sample. The SwiftUI topic screens use both so every demo looks the same; the Swift topics use them through the [runnable code sample](../codesample/codesample_detail_design.md) card.

Do not restore tinted category-card fills or use color alone for error, selection, disabled, or progress state.

## App icon and launch screen

The app icon is an iOS 1024-point asset with a black full-bleed background, white circular field, flask-shaped negative-space cutout, and liquid detail. iOS applies the final icon mask; the artwork deliberately stays within a safe central region.

Editable icon SVGs live in [`resources/design/app-icons/`](../../../../resources/design/app-icons/). [`scripts/render_app_icons.swift`](../../../../scripts/render_app_icons.swift) deterministically renders default, dark, and tinted PNG variants into `Assets.xcassets/AppIcon.appiconset`; do not hand-edit those rendered PNGs.

The system launch screen uses appearance-aware `LaunchBackground` and `LaunchMark` assets. The app-owned [`SplashScreen`](../../../../GJPLab/app/startup/SplashScreen.swift) immediately continues the same semantic light/dark treatment using the reusable [`LabMark`](../../../../GJPLab/common/theme/LabMark.swift).

## Adaptive navigation

The category sidebar and catalogue use system lists inside a `NavigationSplitView`: three columns on regular widths, one stack on compact widths. **Every screen uses the same background in each appearance: the Slate canvas (`#FFFCF8` light, `#0D0D0D` dark).** The sidebar and the catalogue are `.plain` lists that hide their system background and use `.labScreenBackground()`. Each row is its own card through [`View.labListCard(isSelected:)`](../../../../GJPLab/common/theme/LabTheme.swift): a `surface` rounded rectangle with a 0.5-point `outlineVariant` border, spaced 12 points apart. The card replaces the system selection highlight, so a selected row (iPad) gets a 1-point `primary` border. Sidebar rows add an icon tile (`primaryContainer`). The iPad placeholders ("Choose a category", "Choose a topic") also use the canvas. Feature screens use the canvas and cards. See the [sidebar detailed design](../../app/navigation/sidebar_detail_design.md).

In the catalogue, implemented topics show a chevron; planned topics show a clock and cannot be selected.

## Accessibility and review checklist

- Check semantic foreground/background pairings in light and dark appearance.
- Support normal text contrast, Dynamic Type, text wrapping, and logical VoiceOver labels.
- Keep icons decorative unless their meaning is not already conveyed by nearby text.
- Preserve text or icon cues for status; never rely on color alone.
- Test phone and iPad previews/widths, then a simulator or device when system behavior matters.
- Rebuild after changing asset-catalog colors, SVGs, or app icon variants.
