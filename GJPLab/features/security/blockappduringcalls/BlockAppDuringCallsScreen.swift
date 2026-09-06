import SwiftUI

struct BlockAppDuringCallsScreen: View {
    @ObservedObject var controller: BlockAppDuringCallsController

    var body: some View {
        Form {
            Section {
                Toggle("Block App During Calls", isOn: $controller.isEnabled)
                    .disabled(controller.availability != .available)
            } footer: {
                if controller.availability == .unavailableInChina {
                    Text("Call monitoring is unavailable for the China App Store storefront, so this feature is disabled and CallKit is not initialized.")
                } else {
                    Text("When enabled, the app blocks access while iOS reports a supported active call.")
                }
            }

            Section("Current feature status") {
                LabeledContent("Status", value: statusText)
                LabeledContent("Call state", value: callStateText)
            }

            Section("Test") {
                Button(controller.isTestCallActive ? "End simulated call" : "Simulate active call") {
                    controller.toggleTestCall()
                }
                .disabled(controller.availability != .available || !controller.isEnabled)

                Text("Use this to verify the full-screen block without placing a real call.")
                    .font(.footnote)
                    .foregroundStyle(LabTheme.onSurfaceVariant)
            }

            Section("Call detection limitation") {
                Text("iOS only reports calls that it exposes through CallKit. Regular phone calls and compatible CallKit calls, including FaceTime and supported VoIP/video apps, can be detected. Apps that do not provide system call-state information cannot be detected.")
            }
        }
        .navigationTitle("Block App During Calls")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var statusText: String {
        switch controller.availability {
        case .checking: "Checking availability"
        case .available: controller.isEnabled ? "On" : "Off"
        case .unavailableInChina: "Unavailable in China"
        case .unavailable: "Unavailable"
        }
    }

    private var callStateText: String {
        if controller.isTestCallActive { return "Simulated active call" }
        return controller.hasActiveCall ? "Active call detected" : "No active call detected"
    }
}

struct CallBlockingOverlay: View {
    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "phone.down.fill")
                .font(.system(size: 48, weight: .semibold))
                .accessibilityHidden(true)
            Text("App unavailable during a call")
                .font(.title2.bold())
            Text("End your call to continue using GJP Lab.")
                .multilineTextAlignment(.center)
                .foregroundStyle(LabTheme.onSurfaceVariant)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LabTheme.background.ignoresSafeArea())
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isModal)
    }
}

#Preview("Available") {
    NavigationStack {
        BlockAppDuringCallsScreen(controller: BlockAppDuringCallsController(storefrontCountryCode: "SGP"))
    }
}

#Preview("Unavailable") {
    NavigationStack {
        BlockAppDuringCallsScreen(controller: BlockAppDuringCallsController(storefrontCountryCode: "CHN"))
    }
}
