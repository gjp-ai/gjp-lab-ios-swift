import SwiftUI

struct BlockAppDuringCallsScreen: View {
    @ObservedObject var controller: BlockAppDuringCallsController

    var body: some View {
        Form {
            Section {
                Toggle("Block App During Calls", isOn: $controller.isEnabled)
                    .disabled(controller.availability != .available)
            } footer: {
                Group {
                    if controller.availability == .unavailableInChina {
                        Text("Call monitoring is unavailable for the China App Store storefront, so this feature is disabled and CallKit is not initialized.")
                    } else {
                        Text("When enabled, the app blocks access while iOS reports a supported active call.")
                    }
                }
                .foregroundStyle(LabTheme.onSurfaceVariant)
            }

            Section {
                StatusRow(label: "Status", value: statusText)
                StatusRow(label: "Call state", value: callStateText)
            } header: {
                SectionHeader("Current feature status")
            }

            Section {
                Button(controller.isTestCallActive ? "End simulated call" : "Simulate active call") {
                    controller.toggleTestCall()
                }
                .disabled(controller.availability != .available || !controller.isEnabled)

                Text("Use this to verify the full-screen block without placing a real call.")
                    .font(.footnote)
                    .foregroundStyle(LabTheme.onSurfaceVariant)
            } header: {
                SectionHeader("Test")
            }

            Section {
                Text("iOS only reports calls that it exposes through CallKit. Regular phone calls and compatible CallKit calls, including FaceTime and supported VoIP/video apps, can be detected. Apps that do not provide system call-state information cannot be detected.")
            } header: {
                SectionHeader("Call detection limitation")
            }
        }
        // Hide the Form's grey grouped background so the Slate canvas shows behind the rows.
        .scrollContentBackground(.hidden)
        .labScreenBackground()
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

// `.labScreenBackground()` makes text `onSurface` by default, so headers and values that the Form
// would draw in a secondary colour set `onSurfaceVariant` explicitly to keep the visual hierarchy.
private struct SectionHeader: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title).foregroundStyle(LabTheme.onSurfaceVariant)
    }
}

private struct StatusRow: View {
    let label: String
    let value: String

    var body: some View {
        LabeledContent(label) {
            Text(value).foregroundStyle(LabTheme.onSurfaceVariant)
        }
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
        .labScreenBackground()
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isModal)
    }
}

#Preview("Available – light") {
    NavigationStack {
        BlockAppDuringCallsScreen(controller: BlockAppDuringCallsController(storefrontCountryCode: "SGP"))
    }
}

#Preview("Available – dark") {
    NavigationStack {
        BlockAppDuringCallsScreen(controller: BlockAppDuringCallsController(storefrontCountryCode: "SGP"))
    }
    .preferredColorScheme(.dark)
}

#Preview("Unavailable in China – light") {
    NavigationStack {
        BlockAppDuringCallsScreen(controller: BlockAppDuringCallsController(storefrontCountryCode: "CHN"))
    }
}

#Preview("Unavailable in China – dark") {
    NavigationStack {
        BlockAppDuringCallsScreen(controller: BlockAppDuringCallsController(storefrontCountryCode: "CHN"))
    }
    .preferredColorScheme(.dark)
}

#Preview("Call overlay – light") {
    CallBlockingOverlay()
}

#Preview("Call overlay – dark") {
    CallBlockingOverlay()
        .preferredColorScheme(.dark)
}
