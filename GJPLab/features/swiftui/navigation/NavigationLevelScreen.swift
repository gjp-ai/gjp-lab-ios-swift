import SwiftUI

/// A pushed screen in the Navigation topic. It can push one level deeper, go back one level, or pop to the
/// topic's root; popping to root is the caller's job because `ContentView` owns the path.
struct NavigationLevelScreen: View {
    let level: Int
    let onPopToRoot: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        LabDemoPage(
            title: "Level \(level)",
            intro: "The stack's path now holds \(level) value\(level == 1 ? "" : "s"). Each level is a DetailRoute.navigationLevel value."
        ) {
            LabDemoSection(title: "Go deeper", caption: "Appends one more value to the path.") {
                NavigationLink(value: DetailRoute.navigationLevel(level + 1)) {
                    Label("Push level \(level + 1)", systemImage: "arrow.right.square")
                }
                .buttonStyle(.labPrimary)
            }

            LabDemoSection(
                title: "Go back",
                caption: "dismiss() removes the last value. Popping to root asks ContentView to empty the path."
            ) {
                HStack(spacing: 8) {
                    Button("Back one level") { dismiss() }
                    Button("Pop to root", action: onPopToRoot)
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

#Preview("Navigation level – light") {
    NavigationStack { NavigationLevelScreen(level: 2, onPopToRoot: {}) }
}

#Preview("Navigation level – dark") {
    NavigationStack { NavigationLevelScreen(level: 2, onPopToRoot: {}) }
        .preferredColorScheme(.dark)
}
