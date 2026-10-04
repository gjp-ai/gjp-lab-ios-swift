import SwiftUI

struct ProtocolsGenericsScreen: View {
    var body: some View {
        CodeSamplePage(
            title: "Protocols & generics",
            intro: "Protocols describe what a type can do. Generics let one piece of code work with many types that meet those requirements.",
            samples: ProtocolsGenericsSamples.all
        )
    }
}

#Preview("Protocols & generics – light") {
    NavigationStack { ProtocolsGenericsScreen() }
}

#Preview("Protocols & generics – dark") {
    NavigationStack { ProtocolsGenericsScreen() }
        .preferredColorScheme(.dark)
}
