import SwiftUI

struct CollectionsScreen: View {
    var body: some View {
        CodeSamplePage(
            title: "Collections",
            intro: "Arrays keep order, sets keep unique values, and dictionaries map keys to values. All three are value types.",
            samples: CollectionsSamples.all
        )
    }
}

#Preview("Collections – light") {
    NavigationStack { CollectionsScreen() }
}

#Preview("Collections – dark") {
    NavigationStack { CollectionsScreen() }
        .preferredColorScheme(.dark)
}
