import Combine
import FirebaseAnalytics
import FirebaseCrashlytics
import FirebaseMessaging
import FirebasePerformance
import FirebaseRemoteConfig
import Foundation
import UIKit

@MainActor
final class FirebaseIntegration: ObservableObject {
    @Published var analyticsStatus = "No event sent yet"
    @Published var crashlyticsStatus = "No non-fatal exception recorded yet"
    @Published var remoteConfigStatus = "Not fetched yet"
    @Published var performanceStatus = "No custom trace completed yet"
    @Published var messagingStatus = "Token not loaded yet"
    @Published var messagingToken: String?
    @Published var tokenCopied = false

    let configurationProjectID: String

    init() {
        let plist = Bundle.main.url(forResource: "GoogleService-Info", withExtension: "plist").flatMap { NSDictionary(contentsOf: $0) }
        configurationProjectID = plist?["PROJECT_ID"] as? String ?? "Not configured"
        analyticsStatus = "App started (\(FirebaseConstants.appStarted))"
    }

    func logFeatureOpened() { Analytics.logEvent(FirebaseConstants.featureOpened, parameters: nil); analyticsStatus = "\(FirebaseConstants.featureOpened) sent" }

    func recordCrashlyticsDemo() {
        let error = NSError(domain: "GJPLab.FirebaseDemo", code: 1, userInfo: [NSLocalizedDescriptionKey: "GJPLab Crashlytics demo exception"])
        let crashlytics = Crashlytics.crashlytics()
        crashlytics.log("Firebase feature Crashlytics demo")
        crashlytics.setCustomValue(true, forKey: "firebase_demo")
        crashlytics.record(error: error)
        crashlyticsStatus = "Non-fatal demo exception recorded"
    }

    func fetchMaintenanceMode() async {
        remoteConfigStatus = "Fetching maintenance flag..."
        let remoteConfig = RemoteConfig.remoteConfig()
        do {
            _ = try await remoteConfig.fetchAndActivate()
            remoteConfigStatus = "\(FirebaseConstants.maintenanceEnabled) = \(remoteConfig[FirebaseConstants.maintenanceEnabled].boolValue)"
        } catch { remoteConfigStatus = "Fetch failed: \(error.localizedDescription)" }
    }

    func runPerformanceDemo() async {
        performanceStatus = "Running custom trace..."
        guard let trace = Performance.startTrace(name: FirebaseConstants.performanceTrace) else { performanceStatus = "Unable to start custom trace"; return }
        let started = Date()
        try? await Task.sleep(for: .milliseconds(300))
        trace.stop()
        performanceStatus = "\(FirebaseConstants.performanceTrace) completed in \(Int(Date().timeIntervalSince(started) * 1000)) ms"
    }

    func fetchMessagingToken() async {
        messagingStatus = "Loading registration token..."
        do { messagingToken = try await Messaging.messaging().token(); messagingStatus = "Full token loaded" }
        catch { messagingStatus = "Token error: \(error.localizedDescription)" }
    }

    func subscribeToDemoTopic() {
        messagingStatus = "Subscribing to \(FirebaseConstants.demoTopic)..."
        Task {
            do { try await Messaging.messaging().subscribe(toTopic: FirebaseConstants.demoTopic); messagingStatus = "Subscribed to \(FirebaseConstants.demoTopic)" }
            catch { messagingStatus = "Topic subscription failed: \(error.localizedDescription)" }
        }
    }
    func copyToken() { guard let messagingToken else { return }; UIPasteboard.general.string = messagingToken; tokenCopied = true }
}

