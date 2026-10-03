import SwiftUI

struct CategorySidebar: View {
    let categories: [NavigationCategory]
    @Binding var selection: NavigationCategory?

    var body: some View {
        List(selection: $selection) {
            ForEach(categories) { category in
                // Tag with the category itself: the implicit tag would be its String `id`, not matching the binding.
                CategoryRow(category: category)
                    .tag(category)
            }
        }
        .navigationTitle("GJP Lab")
    }
}

private struct CategoryRow: View {
    let category: NavigationCategory

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Image(systemName: category.systemImage)
                .font(.body.weight(.semibold))
                .frame(width: 24)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(category.title)
                    .font(.headline)
                Text(category.summary)
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
    @Previewable @State var selection: NavigationCategory?
    NavigationStack { CategorySidebar(categories: NavigationMenu.main.categories, selection: $selection) }
}
