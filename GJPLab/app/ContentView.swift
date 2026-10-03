import SwiftUI

struct ContentView: View {
    private let menu = NavigationMenu.main
    @State private var selectedCategory: NavigationCategory?
    @State private var selectedTopic: FeatureRoute?
    @State private var detailPath: [DetailRoute] = []
    @ObservedObject var callBlocker: BlockAppDuringCallsController

    var body: some View {
        NavigationSplitView {
            CategorySidebar(categories: menu.categories, selection: $selectedCategory)
        } content: {
            if let selectedCategory {
                FeatureCatalogScreen(category: selectedCategory, selection: $selectedTopic)
            } else {
                ContentUnavailableView("Choose a category", systemImage: "sidebar.left")
            }
        } detail: {
            NavigationStack(path: $detailPath) {
                Group {
                    if let selectedTopic {
                        feature(for: selectedTopic)
                    } else {
                        ContentUnavailableView("Choose a topic", systemImage: "list.bullet")
                    }
                }
                .navigationDestination(for: DetailRoute.self) { route in
                    switch route {
                    case .response(let response): HttpResponseScreen(response: response)
                    }
                }
            }
        }
        .tint(LabTheme.primary)
        .onChange(of: selectedCategory) { selectedTopic = nil }
        .onChange(of: selectedTopic) { detailPath = [] }
    }

    @ViewBuilder
    private func feature(for route: FeatureRoute) -> some View {
        switch route {
        case .deviceInfo: DeviceInfoScreen()
        case .urlSession:
            URLSessionScreen(onResponse: { response in
                // Ignore a late response if the user has already moved to another topic.
                guard selectedTopic == .urlSession else { return }
                detailPath.append(.response(response))
            })
        case .firebase: FirebaseFeatureScreen()
        case .blockAppDuringCalls:
            BlockAppDuringCallsScreen(controller: callBlocker)
        }
    }
}

#Preview("iPhone") {
    ContentView(callBlocker: BlockAppDuringCallsController(storefrontCountryCode: "SGP"))
}
