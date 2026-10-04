import SwiftUI

struct DrawingScreen: View {
    @State private var starPoints = 5
    @State private var innerRatio = 0.45
    @State private var strokes: [[CGPoint]] = []
    @State private var currentStroke: [CGPoint] = []
    @State private var signal = 0.6
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        LabDemoPage(
            title: "Drawing & graphics",
            intro: "Shapes describe outlines that SwiftUI fills or strokes. Canvas draws many items quickly in one view. SF Symbols are images that scale with text."
        ) {
            LabDemoSection(
                title: "Built-in shapes",
                caption: "Fill a shape with a colour or gradient, or stroke its outline with a line style."
            ) {
                HStack(spacing: 14) {
                    Circle()
                        .fill(LabTheme.primary)
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(LinearGradient(colors: [LabTheme.primary, LabTheme.outlineVariant], startPoint: .top, endPoint: .bottom))
                    Capsule()
                        .strokeBorder(LabTheme.primary, lineWidth: 4)
                    Ellipse()
                        .stroke(LabTheme.primary, style: StrokeStyle(lineWidth: 3, dash: [6, 4]))
                }
                .frame(height: 64)
                .accessibilityHidden(true)
            }

            LabDemoSection(
                title: "Custom Shape",
                caption: "StarShape adopts the Shape protocol by building a Path. Its inner radius is animatable, so the star morphs."
            ) {
                StarShape(points: starPoints, innerRatio: innerRatio)
                    .fill(RadialGradient(colors: [LabTheme.outlineVariant, LabTheme.primary], center: .center, startRadius: 0, endRadius: 80))
                    .frame(width: 150, height: 150)
                    .frame(maxWidth: .infinity)
                    .animation(reduceMotion ? nil : .spring, value: innerRatio)
                    .accessibilityElement()
                    .accessibilityLabel("Star with \(starPoints) points")

                Stepper("Points: \(starPoints)", value: $starPoints, in: 3...12)
                Slider(value: $innerRatio, in: 0.2...1) {
                    Text("Inner radius")
                } minimumValueLabel: {
                    Text("Spiky").font(.caption)
                } maximumValueLabel: {
                    Text("Round").font(.caption)
                }
            }

            LabDemoSection(
                title: "Canvas and TimelineView",
                caption: "TimelineView redraws every frame, and Canvas draws the wave with immediate-mode calls instead of one view per point."
            ) {
                TimelineView(.animation(paused: reduceMotion)) { timeline in
                    WaveCanvas(phase: timeline.date.timeIntervalSinceReferenceDate, color: LabTheme.primary)
                }
                .frame(height: 90)
                .accessibilityHidden(true)
            }

            LabDemoSection(
                title: "Draw with a gesture",
                caption: "A DragGesture records points, and a Canvas draws them as lines."
            ) {
                SketchCanvas(strokes: strokes + [currentStroke], color: LabTheme.primary)
                    .frame(height: 220)
                    .background(LabTheme.surfaceContainer, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { currentStroke.append($0.location) }
                            .onEnded { _ in
                                strokes.append(currentStroke)
                                currentStroke = []
                            }
                    )
                    .accessibilityLabel("Drawing area")
                    .accessibilityValue(strokes.isEmpty ? "Empty" : "\(strokes.count) strokes")

                Button("Clear", systemImage: "eraser") { strokes = [] }
                    .buttonStyle(.bordered)
                    .disabled(strokes.isEmpty)
            }

            LabDemoSection(
                title: "SF Symbols",
                caption: "Rendering modes control how a symbol's layers are coloured. Variable symbols fill in part of their shape for a value."
            ) {
                HStack(spacing: 24) {
                    SymbolSample(title: "Monochrome") {
                        Image(systemName: "cloud.sun.rain.fill").symbolRenderingMode(.monochrome)
                    }
                    SymbolSample(title: "Hierarchical") {
                        Image(systemName: "cloud.sun.rain.fill").symbolRenderingMode(.hierarchical)
                    }
                    SymbolSample(title: "Palette") {
                        Image(systemName: "cloud.sun.rain.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(LabTheme.onSurfaceVariant, LabTheme.primary, LabTheme.outlineVariant)
                    }
                }
                .frame(maxWidth: .infinity)

                HStack(spacing: 16) {
                    Image(systemName: "wifi", variableValue: signal)
                        .font(.largeTitle)
                        .frame(width: 52)
                        .accessibilityHidden(true)
                    Slider(value: $signal, in: 0...1) {
                        Text("Signal strength")
                    }
                }
            }
        }
    }
}

/// An animated sine wave. `phase` is the current time, so the wave moves as the timeline ticks.
private struct WaveCanvas: View {
    let phase: Double
    let color: Color

    var body: some View {
        Canvas { context, size in
            var wave = Path()
            let midY = size.height / 2
            for x in stride(from: 0, through: size.width, by: 2) {
                let angle = Double(x / size.width) * 4 * .pi + phase * 2
                let point = CGPoint(x: x, y: midY + sin(angle) * midY * 0.7)
                if x == 0 { wave.move(to: point) } else { wave.addLine(to: point) }
            }
            context.stroke(wave, with: .color(color), style: StrokeStyle(lineWidth: 3, lineCap: .round))
        }
    }
}

private struct SketchCanvas: View {
    let strokes: [[CGPoint]]
    let color: Color

    var body: some View {
        Canvas { context, _ in
            for stroke in strokes {
                guard let first = stroke.first else { continue }
                var path = Path()
                path.move(to: first)
                stroke.dropFirst().forEach { path.addLine(to: $0) }
                context.stroke(path, with: .color(color), style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
            }
        }
    }
}

private struct SymbolSample<Symbol: View>: View {
    let title: String
    @ViewBuilder let symbol: Symbol

    var body: some View {
        VStack(spacing: 8) {
            symbol
                .font(.largeTitle)
                .accessibilityHidden(true)
            Text(title)
                .font(.caption)
                .foregroundStyle(LabTheme.onSurfaceVariant)
        }
    }
}

#Preview("Drawing & graphics – light") {
    NavigationStack { DrawingScreen() }
}

#Preview("Drawing & graphics – dark") {
    NavigationStack { DrawingScreen() }
        .preferredColorScheme(.dark)
}
