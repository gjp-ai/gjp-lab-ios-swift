import FirebaseCrashlytics
import FirebaseMessaging
import UserNotifications

final class FirebaseMessagingHandler: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    func configure() {
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
    }

    func didRegisterForRemoteNotifications(with deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func didFailToRegisterForRemoteNotifications(with error: Error) {
        Crashlytics.crashlytics().log("APNs registration failed: \(error.localizedDescription)")
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken {
            Crashlytics.crashlytics().log("Received FCM registration token (\(fcmToken.count) characters)")
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
}
