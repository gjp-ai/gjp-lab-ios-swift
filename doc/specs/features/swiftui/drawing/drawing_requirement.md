# Feature: Drawing & graphics

Status: Implemented

## Goal

Show SwiftUI's drawing tools: shapes and gradients, a custom animatable `Shape`, `Canvas`, gesture-based drawing, and SF Symbols.

## Scope

### In scope

- Built-in shapes with fills, gradients, and stroke styles.
- `StarShape`: 3–12 points with an animatable inner radius.
- An animated sine wave drawn by `Canvas` inside `TimelineView`.
- Finger drawing with `DragGesture` and a **Clear** button.
- SF Symbol rendering modes and a variable-value symbol driven by a slider.

### Out of scope

- Saving or exporting drawings.
- Metal shaders and `UIViewRepresentable` drawing.

## Behavior

- Dragging in the drawing area draws a line under the finger; lifting ends the stroke.
- **Clear** removes all strokes and is disabled when the area is empty.
- The wave pauses when Reduce Motion is on.

## UI & Navigation

- Entry point: **SwiftUI** category → **Drawing & graphics** catalogue item (route `drawing`).
- Five cards: **Built-in shapes**, **Custom Shape**, **Canvas and TimelineView**, **Draw with a gesture**, **SF Symbols**.
- Decorative drawings are hidden from VoiceOver; the star and drawing area have labels and values.
- Light and dark appearance and Dynamic Type are supported; content width is limited on iPad.

## Rules & Constraints

- The shared [demo page rules](../../../common/theme/theme_detail_design.md#demo-pages) apply: public SwiftUI APIs on the deployment target only, sample data kept in memory (nothing persisted, sent, or logged), and `LabTheme` colours.
- Drawings use `LabTheme` colours only.
- `StarShape.vertices(points:innerRatio:in:)` is pure so unit tests can check it.

## Platform limitations

- None.

## Acceptance criteria

| ID | Scenario | Expected result |
| --- | --- | --- |
| DRW-AC-01 | Change the star to 8 points | An 8-pointed star is drawn. |
| DRW-AC-02 | Move the inner radius slider | The star morphs smoothly. |
| DRW-AC-03 | Draw, then tap Clear | Strokes appear, then the area is empty and Clear is disabled. |
| DRW-AC-04 | Unit tests | A 5-point star has 10 vertices starting at the top centre. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swiftui/drawing/` (`DrawingScreen.swift`, `StarShape.swift`).
- `FeatureRoute.drawing` maps to the screen in `ContentView.feature(for:)`; the topic in `app/navigation/navigation.json` carries `"route": "drawing"`.
- No new dependencies.

## Related documents

- [Detailed design](drawing_detail_design.md)
- [Slate design system: demo pages](../../../common/theme/theme_detail_design.md#demo-pages) (`LabDemoPage` and `LabDemoSection`)
- [Application architecture](../../../../architecture/application.md)
