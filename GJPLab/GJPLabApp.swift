import SwiftUI

@main
struct GJPLabApp: App {
    @UIApplicationDelegateAdaptor(GJPLabAppDelegate.self) private var appDelegate
    @State private var showingSplash = true
    @State private var maintenanceEnabled = false
    @StateObject private var firebaseIntegration = FirebaseIntegration()

    var body: some Scene {
        WindowGroup {
            Group {
                if showingSplash {
                    SplashScreen()
                } else if maintenanceEnabled {
                    MaintenanceScreen {
                        Task {
                            maintenanceEnabled = await loadMaintenanceMode()
                        }
                    }
                } else {
                    ContentView()
                }
            }
                .tint(LabTheme.primary)
                .task {
                    async let fetchedMaintenanceMode = loadMaintenanceMode()
                    try? await Task.sleep(for: AppConfig.minimumSplashDuration)
                    maintenanceEnabled = await fetchedMaintenanceMode
                    showingSplash = false
                }
        }
    }

    private func loadMaintenanceMode() async -> Bool {
        await withTaskGroup(of: Bool?.self) { group in
            group.addTask {
                await firebaseIntegration.fetchMaintenanceMode()
            }
            group.addTask {
                try? await Task.sleep(for: AppConfig.remoteConfigTimeout)
                return nil
            }

            let result = await group.next() ?? nil
            group.cancelAll()
            return result ?? false
        }
    }
}
