import FirebaseAnalytics
import FirebaseCore
import FirebaseCrashlytics
import FirebaseMessaging
import FirebasePerformance
import FirebaseRemoteConfig
import UIKit
import UserNotifications

final class GJPLabAppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        guard FirebaseApp.app() == nil else { return true }
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

        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        requestNotificationAuthorization(application: application)
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        Crashlytics.crashlytics().log("APNs registration failed: \(error.localizedDescription)")
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken { Crashlytics.crashlytics().log("Received FCM registration token (\(fcmToken.count) characters)") }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }

    private func requestNotificationAuthorization(application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error { Crashlytics.crashlytics().record(error: error) }
            guard granted else { return }
            DispatchQueue.main.async { application.registerForRemoteNotifications() }
        }
    }
}
