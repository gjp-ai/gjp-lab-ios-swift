import SwiftUI

struct MainScreen: View {
    let onCategorySelected: (DashboardCategory) -> Void

    var body: some View {
        GeometryReader { geometry in
            let layout = DashboardLayout(width: geometry.size.width)

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("iOS lab")
                        .font(.largeTitle.bold())
                    Text("Choose a category to explore focused iOS samples.")
                        .font(.body)
                        .foregroundStyle(LabTheme.onSurfaceVariant)
                        .padding(.top, 6)
                        .padding(.bottom, layout.headerSpacing)

                    LazyVGrid(columns: layout.columns, spacing: 14) {
                        ForEach(DashboardCategory.allCases) { category in
                            Button {
                                onCategorySelected(category)
                            } label: {
                                CategoryCard(category: category, compact: layout.isCompact)
                                    .aspectRatio(layout.cardAspectRatio, contentMode: .fit)
                            }
                            .buttonStyle(.plain)
                            .accessibilityHint("Opens the \(category.title) catalogue")
                        }
                    }
                }
                .padding(.horizontal, layout.horizontalPadding)
                .padding(.top, layout.topPadding)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("GJP Lab")
        .navigationBarTitleDisplayMode(.inline)
        .labScreenBackground()
    }
}

private struct CategoryCard: View {
    let category: DashboardCategory
    let compact: Bool

    var body: some View {
        VStack(spacing: 0) {
            LabTheme.primary
                .frame(height: 6)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: compact ? 8 : 10) {
                    Image(systemName: category.systemImage)
                        .font(.system(size: compact ? 18 : 22, weight: .semibold))
                        .foregroundStyle(LabTheme.primary)
                        .frame(width: compact ? 20 : 24)
                    Text(category.title)
                        .font(compact ? .subheadline.bold() : .headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)
                }

                Text(category.dashboardDescription)
                    .font(.caption)
                    .foregroundStyle(LabTheme.onSurfaceVariant)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(compact ? 16 : 18)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .labCard()
        .contentShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

private struct DashboardLayout {
    let width: CGFloat

    var columnCount: Int {
        switch width {
        case ..<600: 2
        case 1100...: 5
        default: 3
        }
    }

    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 14), count: columnCount)
    }

    var isCompact: Bool { width < 600 }
    var cardAspectRatio: CGFloat { isCompact ? 1.1 : 1.45 }
    var horizontalPadding: CGFloat { isCompact ? 20 : (width < 1100 ? 32 : 40) }
    var topPadding: CGFloat { isCompact ? 16 : (width < 1100 ? 24 : 32) }
    var headerSpacing: CGFloat { isCompact ? 18 : 24 }
}

#Preview("Phone") {
    NavigationStack { MainScreen(onCategorySelected: { _ in }) }
        .frame(width: 390, height: 844)
}

#Preview("Phone – dark") {
    NavigationStack { MainScreen(onCategorySelected: { _ in }) }
        .preferredColorScheme(.dark)
        .frame(width: 390, height: 844)
}

#Preview("iPad") {
    NavigationStack { MainScreen(onCategorySelected: { _ in }) }
        .frame(width: 1194, height: 834)
}
