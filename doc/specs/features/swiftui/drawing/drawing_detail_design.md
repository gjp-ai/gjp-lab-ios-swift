# Drawing & graphics detailed design

Status: Implemented, with known gaps

Requirements: [Drawing & graphics](drawing_requirement.md)

## Implementation goal

Show increasing levels of drawing control: built-in shapes, a custom animatable `Shape`, an immediate-mode `Canvas` driven by `TimelineView`, gesture input drawn by a `Canvas`, and SF Symbols.

## Source map

| Source | Responsibility |
| --- | --- |
| [`DrawingScreen.swift`](../../../../../GJPLab/features/swiftui/drawing/DrawingScreen.swift) | Screen, private `WaveCanvas`, `SketchCanvas`, `SymbolSample` |
| [`StarShape.swift`](../../../../../GJPLab/features/swiftui/drawing/StarShape.swift) | Custom `Shape` with animatable `innerRatio` and pure `vertices(points:innerRatio:in:)` |
| [`LabDemoSection.swift`](../../../../../GJPLab/common/theme/LabDemoSection.swift) | `LabDemoPage` (scrolling, width-limited page) and `LabDemoSection` (titled card) |
| [`FeatureRoute.swift`](../../../../../GJPLab/app/navigation/FeatureRoute.swift) | `.drawing` case |
| [`navigation.json`](../../../../../GJPLab/app/navigation/navigation.json) | SwiftUI catalogue entry (`"route": "drawing"`) |
| [`ContentView.swift`](../../../../../GJPLab/app/ContentView.swift) | Maps `.drawing` to the screen in `feature(for:)` |

## Ownership and state

- `DrawingScreen` owns `starPoints` (3–12), `innerRatio` (0.2–1), `strokes` (`[[CGPoint]]`), `currentStroke`, and `signal` (0–1) with `@State`.
- `TimelineView(.animation(paused: reduceMotion))` drives the wave only while the view is on screen, and pauses it when Reduce Motion is on.
- Drawings live in memory only.

## StarShape

`vertices` returns `2 × points` corners, alternating outer radius (half the shorter side) and `outerRadius × innerRatio`, starting at the top (angle −π/2). `animatableData` exposes `innerRatio`, so `.animation(.spring, value: innerRatio)` interpolates the ratio and redraws each frame. The point count is not animatable because a fractional number of points has no meaning.

## Canvas

`WaveCanvas` builds one `Path` of a sine curve sampled every 2 points and strokes it with the `LabTheme.primary` colour passed in from the view (resolved for the current appearance). `SketchCanvas` strokes one path per finger stroke with round caps and joins.

## Gesture input

`DragGesture(minimumDistance: 0)` appends each location to `currentStroke`; `onEnded` moves it into `strokes`. The canvas draws `strokes + [currentStroke]`, so the line appears while dragging.

## Colour policy

Gradients and fills use `LabTheme` roles only, in line with the Slate palette rule.

## Known gaps

| Gap | Effect | Suggested fix |
| --- | --- | --- |
| Strokes keep every sampled point | Very long drawings use more memory and redraw time | Simplify points (for example drop points closer than 2 points apart) |
| Drawing area is not usable with VoiceOver | Blind users cannot draw | Acceptable for a drawing sample; the area is labelled and reports its stroke count |
| Strokes drawn outside the area are clipped but still recorded | Hidden points are stored | Clamp locations to the canvas bounds |

## Verification

- Build with the project build command in [application architecture](../../../../architecture/application.md#build-and-verification).
- Automated: `SwiftUIFeatureTests` checks `StarShape.vertices` (vertex count, top vertex, fewer than two points); `SwiftUITopicsUITests.testEverySwiftUITopicOpens` opens the screen from the catalogue and checks its navigation title.
- Manual: DRW-AC-01 to DRW-AC-03 on an iPhone simulator in light and dark appearance.
