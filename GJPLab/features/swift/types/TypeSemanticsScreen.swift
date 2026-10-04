import SwiftUI

struct TypeSemanticsScreen: View {
    var body: some View {
        CodeSamplePage(
            title: "Structs, classes & enums",
            intro: "Structs and enums are value types: each copy is independent. Classes are reference types: copies share one instance.",
            samples: TypeSemanticsSamples.all
        )
    }
}

#Preview("Structs, classes & enums – light") {
    NavigationStack { TypeSemanticsScreen() }
}

#Preview("Structs, classes & enums – dark") {
    NavigationStack { TypeSemanticsScreen() }
        .preferredColorScheme(.dark)
}
