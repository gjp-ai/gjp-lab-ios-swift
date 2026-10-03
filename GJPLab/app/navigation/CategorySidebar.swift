import SwiftUI

struct CategorySidebar: View {
    let categories: [NavigationCategory]
    @Binding var selection: NavigationCategory?

    var body: some View {
        List(selection: $selection) {
            ForEach(categories) { category in
                // Tag with the category itself: the implicit tag would be its String `id`, not matching the binding.
                CategoryRow(category: category)
                    .labListCard(isSelected: selection == category)
                    .tag(category)
            }
        }
        // Each row is its own card on the same Slate canvas as every other screen.
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .labScreenBackground()
        .navigationTitle("GJP Lab")
    }
}

private struct CategoryRow: View {
    let category: NavigationCategory

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: category.systemImage)
                .font(.title3.weight(.semibold))
                .foregroundStyle(LabTheme.onSurface)
                .frame(width: 44, height: 44)
                .background(LabTheme.primaryContainer, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 6) {
                Text(category.title)
                    .font(.headline)
                    .foregroundStyle(LabTheme.onSurface)
                Text(category.summary)
                    .font(.subheadline)
                    .foregroundStyle(LabTheme.onSurfaceVariant)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint("Opens the \(category.title) catalogue")
    }
}

#Preview("Sidebar – light") {
    @Previewable @State var selection: NavigationCategory?
    NavigationStack { CategorySidebar(categories: NavigationMenu.main.categories, selection: $selection) }
}

#Preview("Sidebar – dark") {
    @Previewable @State var selection: NavigationCategory?
    NavigationStack { CategorySidebar(categories: NavigationMenu.main.categories, selection: $selection) }
        .preferredColorScheme(.dark)
}
