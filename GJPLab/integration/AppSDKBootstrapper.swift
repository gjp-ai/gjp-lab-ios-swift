import UIKit

final class AppSDKBootstrapper {
    private let integrations: [SDKIntegration]

    init() {
        integrations = [FirebaseStartupIntegration()]
    }

    func configure(application: UIApplication) {
        integrations.forEach { $0.configure(application: application) }
    }

    func didRegisterForRemoteNotifications(with deviceToken: Data) {
        integrations.forEach { $0.didRegisterForRemoteNotifications(with: deviceToken) }
    }

    func didFailToRegisterForRemoteNotifications(with error: Error) {
        integrations.forEach { $0.didFailToRegisterForRemoteNotifications(with: error) }
    }
}

protocol SDKIntegration {
    func configure(application: UIApplication)
    func didRegisterForRemoteNotifications(with deviceToken: Data)
    func didFailToRegisterForRemoteNotifications(with error: Error)
}
