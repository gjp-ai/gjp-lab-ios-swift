import SwiftUI

struct SwiftBasicsScreen: View {
    var body: some View {
        CodeSamplePage(
            title: "Values & types",
            intro: "Every value in Swift has a type, chosen by you or inferred by the compiler. Constants and variables hold those values.",
            samples: BasicsSamples.all
        )
    }
}

#Preview("Values & types – light") {
    NavigationStack { SwiftBasicsScreen() }
}

#Preview("Values & types – dark") {
    NavigationStack { SwiftBasicsScreen() }
        .preferredColorScheme(.dark)
}
