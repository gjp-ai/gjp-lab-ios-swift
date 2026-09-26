import UIKit

final class GJPLabAppDelegate: NSObject, UIApplicationDelegate {
    private let sdkBootstrapper = AppSDKBootstrapper()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        sdkBootstrapper.configure(application: application)
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        sdkBootstrapper.didRegisterForRemoteNotifications(with: deviceToken)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        sdkBootstrapper.didFailToRegisterForRemoteNotifications(with: error)
    }
}
