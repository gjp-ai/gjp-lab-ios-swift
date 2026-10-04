import SwiftUI

struct ButtonsScreen: View {
    @State private var lastAction = "None yet"
    @State private var sortOrder = SortOrder.newest
    @State private var isConfirmingDelete = false
    @State private var isShowingAlert = false
    @State private var isSaving = false
    @State private var isFavorite = false

    var body: some View {
        LabDemoPage(
            title: "Buttons & actions",
            intro: "A Button pairs a label with an action. Styles change how it looks; roles, menus, and gestures change how people reach the action."
        ) {
            LabeledContent("Last action") {
                Text(lastAction)
                    .foregroundStyle(LabTheme.onSurfaceVariant)
                    .contentTransition(.opacity)
            }
            .padding(14)
            .labCard(cornerRadius: 14)

            LabDemoSection(
                title: "Styles and sizes",
                caption: "A ButtonStyle changes the look without changing the action. .labPrimary is this app's main action style."
            ) {
                FlowRow {
                    Button("Primary") { record("Primary") }.buttonStyle(.labPrimary)
                    Button("Bordered") { record("Bordered") }.buttonStyle(.bordered)
                    Button("Borderless") { record("Borderless") }.buttonStyle(.borderless)
                    Button("Plain") { record("Plain") }.buttonStyle(.plain)
                }
                HStack(spacing: 8) {
                    Button("Small") { record("Small") }.controlSize(.small)
                    Button("Regular") { record("Regular") }
                    Button("Large") { record("Large") }.controlSize(.large)
                }
                .buttonStyle(.bordered)
            }

            LabDemoSection(
                title: "Roles and confirmation",
                caption: "A destructive role draws the action in red and asks the system to treat it with care. Confirm before deleting."
            ) {
                HStack(spacing: 8) {
                    Button("Delete draft", systemImage: "trash", role: .destructive) {
                        isConfirmingDelete = true
                    }
                    Button("Show alert", systemImage: "exclamationmark.bubble") {
                        isShowingAlert = true
                    }
                }
                .buttonStyle(.bordered)
                .confirmationDialog("Delete this draft?", isPresented: $isConfirmingDelete, titleVisibility: .visible) {
                    Button("Delete", role: .destructive) { record("Deleted draft") }
                    Button("Cancel", role: .cancel) { record("Cancelled delete") }
                } message: {
                    Text("This sample does not delete anything.")
                }
                .alert("Heads up", isPresented: $isShowingAlert) {
                    Button("OK") { record("Dismissed alert") }
                } message: {
                    Text("Alerts interrupt, so keep them for information people must see now.")
                }
            }

            LabDemoSection(
                title: "Menus and context menus",
                caption: "A Menu groups related actions behind one button. Touch and hold the card for its context menu."
            ) {
                Menu {
                    Picker("Sort by", selection: $sortOrder) {
                        ForEach(SortOrder.allCases) { Text($0.title).tag($0) }
                    }
                    Divider()
                    Button("Refresh", systemImage: "arrow.clockwise") { record("Refreshed") }
                } label: {
                    Label("Sort: \(sortOrder.title)", systemImage: "arrow.up.arrow.down")
                }
                .onChange(of: sortOrder) { _, order in record("Sorted by \(order.title.lowercased())") }

                Label("Touch and hold this card", systemImage: "hand.tap")
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(LabTheme.surfaceContainer, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .contentShape(.contextMenuPreview, RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .contextMenu {
                        Button("Copy", systemImage: "doc.on.doc") { record("Copied") }
                        Button("Share", systemImage: "square.and.arrow.up") { record("Shared") }
                        Button("Remove", systemImage: "trash", role: .destructive) { record("Removed") }
                    }
            }

            LabDemoSection(
                title: "Gestures",
                caption: "Gestures add actions to any view. Prefer a Button when there is one obvious action: it works with VoiceOver and keyboards for free."
            ) {
                Text("Double-tap or long-press me")
                    .padding(14)
                    .frame(maxWidth: .infinity)
                    .background(LabTheme.surfaceContainer, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .onTapGesture(count: 2) { record("Double-tapped") }
                    .onLongPressGesture { record("Long-pressed") }
                    .accessibilityAddTraits(.isButton)
                    .accessibilityAction(named: "Double-tap") { record("Double-tapped") }
                    .accessibilityAction(named: "Long-press") { record("Long-pressed") }
            }

            LabDemoSection(
                title: "Async actions and touch targets",
                caption: "Disable a button while its work runs so it cannot start twice. Icon-only buttons need a 44-point target and a label."
            ) {
                HStack(spacing: 16) {
                    Button(action: save) {
                        HStack(spacing: 8) {
                            if isSaving { ProgressView().tint(LabTheme.onSurfaceVariant) }
                            Text(isSaving ? "Saving…" : "Save")
                        }
                    }
                    .buttonStyle(.labPrimary)
                    .disabled(isSaving)

                    Button {
                        isFavorite.toggle()
                        record(isFavorite ? "Added favourite" : "Removed favourite")
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.title2)
                            .frame(minWidth: 44, minHeight: 44)
                            .contentShape(Rectangle())
                    }
                    .accessibilityLabel(isFavorite ? "Remove favourite" : "Add favourite")
                }
            }
        }
        .animation(.default, value: lastAction)
    }

    private func record(_ action: String) {
        lastAction = action
    }

    private func save() {
        isSaving = true
        Task {
            // Stands in for real work such as a repository call.
            try? await Task.sleep(for: .seconds(1.5))
            isSaving = false
            record("Saved")
        }
    }
}

private enum SortOrder: CaseIterable, Identifiable {
    case newest, oldest, name

    var id: Self { self }

    var title: String {
        switch self {
        case .newest: "Newest"
        case .oldest: "Oldest"
        case .name: "Name"
        }
    }
}

/// Lays buttons out in a row, falling back to two rows when the row does not fit.
private struct FlowRow<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 12) { content }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), alignment: .leading)], alignment: .leading, spacing: 12) {
                content
            }
        }
    }
}

#Preview("Buttons & actions – light") {
    NavigationStack { ButtonsScreen() }
}

#Preview("Buttons & actions – dark") {
    NavigationStack { ButtonsScreen() }
        .preferredColorScheme(.dark)
}
