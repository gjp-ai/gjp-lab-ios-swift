import SwiftUI

struct LayoutsScreen: View {
    @State private var stack = StackKind.horizontal
    @State private var spacing = 12.0
    @State private var fitWidth = 320.0

    private let tags = ["HStack", "VStack", "ZStack", "Grid", "LazyVGrid", "ViewThatFits", "Spacer", "frame", "alignment", "Layout"]

    var body: some View {
        LabDemoPage(
            title: "Layouts",
            intro: "A parent proposes a size, the child chooses its own size, and the parent places it. Stacks, grids, and custom layouts all follow this rule."
        ) {
            LabDemoSection(
                title: "Stacks and AnyLayout",
                caption: "AnyLayout switches between stack types without rebuilding the children, so the change can animate."
            ) {
                Picker("Stack", selection: $stack) {
                    ForEach(StackKind.allCases) { Text($0.title).tag($0) }
                }
                .pickerStyle(.segmented)

                let layout = stack.layout(spacing: spacing)
                layout {
                    ForEach(0..<3) { index in
                        NumberedBox(number: index + 1, side: 72 - CGFloat(index) * 20, isEmphasized: index == 2)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 160)
                .animation(.spring, value: stack)
                .animation(.spring, value: spacing)

                Slider(value: $spacing, in: 0...40, step: 2) {
                    Text("Spacing")
                }
                .disabled(stack == .layered)
            }

            LabDemoSection(
                title: "Grid alignment",
                caption: "Grid lines up cells in rows and columns; each column takes the width of its widest cell."
            ) {
                Grid(alignment: .leading, horizontalSpacing: 16, verticalSpacing: 10) {
                    GridRow {
                        Text("Layout").fontWeight(.semibold)
                        Text("Lazy").fontWeight(.semibold)
                        Text("Use for").fontWeight(.semibold)
                    }
                    Divider().gridCellUnsizedAxes(.horizontal)
                    GridRow {
                        Text("VStack")
                        Text("No")
                        Text("A few views")
                    }
                    GridRow {
                        Text("LazyVStack")
                        Text("Yes")
                        Text("Long scrolling content")
                    }
                    GridRow {
                        Text("Grid")
                        Text("No")
                        Text("Aligned tables")
                    }
                }
                .font(.subheadline)
            }

            LabDemoSection(
                title: "ViewThatFits",
                caption: "ViewThatFits picks the first child that fits the space. Narrow the box to switch from a row to a column."
            ) {
                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 8) { choiceButtons }
                    VStack(alignment: .leading, spacing: 8) { choiceButtons }
                }
                .padding(12)
                .frame(width: fitWidth, alignment: .leading)
                .border(LabTheme.outlineVariant)
                .frame(maxWidth: .infinity, alignment: .leading)

                Slider(value: $fitWidth, in: 140...320) {
                    Text("Box width")
                }
            }

            LabDemoSection(
                title: "Custom Layout",
                caption: "FlowLayout adopts the Layout protocol to wrap tags onto new rows, like words in a paragraph."
            ) {
                FlowLayout(spacing: 8) {
                    ForEach(tags, id: \.self) { tag in
                        Text(tag)
                            .font(.subheadline)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(LabTheme.surfaceContainer, in: Capsule())
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var choiceButtons: some View {
        Button("Accept") {}.buttonStyle(.bordered)
        Button("Decline") {}.buttonStyle(.bordered)
        Button("Ask later") {}.buttonStyle(.bordered)
    }
}

private enum StackKind: CaseIterable, Identifiable {
    case horizontal, vertical, layered

    var id: Self { self }

    var title: String {
        switch self {
        case .horizontal: "HStack"
        case .vertical: "VStack"
        case .layered: "ZStack"
        }
    }

    func layout(spacing: Double) -> AnyLayout {
        switch self {
        case .horizontal: AnyLayout(HStackLayout(spacing: spacing))
        case .vertical: AnyLayout(VStackLayout(spacing: spacing))
        case .layered: AnyLayout(ZStackLayout())
        }
    }
}

private struct NumberedBox: View {
    let number: Int
    let side: CGFloat
    let isEmphasized: Bool

    var body: some View {
        Text("\(number)")
            .font(.headline)
            .foregroundStyle(isEmphasized ? LabTheme.onPrimary : LabTheme.onSurface)
            .frame(width: side, height: side)
            .background(
                isEmphasized ? LabTheme.primary : LabTheme.primaryContainer,
                in: RoundedRectangle(cornerRadius: 10, style: .continuous)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous).strokeBorder(LabTheme.outlineVariant)
            }
    }
}

#Preview("Layouts – light") {
    NavigationStack { LayoutsScreen() }
}

#Preview("Layouts – dark") {
    NavigationStack { LayoutsScreen() }
        .preferredColorScheme(.dark)
}
