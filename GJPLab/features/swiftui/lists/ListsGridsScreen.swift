import SwiftUI

struct ListsGridsScreen: View {
    @State private var items = Produce.samples
    @State private var query = ""
    @State private var presentation = Presentation.list

    var body: some View {
        Group {
            if filteredItems.isEmpty {
                ContentUnavailableView.search(text: query)
            } else {
                switch presentation {
                case .list: list
                case .grid: grid
                }
            }
        }
        .safeAreaInset(edge: .top) {
            Picker("Presentation", selection: $presentation) {
                ForEach(Presentation.allCases) { Text($0.title).tag($0) }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .frame(maxWidth: 720)
        }
        .searchable(text: $query, prompt: "Search produce")
        .refreshable {
            // Pull to refresh restores deleted rows; the pause stands in for a network reload.
            try? await Task.sleep(for: .seconds(1))
            items = Produce.samples
        }
        .labScreenBackground()
        .navigationTitle("Lists & grids")
        .toolbar {
            if presentation == .list {
                EditButton()
            }
        }
    }

    private var filteredItems: [Produce] {
        query.isEmpty ? items : items.filter { $0.name.localizedStandardContains(query) }
    }

    private var list: some View {
        List {
            ForEach(Produce.Kind.allCases, id: \.self) { kind in
                let rows = filteredItems.filter { $0.kind == kind }
                if !rows.isEmpty {
                    Section {
                        ForEach(rows) { item in
                            ProduceRow(item: item)
                                .swipeActions(edge: .leading) {
                                    Button(item.isFavorite ? "Unfavourite" : "Favourite", systemImage: "star") {
                                        toggleFavorite(item)
                                    }
                                    .tint(LabTheme.primary)
                                }
                                .swipeActions(edge: .trailing) {
                                    Button("Delete", systemImage: "trash", role: .destructive) {
                                        delete(item)
                                    }
                                }
                        }
                        .onDelete { offsets in
                            offsets.map { rows[$0] }.forEach(delete)
                        }
                        .listRowBackground(LabTheme.surface)
                    } header: {
                        Text("\(kind.title) (\(rows.count))").foregroundStyle(LabTheme.onSurfaceVariant)
                    }
                }
            }

            Section {
                EmptyView()
            } footer: {
                Text("Swipe a row for actions, pull down to restore deleted rows, or tap Edit to delete several.")
                    .foregroundStyle(LabTheme.onSurfaceVariant)
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
    }

    private var grid: some View {
        ScrollView {
            // Adaptive columns fit as many 100-point cells as the width allows: 3 on iPhone, more on iPad.
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 12)], spacing: 12) {
                ForEach(filteredItems) { item in
                    ProduceTile(item: item) { toggleFavorite(item) }
                }
            }
            .frame(maxWidth: 720)
            .padding(20)
            .frame(maxWidth: .infinity)
        }
    }

    private func toggleFavorite(_ item: Produce) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].isFavorite.toggle()
    }

    private func delete(_ item: Produce) {
        items.removeAll { $0.id == item.id }
    }
}

private enum Presentation: CaseIterable, Identifiable {
    case list, grid

    var id: Self { self }

    var title: String {
        switch self {
        case .list: "List"
        case .grid: "Grid"
        }
    }
}

private struct ProduceRow: View {
    let item: Produce

    var body: some View {
        HStack(spacing: 12) {
            Text(item.emoji)
                .font(.title2)
                .accessibilityHidden(true)
            Text(item.name)
            Spacer()
            if item.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundStyle(LabTheme.onSurfaceVariant)
                    .accessibilityLabel("Favourite")
            }
        }
        .accessibilityElement(children: .combine)
    }
}

private struct ProduceTile: View {
    let item: Produce
    let toggleFavorite: () -> Void

    var body: some View {
        Button(action: toggleFavorite) {
            VStack(spacing: 8) {
                Text(item.emoji)
                    .font(.largeTitle)
                    .accessibilityHidden(true)
                Text(item.name)
                    .font(.subheadline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Image(systemName: item.isFavorite ? "star.fill" : "star")
                    .font(.caption)
                    .foregroundStyle(LabTheme.onSurfaceVariant)
                    .accessibilityHidden(true)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .labListTile()
        }
        .buttonStyle(.plain)
        .accessibilityValue(item.isFavorite ? "Favourite" : "")
        .accessibilityHint("Toggles favourite")
    }
}

private extension View {
    func labListTile() -> some View {
        let shape = RoundedRectangle(cornerRadius: 16, style: .continuous)
        return background(LabTheme.surface, in: shape)
            .overlay { shape.strokeBorder(LabTheme.outlineVariant, lineWidth: 0.5) }
            .contentShape(shape)
    }
}

#Preview("Lists & grids – light") {
    NavigationStack { ListsGridsScreen() }
}

#Preview("Lists & grids – dark") {
    NavigationStack { ListsGridsScreen() }
        .preferredColorScheme(.dark)
}
