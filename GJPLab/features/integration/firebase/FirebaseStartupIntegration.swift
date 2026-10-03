import FirebaseAnalytics
import FirebaseCore
import FirebaseCrashlytics
import FirebaseRemoteConfig
import UIKit
import UserNotifications

final class FirebaseStartupIntegration: SDKIntegration {
    private let messagingHandler = FirebaseMessagingHandler()

    func configure(application: UIApplication) {
        guard FirebaseApp.app() == nil else { return }
        FirebaseApp.configure()

        Analytics.logEvent(FirebaseConstants.appStarted, parameters: nil)
        Crashlytics.crashlytics().setCustomValue(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "unknown", forKey: "app_version")

        let remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        #if DEBUG
        settings.minimumFetchInterval = 0
        #else
        settings.minimumFetchInterval = 3600
        #endif
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults([FirebaseConstants.maintenanceEnabled: NSNumber(value: false)])

        messagingHandler.configure()
        requestNotificationAuthorization(application: application)
    }

    func didRegisterForRemoteNotifications(with deviceToken: Data) {
        messagingHandler.didRegisterForRemoteNotifications(with: deviceToken)
    }

    func didFailToRegisterForRemoteNotifications(with error: Error) {
        messagingHandler.didFailToRegisterForRemoteNotifications(with: error)
    }

    private func requestNotificationAuthorization(application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error { Crashlytics.crashlytics().record(error: error) }
            guard granted else { return }
            DispatchQueue.main.async { application.registerForRemoteNotifications() }
        }
    }
}
