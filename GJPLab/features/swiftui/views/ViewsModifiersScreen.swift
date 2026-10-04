import SwiftUI

struct ViewsModifiersScreen: View {
    @State private var padding = 12.0
    @State private var isHighlighted = false

    var body: some View {
        LabDemoPage(
            title: "Views & modifiers",
            intro: "A SwiftUI view is a small value that describes UI. Modifiers wrap a view in a new view, so you build screens by composing and wrapping."
        ) {
            LabDemoSection(
                title: "Modifier order",
                caption: "Each modifier wraps the view before it. The same two modifiers in a different order draw a different result."
            ) {
                HStack(alignment: .top, spacing: 16) {
                    OrderSample(code: ".padding()\n.background()") {
                        Text("Padding first")
                            .padding(padding)
                            .background(LabTheme.primaryContainer)
                    }
                    OrderSample(code: ".background()\n.padding()") {
                        Text("Background first")
                            .background(LabTheme.primaryContainer)
                            .padding(padding)
                    }
                }
                Slider(value: $padding, in: 0...32, step: 1) {
                    Text("Padding")
                }
                LabeledContent("Padding") {
                    Text("\(Int(padding)) pt").foregroundStyle(LabTheme.onSurfaceVariant)
                }
            }

            LabDemoSection(
                title: "Custom modifier",
                caption: "A ViewModifier packages several modifiers behind one name, like .labCard() in this app."
            ) {
                Text("Styled with .callout(isHighlighted:)")
                    .callout(isHighlighted: isHighlighted)
                    .animation(.default, value: isHighlighted)
                Toggle("Highlight", isOn: $isHighlighted)
            }

            LabDemoSection(
                title: "Composition",
                caption: "A small view with parameters and a @ViewBuilder slot replaces copy-and-paste."
            ) {
                HStack(spacing: 8) {
                    TagView(systemImage: "swift") { Text("Swift") }
                    TagView(systemImage: "iphone") { Text("iOS 26") }
                    TagView(systemImage: "star.fill") {
                        Text("\(3) stars")
                    }
                }
            }

            LabDemoSection(
                title: "Environment",
                caption: "Some modifiers, such as .font and .foregroundStyle, flow down to every child until a child overrides them."
            ) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Inherits .title3 from the stack")
                    Text("Overrides it with .caption")
                        .font(.caption)
                    Text("Inherits .title3 again")
                }
                .font(.title3)
            }
        }
    }
}

/// A sample view above the code that produced it.
private struct OrderSample<Sample: View>: View {
    let code: String
    @ViewBuilder let sample: Sample

    var body: some View {
        VStack(spacing: 8) {
            sample
                .frame(maxWidth: .infinity, minHeight: 72)
                .border(LabTheme.outlineVariant)
            Text(code)
                .font(.caption.monospaced())
                .foregroundStyle(LabTheme.onSurfaceVariant)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

/// A capsule label with an icon; the caller supplies the text through a @ViewBuilder closure.
private struct TagView<Label: View>: View {
    let systemImage: String
    @ViewBuilder let label: Label

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: systemImage).accessibilityHidden(true)
            label
        }
        .font(.subheadline.weight(.medium))
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(LabTheme.surfaceContainer, in: Capsule())
    }
}

/// A reusable modifier: callers write `.callout(isHighlighted:)` instead of repeating four modifiers.
private struct CalloutModifier: ViewModifier {
    let isHighlighted: Bool

    func body(content: Content) -> some View {
        content
            .font(.body.weight(isHighlighted ? .semibold : .regular))
            .foregroundStyle(isHighlighted ? LabTheme.onPrimary : LabTheme.onSurface)
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                isHighlighted ? LabTheme.primary : LabTheme.surfaceContainer,
                in: RoundedRectangle(cornerRadius: 12, style: .continuous)
            )
    }
}

private extension View {
    func callout(isHighlighted: Bool) -> some View {
        modifier(CalloutModifier(isHighlighted: isHighlighted))
    }
}

#Preview("Views & modifiers – light") {
    NavigationStack { ViewsModifiersScreen() }
}

#Preview("Views & modifiers – dark") {
    NavigationStack { ViewsModifiersScreen() }
        .preferredColorScheme(.dark)
}
