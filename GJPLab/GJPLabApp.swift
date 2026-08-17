import SwiftUI

@main
struct GJPLabApp: App {
    @UIApplicationDelegateAdaptor(GJPLabAppDelegate.self) private var appDelegate
    @State private var showingSplash = true

    var body: some Scene {
        WindowGroup {
            Group { showingSplash ? AnyView(SplashScreen()) : AnyView(ContentView()) }
                .task {
                    try? await Task.sleep(for: .seconds(3))
                    showingSplash = false
                }
        }
    }
}
