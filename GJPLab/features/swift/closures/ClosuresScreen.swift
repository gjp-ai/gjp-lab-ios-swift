import SwiftUI

struct ClosuresScreen: View {
    var body: some View {
        CodeSamplePage(
            title: "Functions & closures",
            intro: "Functions are named, reusable code. Closures are functions without a name that you can store and pass around.",
            samples: ClosuresSamples.all
        )
    }
}

#Preview("Functions & closures – light") {
    NavigationStack { ClosuresScreen() }
}

#Preview("Functions & closures – dark") {
    NavigationStack { ClosuresScreen() }
        .preferredColorScheme(.dark)
}
