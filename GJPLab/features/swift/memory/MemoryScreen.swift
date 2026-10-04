import SwiftUI

struct MemoryScreen: View {
    var body: some View {
        CodeSamplePage(
            title: "Memory management",
            intro: "Swift frees class instances with automatic reference counting (ARC). The samples log from deinit to show exactly when that happens.",
            samples: MemorySamples.all
        )
    }
}

#Preview("Memory management – light") {
    NavigationStack { MemoryScreen() }
}

#Preview("Memory management – dark") {
    NavigationStack { MemoryScreen() }
        .preferredColorScheme(.dark)
}
