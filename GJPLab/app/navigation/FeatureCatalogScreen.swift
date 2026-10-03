import SwiftUI

struct FeatureCatalogScreen: View {
    let category: NavigationCategory
    @Binding var selection: FeatureRoute?

    var body: some View {
        List(selection: $selection) {
            Section {
                ForEach(category.topics) { topic in
                    if let route = topic.route {
                        CatalogRow(topic: topic, isAvailable: true)
                            .tag(route)
                    } else {
                        CatalogRow(topic: topic, isAvailable: false)
                    }
                }
            } header: {
                Text(category.description)
                    .font(.subheadline)
                    .textCase(nil)
            }
        }
        .navigationTitle(category.title)
    }
}

private struct CatalogRow: View {
    let topic: NavigationTopic
    let isAvailable: Bool

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(topic.title)
                    .font(.headline)
                Text(topic.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 12)
            Image(systemName: isAvailable ? "chevron.right" : "clock")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(isAvailable ? .primary : .secondary)
                .accessibilityLabel(isAvailable ? "Open" : "Planned")
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
    }
}

#Preview("HTTP client catalogue") {
    @Previewable @State var selection: FeatureRoute?
    NavigationStack { FeatureCatalogScreen(category: NavigationMenu.main.category(id: "httpClient")!, selection: $selection) }
}

#Preview("SwiftUI catalogue – dark") {
    @Previewable @State var selection: FeatureRoute?
    NavigationStack { FeatureCatalogScreen(category: NavigationMenu.main.category(id: "swiftUI")!, selection: $selection) }
        .preferredColorScheme(.dark)
}
