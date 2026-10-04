# Slate design system

Status: Implemented

## Intent

GJPLab uses a restrained, high-contrast Slate direction based on black, white, neutral `#E8E8E8`, and a warm canvas `#FFFCF8`. The result should feel direct and technical: strong hierarchy, neutral surfaces, generous contrast, and minimal decorative color. Error and success colors remain semantic status signals.

## Palette

[`LabTheme.swift`](../../../../GJPLab/common/theme/LabTheme.swift) supplies each role as a dynamic SwiftUI `Color` that switches with the appearance. Feature code uses these roles, never raw RGB values.

| Role | Light | Dark | Use |
| --- | --- | --- | --- |
| `primary` | `#000000` | `#FFFFFF` | Strongest action, brand tile, selection border, tint |
| `onPrimary` | `#FFFFFF` | `#000000` | Content on `primary` |
| `primaryContainer` | `#E8E8E8` | `#343434` | Emphasized neutral grouping (sidebar icon tiles), disabled button fill |
| `background` | `#FFFCF8` | `#0D0D0D` | Application canvas behind every screen |
| `surface` | `#FFFFFF` | `#151515` | Cards and list rows |
| `surfaceContainer` | `#F1F1F1` | `#222222` | Quiet nested grouping inside a card (code blocks, sample boxes) |
| `onSurface` | `#1A1A1A` | `#E8E8E8` | Normal text (the default set by `.labScreenBackground()`) |
| `onSurfaceVariant` | `#474747` | `#C6C6C6` | Supporting copy, captions, section headers |
| `outlineVariant` | `#C6C6C6` | `#474747` | Hairline borders and dividers |
| `error` | `#BA1A1A` | `#FFB4AB` | Error status text (for example 4xx/5xx status codes) |
| `errorContainer` / `onErrorContainer` | `#FFDAD6` / `#410002` | `#93000A` / `#FFDAD6` | Recoverable-failure banner and its content |
| `success` | `#2E7D32` | `#81C784` | Success status text |

Never use colour alone for status, selection, disabled, or progress: pair it with text or an icon.

## Screens, cards, and buttons

- **Canvas:** every full-screen view (sidebar, catalogue, feature screens, splash, maintenance, and the call overlay) uses [`.labScreenBackground()`](../../../../GJPLab/common/theme/LabTheme.swift), which sets the canvas and the default `onSurface` text colour.
- **Forms and lists:** a `Form` or `List` also needs `.scrollContentBackground(.hidden)` so the canvas shows behind its rows. Because the default text becomes `onSurface`, give section headers, footers, and `LabeledContent` values `onSurfaceVariant` explicitly (see `BlockAppDuringCallsScreen`).
- **Cards:** [`.labCard()`](../../../../GJPLab/common/theme/LabTheme.swift) is the `surface` rounded rectangle (24 points by default) with a soft shadow. [`.labListCard(isSelected:)`](../../../../GJPLab/common/theme/LabTheme.swift) turns a `List` row into its own card with a 0.5-point `outlineVariant` border; a selected row gets a 1-point `primary` border, which replaces the system highlight the card hides.
- **Main action:** [`.buttonStyle(.labPrimary)`](../../../../GJPLab/common/theme/LabButtonStyle.swift) is a `primary` capsule with `onPrimary` text, dimmed while pressed, and a `primaryContainer` fill with `onSurfaceVariant` text when disabled. Do not use `.borderedProminent` with the Slate tint: in dark mode it draws white text on a white fill.
- **Other buttons:** plain text buttons keep the default style and take the `primary` tint, or the container's `on…` colour on a coloured surface (for example **Dismiss** uses `onErrorContainer` on the error banner). `.bordered` and `.borderless` are fine for secondary actions.

Do not restore tinted category-card fills.

## Demo pages

The Swift and SwiftUI categories teach one technique per card, so their screens share one layout from [`LabDemoSection.swift`](../../../../GJPLab/common/theme/LabDemoSection.swift):

- `LabDemoPage(title:intro:)` is a scrolling screen with a supporting-copy introduction, width-limited to 720 points and centred on iPad, on the canvas, with the navigation title set.
- `LabDemoSection(title:caption:)` is an 18-point `labCard` with a headline title (a VoiceOver heading, so the headings rotor jumps between demos), an `onSurfaceVariant` caption, and the live sample.

SwiftUI topics build their samples inside these cards directly. Swift topics use them through the [runnable code sample](../codesample/codesample_detail_design.md) card.

Rules for every demo page:

- Use only public APIs available on the app's deployment target (iOS 26.6).
- Keep sample data in memory: nothing is persisted, sent over the network, or logged.
- Use `LabTheme` roles for colour and `.labPrimary` for the main action; a colour the user picks (for example in a `ColorPicker`) is the only exception.
- Hide decorative images from VoiceOver, and give icon-only controls a label and a 44-point target.

## App icon and launch screen

The app icon is an iOS 1024-point asset with a black full-bleed background, white circular field, flask-shaped negative-space cutout, and liquid detail. iOS applies the final icon mask; the artwork deliberately stays within a safe central region.

Editable icon SVGs live in [`resources/design/app-icons/`](../../../../resources/design/app-icons/). [`scripts/render_app_icons.swift`](../../../../scripts/render_app_icons.swift) deterministically renders default, dark, and tinted PNG variants into `Assets.xcassets/AppIcon.appiconset`; do not hand-edit those rendered PNGs.

The system launch screen uses appearance-aware `LaunchBackground` and `LaunchMark` assets. The app-owned [`SplashScreen`](../../../../GJPLab/app/startup/SplashScreen.swift) immediately continues the same treatment using the reusable [`LabMark`](../../../../GJPLab/common/theme/LabMark.swift).

## Adaptive navigation

The category sidebar and catalogue use system lists inside a `NavigationSplitView`: three columns on regular widths, one stack on compact widths. **Every screen uses the same background in each appearance: the Slate canvas.** The sidebar and the catalogue are `.plain` lists of `labListCard` rows on the canvas; sidebar rows add a `primaryContainer` icon tile. The iPad placeholders ("Choose a category", "Choose a topic") also use the canvas. In the catalogue, implemented topics show a chevron; planned topics show a clock and cannot be selected. See the [sidebar detailed design](../../app/navigation/sidebar_detail_design.md).

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| `SectionHeader` (and `Footer`) are copied privately in three `Form` screens | The `onSurfaceVariant` header rule is repeated in code | Move one shared header view into `common/theme/` |
| `success` and `error` text colours are not checked for contrast on every surface | A status colour may fall below WCAG AA on `surfaceContainer` | Check contrast for each pairing and keep a text or icon cue |

## Review checklist

- Check semantic foreground/background pairings in light and dark appearance.
- Support normal text contrast, Dynamic Type, text wrapping, and logical VoiceOver labels.
- Keep icons decorative unless their meaning is not already conveyed by nearby text.
- Preserve text or icon cues for status; never rely on color alone.
- Test phone and iPad previews/widths, then a simulator or device when system behavior matters.
- Rebuild after changing asset-catalog colors, SVGs, or app icon variants.
