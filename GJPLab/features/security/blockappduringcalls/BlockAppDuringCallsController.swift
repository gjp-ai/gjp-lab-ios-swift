import CallKit
import Combine
import StoreKit

@MainActor
final class BlockAppDuringCallsController: NSObject, ObservableObject {
    enum Availability: Equatable {
        case checking
        case available
        case unavailableInChina
        case unavailable
    }

    private enum DefaultsKey {
        static let isEnabled = "security.blockAppDuringCalls.isEnabled"
    }

    @Published private(set) var availability: Availability = .checking
    @Published private(set) var hasActiveCall = false
    @Published private(set) var isTestCallActive = false
    @Published var isEnabled: Bool {
        didSet { UserDefaults.standard.set(isEnabled, forKey: DefaultsKey.isEnabled) }
    }

    private var callObserver: CXCallObserver?

    var isBlocking: Bool {
        isEnabled && availability == .available && (hasActiveCall || isTestCallActive)
    }

    init(storefrontCountryCode: String? = nil) {
        isEnabled = UserDefaults.standard.object(forKey: DefaultsKey.isEnabled) as? Bool ?? AppConfig.isBlockAppDuringCall
        super.init()

        if let storefrontCountryCode {
            configure(for: storefrontCountryCode)
        } else {
            Task { [weak self] in
                let storefront = await Storefront.current
                await self?.configure(for: storefront?.countryCode)
            }
        }
    }

    func refreshCallStatus() {
        guard availability == .available else { return }
        hasActiveCall = callObserver?.calls.contains(where: { !$0.hasEnded }) ?? false
    }

    func toggleTestCall() {
        isTestCallActive.toggle()
    }

    private func configure(for storefrontCountryCode: String?) {
        // A missing storefront is treated as unavailable so CallKit is never initialized
        // before the China storefront restriction can be applied.
        guard let storefrontCountryCode else {
            availability = .unavailable
            return
        }
        guard storefrontCountryCode.uppercased() != "CHN" else {
            availability = .unavailableInChina
            isTestCallActive = false
            return
        }

        availability = .available
        let observer = CXCallObserver()
        observer.setDelegate(self, queue: nil)
        callObserver = observer
        refreshCallStatus()
    }
}

extension BlockAppDuringCallsController: CXCallObserverDelegate {
    nonisolated func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        Task { @MainActor [weak self] in
            self?.refreshCallStatus()
        }
    }
}
