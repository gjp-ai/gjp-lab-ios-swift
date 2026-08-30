import SwiftUI

struct ContentView: View {
    @State private var path: [FeatureRoute] = []

    var body: some View {
        NavigationStack(path: $path) {
            MainScreen(onCategorySelected: { path.append(.catalog($0)) })
                .navigationDestination(for: FeatureRoute.self) { route in
                    switch route {
                    case .catalog(let category): FeatureCatalogScreen(category: category)
                    case .deviceInfo: DeviceInfoScreen()
                    case .urlSession:
                        URLSessionScreen(onResponse: { path.append(.response($0)) })
                    case .firebase: FirebaseFeatureScreen()
                    case .response(let response): HttpResponseScreen(response: response)
                    }
                }
        }
        .tint(LabTheme.primary)
    }
}
