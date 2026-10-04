import SwiftUI

struct ErrorHandlingScreen: View {
    var body: some View {
        CodeSamplePage(
            title: "Error handling",
            intro: "Functions report failure by throwing errors. Callers must handle them, convert them, or pass them on.",
            samples: ErrorHandlingSamples.all
        )
    }
}

#Preview("Error handling – light") {
    NavigationStack { ErrorHandlingScreen() }
}

#Preview("Error handling – dark") {
    NavigationStack { ErrorHandlingScreen() }
        .preferredColorScheme(.dark)
}
