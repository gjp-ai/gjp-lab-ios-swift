import SwiftUI

struct StringsRegexScreen: View {
    var body: some View {
        CodeSamplePage(
            title: "Strings & regex",
            intro: "Swift strings are Unicode-correct collections of characters. Regex finds and extracts text with compiler-checked patterns.",
            samples: StringsRegexSamples.all
        )
    }
}

#Preview("Strings & regex – light") {
    NavigationStack { StringsRegexScreen() }
}

#Preview("Strings & regex – dark") {
    NavigationStack { StringsRegexScreen() }
        .preferredColorScheme(.dark)
}
