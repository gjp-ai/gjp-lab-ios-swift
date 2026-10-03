import SwiftUI

/// The app's main action button: `primary` fill with `onPrimary` text, so the label stays readable
/// in light and dark mode. `.borderedProminent` with the Slate tint draws white text on a white fill
/// in dark mode, so use this style instead.
struct LabPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        LabPrimaryButton(configuration: configuration)
    }
}

private struct LabPrimaryButton: View {
    let configuration: ButtonStyleConfiguration
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        configuration.label
            .font(.body.weight(.semibold))
            .foregroundStyle(isEnabled ? LabTheme.onPrimary : LabTheme.onSurfaceVariant)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(isEnabled ? LabTheme.primary : LabTheme.primaryContainer, in: Capsule())
            .opacity(configuration.isPressed ? 0.75 : 1)
            .contentShape(Capsule())
    }
}

extension ButtonStyle where Self == LabPrimaryButtonStyle {
    /// Usage: `Button("Try again", action: retry).buttonStyle(.labPrimary)`
    static var labPrimary: LabPrimaryButtonStyle { LabPrimaryButtonStyle() }
}

#Preview("Lab primary button – light") {
    VStack(spacing: 16) {
        Button("Try again") {}
        Button("Disabled") {}.disabled(true)
    }
    .buttonStyle(.labPrimary)
    .padding()
    .labScreenBackground()
}

#Preview("Lab primary button – dark") {
    VStack(spacing: 16) {
        Button("Try again") {}
        Button("Disabled") {}.disabled(true)
    }
    .buttonStyle(.labPrimary)
    .padding()
    .labScreenBackground()
    .preferredColorScheme(.dark)
}
