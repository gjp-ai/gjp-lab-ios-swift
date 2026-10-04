import SwiftUI

struct OptionalsScreen: View {
    var body: some View {
        CodeSamplePage(
            title: "Optionals",
            intro: "An optional says in its type that a value may be missing. Swift makes you handle nil before you use the value.",
            samples: OptionalsSamples.all
        )
    }
}

#Preview("Optionals – light") {
    NavigationStack { OptionalsScreen() }
}

#Preview("Optionals – dark") {
    NavigationStack { OptionalsScreen() }
        .preferredColorScheme(.dark)
}
