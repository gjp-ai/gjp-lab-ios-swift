import SwiftUI

struct FeatureCatalogScreen: View {
    let category: DashboardCategory
    @Binding var selection: FeatureRoute?

    var body: some View {
        List(selection: $selection) {
            Section {
                ForEach(category.items) { item in
                    if let route = item.route {
                        CatalogRow(item: item, isAvailable: true)
                            .tag(route)
                    } else {
                        CatalogRow(item: item, isAvailable: false)
                    }
                }
            } header: {
                Text(category.catalogDescription)
                    .font(.subheadline)
                    .textCase(nil)
            }
        }
        .navigationTitle(category.title)
    }
}

private struct CatalogRow: View {
    let item: CatalogItem
    let isAvailable: Bool

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                Text(item.description)
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
    NavigationStack { FeatureCatalogScreen(category: .httpClient, selection: $selection) }
}

#Preview("SwiftUI catalogue – dark") {
    @Previewable @State var selection: FeatureRoute?
    NavigationStack { FeatureCatalogScreen(category: .swiftUI, selection: $selection) }
        .preferredColorScheme(.dark)
}
