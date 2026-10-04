import SwiftUI

struct ConcurrencyScreen: View {
    var body: some View {
        CodeSamplePage(
            title: "Concurrency",
            intro: "Swift runs work concurrently with async functions and tasks, and uses actors to keep shared state safe. Samples stop if you leave the topic.",
            samples: ConcurrencySamples.all
        )
    }
}

#Preview("Concurrency – light") {
    NavigationStack { ConcurrencyScreen() }
}

#Preview("Concurrency – dark") {
    NavigationStack { ConcurrencyScreen() }
        .preferredColorScheme(.dark)
}
