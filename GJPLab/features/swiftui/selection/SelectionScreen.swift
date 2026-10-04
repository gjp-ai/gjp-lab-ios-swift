import SwiftUI

struct SelectionScreen: View {
    @State private var size = CoffeeSize.medium
    @State private var milk = Milk.oat
    @State private var shots = 2
    @State private var sweetness = 0.3
    @State private var isIced = false
    @State private var extras: Set<Extra> = [.cinnamon]
    @State private var pickup = Date.now.addingTimeInterval(15 * 60)
    @State private var cupColor = Color.gray

    var body: some View {
        Form {
            Section {
                Picker("Size", selection: $size) {
                    ForEach(CoffeeSize.allCases) { Text($0.title).tag($0) }
                }
                .pickerStyle(.segmented)
                Picker("Milk", selection: $milk) {
                    ForEach(Milk.allCases) { Text($0.title).tag($0) }
                }
                .pickerStyle(.menu)
            } header: {
                SectionHeader("Single choice with Picker")
            } footer: {
                Footer("Segmented suits two to five short options; a menu keeps longer lists compact.")
            }

            Section {
                Toggle("Iced", isOn: $isIced)
                Stepper("Espresso shots: \(shots)", value: $shots, in: 1...4)
                LabeledContent("Sweetness") {
                    Slider(value: $sweetness, in: 0...1) {
                        Text("Sweetness")
                    } minimumValueLabel: {
                        Image(systemName: "drop").accessibilityHidden(true)
                    } maximumValueLabel: {
                        Image(systemName: "drop.fill").accessibilityHidden(true)
                    }
                    .frame(maxWidth: 220)
                }
            } header: {
                SectionHeader("On/off and values")
            }

            Section {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), spacing: 8)], spacing: 8) {
                    ForEach(Extra.allCases) { extra in
                        Toggle(extra.title, isOn: binding(for: extra))
                            .toggleStyle(.button)
                            .buttonStyle(.bordered)
                            .frame(maxWidth: .infinity)
                    }
                }
            } header: {
                SectionHeader("Multi-selection")
            } footer: {
                Footer("A Set holds the selected extras. Each button-style Toggle reads and writes one member of the set.")
            }

            Section {
                DatePicker("Pickup", selection: $pickup, in: Date.now..., displayedComponents: [.date, .hourAndMinute])
                ColorPicker("Cup colour", selection: $cupColor, supportsOpacity: false)
            } header: {
                SectionHeader("Dates and colours")
            } footer: {
                Footer("The date range starts now, so past times cannot be chosen.")
            }

            Section {
                HStack(alignment: .top, spacing: 14) {
                    Image(systemName: isIced ? "takeoutbag.and.cup.and.straw.fill" : "cup.and.saucer.fill")
                        .font(.largeTitle)
                        .foregroundStyle(cupColor)
                        .frame(width: 52)
                        .accessibilityHidden(true)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(size.title) \(isIced ? "iced " : "")coffee, \(milk.title.lowercased()) milk")
                            .fontWeight(.semibold)
                        Text("\(shots) shot\(shots == 1 ? "" : "s"), \(sweetness.formatted(.percent.precision(.fractionLength(0)))) sweet")
                        Text(extrasSummary)
                        Text("Pickup \(pickup.formatted(date: .abbreviated, time: .shortened))")
                    }
                    .font(.subheadline)
                }
                .accessibilityElement(children: .combine)
            } header: {
                SectionHeader("Your order")
            }
        }
        .scrollContentBackground(.hidden)
        .labScreenBackground()
        .navigationTitle("Selection")
    }

    private var extrasSummary: String {
        let names = Extra.allCases.filter(extras.contains).map(\.title)
        return names.isEmpty ? "No extras" : names.formatted(.list(type: .and))
    }

    /// Turns "is this extra in the set?" into a `Binding<Bool>` that a Toggle can use.
    private func binding(for extra: Extra) -> Binding<Bool> {
        Binding {
            extras.contains(extra)
        } set: { isOn in
            if isOn {
                extras.insert(extra)
            } else {
                extras.remove(extra)
            }
        }
    }
}

private enum CoffeeSize: CaseIterable, Identifiable {
    case small, medium, large

    var id: Self { self }

    var title: String {
        switch self {
        case .small: "Small"
        case .medium: "Medium"
        case .large: "Large"
        }
    }
}

private enum Milk: CaseIterable, Identifiable {
    case none, whole, skim, oat, almond, soy

    var id: Self { self }

    var title: String {
        switch self {
        case .none: "No"
        case .whole: "Whole"
        case .skim: "Skim"
        case .oat: "Oat"
        case .almond: "Almond"
        case .soy: "Soy"
        }
    }
}

private enum Extra: CaseIterable, Identifiable {
    case cinnamon, vanilla, caramel, cream, cocoa

    var id: Self { self }

    var title: String {
        switch self {
        case .cinnamon: "Cinnamon"
        case .vanilla: "Vanilla"
        case .caramel: "Caramel"
        case .cream: "Cream"
        case .cocoa: "Cocoa"
        }
    }
}

private struct SectionHeader: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title).foregroundStyle(LabTheme.onSurfaceVariant)
    }
}

private struct Footer: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text).foregroundStyle(LabTheme.onSurfaceVariant)
    }
}

#Preview("Selection – light") {
    NavigationStack { SelectionScreen() }
}

#Preview("Selection – dark") {
    NavigationStack { SelectionScreen() }
        .preferredColorScheme(.dark)
}
