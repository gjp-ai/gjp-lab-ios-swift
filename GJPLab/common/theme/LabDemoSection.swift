import SwiftUI

/// A scrolling demo screen: a short introduction followed by `LabDemoSection` cards, width-limited on iPad.
/// Used by the SwiftUI topics, where each card shows one technique.
struct LabDemoPage<Content: View>: View {
    let title: String
    let intro: String
    @ViewBuilder let content: Content

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text(intro)
                    .foregroundStyle(LabTheme.onSurfaceVariant)
                    .fixedSize(horizontal: false, vertical: true)
                content
            }
            .frame(maxWidth: 720)
            .padding(20)
            .frame(maxWidth: .infinity)
        }
        .labScreenBackground()
        .navigationTitle(title)
    }
}

/// A titled card that groups one demo: a heading, a one-line explanation, then the live sample.
struct LabDemoSection<Content: View>: View {
    let title: String
    let caption: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    // VoiceOver users can jump between demos with the headings rotor.
                    .accessibilityAddTraits(.isHeader)
                Text(caption)
                    .font(.subheadline)
                    .foregroundStyle(LabTheme.onSurfaceVariant)
                    .fixedSize(horizontal: false, vertical: true)
            }
            content
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .labCard(cornerRadius: 18)
    }
}

#Preview("Lab demo page – light") {
    NavigationStack {
        LabDemoPage(title: "Demo", intro: "A short introduction to the topic.") {
            LabDemoSection(title: "Technique", caption: "What this card shows.") {
                Button("Try it") {}.buttonStyle(.labPrimary)
            }
        }
    }
}

#Preview("Lab demo page – dark") {
    NavigationStack {
        LabDemoPage(title: "Demo", intro: "A short introduction to the topic.") {
            LabDemoSection(title: "Technique", caption: "What this card shows.") {
                Button("Try it") {}.buttonStyle(.labPrimary)
            }
        }
    }
    .preferredColorScheme(.dark)
}
