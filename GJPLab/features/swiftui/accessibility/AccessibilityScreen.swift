import SwiftUI

struct AccessibilityScreen: View {
    @State private var rating = 3
    @State private var tapCount = 0
    @ScaledMetric(relativeTo: .body) private var iconSize = 28
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled
    @Environment(\.colorSchemeContrast) private var contrast

    var body: some View {
        LabDemoPage(
            title: "Accessibility & testing",
            intro: "Accessibility modifiers describe what a view means, not how it looks. VoiceOver, Voice Control, and UI tests all read the same information."
        ) {
            LabDemoSection(
                title: "Dynamic Type",
                caption: "Text styles scale with the user's text size. @ScaledMetric scales other numbers, and large sizes switch this row to a column."
            ) {
                let layout = dynamicTypeSize.isAccessibilitySize
                    ? AnyLayout(VStackLayout(alignment: .leading, spacing: 8))
                    : AnyLayout(HStackLayout(spacing: 12))
                layout {
                    Image(systemName: "textformat.size")
                        .resizable()
                        .scaledToFit()
                        .frame(width: iconSize, height: iconSize)
                        .accessibilityHidden(true)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Text size: \(dynamicTypeSize.title)")
                            .font(.body.weight(.semibold))
                        Text("Icon: \(Int(iconSize)) pt")
                            .font(.subheadline)
                            .foregroundStyle(LabTheme.onSurfaceVariant)
                    }
                }
            }

            LabDemoSection(
                title: "Grouping and hiding",
                caption: "This card is one VoiceOver element: .combine joins its texts, and the decorative icon is hidden."
            ) {
                HStack(spacing: 12) {
                    Image(systemName: "airplane.departure")
                        .font(.title2)
                        .accessibilityHidden(true)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Flight GJ 26").fontWeight(.semibold)
                        Text("Departs 09:40 from gate B12")
                            .font(.subheadline)
                            .foregroundStyle(LabTheme.onSurfaceVariant)
                    }
                }
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(LabTheme.surfaceContainer, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .accessibilityElement(children: .combine)
            }

            LabDemoSection(
                title: "Custom control",
                caption: "A custom rating is one adjustable element with a label and value. With VoiceOver, swipe up or down to change it."
            ) {
                RatingControl(rating: $rating)
            }

            LabDemoSection(
                title: "Your settings",
                caption: "Environment values report accessibility settings so a screen can adapt, for example by removing motion."
            ) {
                VStack(spacing: 8) {
                    SettingRow(label: "VoiceOver", isOn: voiceOverEnabled)
                    SettingRow(label: "Reduce Motion", isOn: reduceMotion)
                    SettingRow(label: "Differentiate Without Colour", isOn: differentiateWithoutColor)
                    SettingRow(label: "Reduce Transparency", isOn: reduceTransparency)
                    SettingRow(label: "Increase Contrast", isOn: contrast == .increased)
                }
            }

            LabDemoSection(
                title: "UI testing",
                caption: "accessibilityIdentifier gives XCUITest a stable handle that does not change with the language. GJPLabUITests taps this button."
            ) {
                HStack(spacing: 16) {
                    Button("Tap me") { tapCount += 1 }
                        .buttonStyle(.labPrimary)
                        .accessibilityIdentifier("accessibility.tapButton")
                    Text(tapCount == 1 ? "Tapped 1 time" : "Tapped \(tapCount) times")
                        .accessibilityIdentifier("accessibility.tapCount")
                }
            }
        }
    }
}

/// Five stars that act as one adjustable control for VoiceOver instead of five separate buttons.
private struct RatingControl: View {
    @Binding var rating: Int
    private let range = 1...5

    var body: some View {
        HStack(spacing: 6) {
            ForEach(range, id: \.self) { star in
                Button {
                    rating = star
                } label: {
                    Image(systemName: star <= rating ? "star.fill" : "star")
                        .font(.title2)
                        .frame(minWidth: 44, minHeight: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Rating")
        .accessibilityValue("\(rating) of \(range.upperBound) stars")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: rating = min(rating + 1, range.upperBound)
            case .decrement: rating = max(rating - 1, range.lowerBound)
            @unknown default: break
            }
        }
    }
}

private struct SettingRow: View {
    let label: String
    let isOn: Bool

    var body: some View {
        LabeledContent(label) {
            // Text as well as the icon, so the state never relies on the symbol shape alone.
            Label(isOn ? "On" : "Off", systemImage: isOn ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(LabTheme.onSurfaceVariant)
        }
    }
}

private extension DynamicTypeSize {
    var title: String {
        switch self {
        case .xSmall: "Extra small"
        case .small: "Small"
        case .medium: "Medium"
        case .large: "Large (default)"
        case .xLarge: "Extra large"
        case .xxLarge: "XX large"
        case .xxxLarge: "XXX large"
        case .accessibility1: "Accessibility 1"
        case .accessibility2: "Accessibility 2"
        case .accessibility3: "Accessibility 3"
        case .accessibility4: "Accessibility 4"
        case .accessibility5: "Accessibility 5"
        @unknown default: "Other"
        }
    }
}

#Preview("Accessibility & testing – light") {
    NavigationStack { AccessibilityScreen() }
}

#Preview("Accessibility & testing – dark") {
    NavigationStack { AccessibilityScreen() }
        .preferredColorScheme(.dark)
}

#Preview("Accessibility & testing, large text – light") {
    NavigationStack { AccessibilityScreen() }
        .dynamicTypeSize(.accessibility3)
}

#Preview("Accessibility & testing, large text – dark") {
    NavigationStack { AccessibilityScreen() }
        .dynamicTypeSize(.accessibility3)
        .preferredColorScheme(.dark)
}
