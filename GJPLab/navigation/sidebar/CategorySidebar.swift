import SwiftUI

struct CategorySidebar: View {
    @Binding var selection: DashboardCategory?

    var body: some View {
        List(DashboardCategory.allCases, selection: $selection) { category in
            CategoryRow(category: category)
        }
        .navigationTitle("GJP Lab")
    }
}

private struct CategoryRow: View {
    let category: DashboardCategory

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Image(systemName: category.systemImage)
                .font(.body.weight(.semibold))
                .frame(width: 24)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(category.title)
                    .font(.headline)
                Text(category.dashboardDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(availability)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Opens the \(category.title) catalogue")
    }

    private var availability: String {
        let count = category.availableTopicCount
        return count > 0 ? "\(count) available" : "Planned"
    }
}

#Preview {
    @Previewable @State var selection: DashboardCategory?
    NavigationStack { CategorySidebar(selection: $selection) }
}
