import Foundation

enum AppConfig {
    static let minimumSplashDuration: Duration = .seconds(3)
    static let remoteConfigTimeout: Duration = .seconds(5)
    static let isBlockAppDuringCall: Bool = true

    /// Launch argument passed by the UI tests (`GJPLabUITests` uses the same string).
    static let uiTestingArgument = "-ui-testing"

    /// True when the UI tests launched the app. The app then starts no SDKs (no Firebase, no Remote Config
    /// fetch, no notification prompt) and skips the splash, so tests start fast and never touch live services.
    static let isUITesting = ProcessInfo.processInfo.arguments.contains(uiTestingArgument)
}
