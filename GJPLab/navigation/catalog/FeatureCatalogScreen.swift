import SwiftUI

struct FeatureCatalogScreen: View {
    let category: DashboardCategory

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text(category.title)
                    .font(.largeTitle.bold())
                Text(category.catalogDescription)
                    .font(.body)
                    .foregroundStyle(LabTheme.onSurfaceVariant)
                    .padding(.top, 6)
                    .padding(.bottom, 22)

                CatalogTable(items: category.items)
            }
            .frame(maxWidth: 720, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 24)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle(category.title)
        .navigationBarTitleDisplayMode(.inline)
        .labScreenBackground()
    }
}

private struct CatalogTable: View {
    let items: [CatalogItem]

    var body: some View {
        VStack(spacing: 0) {
            LabTheme.primary.frame(height: 6)

            HStack {
                Text("Component").font(.subheadline.bold())
                Spacer()
                Text("Status")
                    .font(.subheadline)
                    .foregroundStyle(LabTheme.onSurfaceVariant)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)

            Divider().overlay(LabTheme.outlineVariant)

            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                CatalogRow(item: item)
                if index < items.count - 1 {
                    Divider()
                        .overlay(LabTheme.outlineVariant.opacity(0.7))
                        .padding(.leading, 20)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .labCard()
    }
}

private struct CatalogRow: View {
    let item: CatalogItem

    var body: some View {
        Group {
            if let route = item.route {
                NavigationLink(value: route) { rowContent(isAvailable: true) }
                    .buttonStyle(.plain)
                    .accessibilityHint("Opens \(item.title)")
            } else {
                rowContent(isAvailable: false)
            }
        }
    }

    private func rowContent(isAvailable: Bool) -> some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                Text(item.description)
                    .font(.caption)
                    .foregroundStyle(LabTheme.onSurfaceVariant)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 12)
            Image(systemName: isAvailable ? "chevron.right" : "clock")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(isAvailable ? LabTheme.primary : LabTheme.onSurfaceVariant)
                .accessibilityLabel(isAvailable ? "Open" : "Planned")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .contentShape(Rectangle())
    }
}

#Preview("HTTP client catalogue") {
    NavigationStack { FeatureCatalogScreen(category: .httpClient) }
}

#Preview("SwiftUI catalogue – dark") {
    NavigationStack { FeatureCatalogScreen(category: .swiftUI) }
        .preferredColorScheme(.dark)
}
