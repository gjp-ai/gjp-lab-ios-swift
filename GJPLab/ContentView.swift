import SwiftUI

struct ContentView: View {
    @State private var path: [FeatureRoute] = []

    var body: some View {
        NavigationStack(path: $path) {
            MainScreen(onFeatureSelected: { path.append($0) })
                .navigationDestination(for: FeatureRoute.self) { route in
                    switch route {
                    case .deviceInfo: DeviceInfoScreen()
                    case .http: HttpURLConnectionScreen()
                    case .firebase: FirebaseFeatureScreen()
                    case .response(let response): HttpResponseScreen(response: response)
                    }
                }
        }
    }
}
