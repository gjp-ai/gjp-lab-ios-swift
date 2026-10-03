import SwiftUI

struct FeatureCatalogScreen: View {
    let category: NavigationCategory
    @Binding var selection: FeatureRoute?

    var body: some View {
        List(selection: $selection) {
            // The description is a plain, untagged row (not selectable), so it scrolls with the cards
            // instead of becoming a pinned section header.
            Text(category.description)
                .font(.subheadline)
                .foregroundStyle(LabTheme.onSurfaceVariant)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 4, leading: 20, bottom: 8, trailing: 20))

            ForEach(category.topics) { topic in
                if let route = topic.route {
                    CatalogRow(topic: topic, isAvailable: true)
                        .labListCard(isSelected: selection == route)
                        .tag(route)
                } else {
                    CatalogRow(topic: topic, isAvailable: false)
                        .labListCard()
                }
            }
        }
        // Each topic is its own card on the same Slate canvas as every other screen (like the sidebar).
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .labScreenBackground()
        .navigationTitle(category.title)
    }
}

private struct CatalogRow: View {
    let topic: NavigationTopic
    let isAvailable: Bool

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(topic.title)
                    .font(.headline)
                    .foregroundStyle(LabTheme.onSurface)
                Text(topic.description)
                    .font(.subheadline)
                    .foregroundStyle(LabTheme.onSurfaceVariant)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 12)
            Image(systemName: isAvailable ? "chevron.right" : "clock")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(isAvailable ? LabTheme.onSurface : LabTheme.onSurfaceVariant)
                .accessibilityLabel(isAvailable ? "Open" : "Planned")
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview("HTTP client catalogue – light") {
    @Previewable @State var selection: FeatureRoute?
    NavigationStack { FeatureCatalogScreen(category: NavigationMenu.main.category(id: "httpClient")!, selection: $selection) }
}

#Preview("HTTP client catalogue – dark") {
    @Previewable @State var selection: FeatureRoute?
    NavigationStack { FeatureCatalogScreen(category: NavigationMenu.main.category(id: "httpClient")!, selection: $selection) }
        .preferredColorScheme(.dark)
}

#Preview("SwiftUI catalogue – light") {
    @Previewable @State var selection: FeatureRoute?
    NavigationStack { FeatureCatalogScreen(category: NavigationMenu.main.category(id: "swiftUI")!, selection: $selection) }
}

#Preview("SwiftUI catalogue – dark") {
    @Previewable @State var selection: FeatureRoute?
    NavigationStack { FeatureCatalogScreen(category: NavigationMenu.main.category(id: "swiftUI")!, selection: $selection) }
        .preferredColorScheme(.dark)
}
