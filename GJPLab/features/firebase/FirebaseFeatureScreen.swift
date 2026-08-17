import SwiftUI

struct FirebaseFeatureScreen: View {
    @StateObject private var integration = FirebaseIntegration()
    var body: some View { ScrollView { VStack(alignment: .leading, spacing: 14) {
        Text("Run small, safe demonstrations of the Firebase services used by GJPLab.").foregroundStyle(.secondary)
        Text("Project: \(integration.configurationProjectID)").font(.caption).foregroundStyle(.secondary)
        FirebaseActionCard(title: "Analytics", description: "Send a feature_firebase_opened event.", status: integration.analyticsStatus, action: "Log event") { integration.logFeatureOpened() }
        FirebaseActionCard(title: "Crashlytics", description: "Record a non-fatal demo exception without crashing the app.", status: integration.crashlyticsStatus, action: "Record exception") { integration.recordCrashlyticsDemo() }
        FirebaseActionCard(title: "Remote Config", description: "Fetch the maintenance-mode flag from Firebase.", status: integration.remoteConfigStatus, action: "Fetch flag") { Task { await integration.fetchMaintenanceMode() } }
        FirebaseActionCard(title: "Performance Monitoring", description: "Run and complete a short custom performance trace.", status: integration.performanceStatus, action: "Run trace") { Task { await integration.runPerformanceDemo() } }
        FirebaseActionCard(title: "Cloud Messaging", description: "Retrieve the registration token or subscribe to the demo topic.", status: integration.messagingStatus, action: "Get token") { Task { await integration.fetchMessagingToken() } }
        if let token = integration.messagingToken { HStack { Text(token).font(.caption).textSelection(.enabled); Spacer(); Button(integration.tokenCopied ? "Copied" : "Copy") { integration.copyToken() } } }
        Button("Subscribe to demo topic") { integration.subscribeToDemoTopic() }.buttonStyle(.borderedProminent).frame(maxWidth: .infinity)
    }.padding(20) }.navigationTitle("Firebase") }
}

private struct FirebaseActionCard: View {
    let title: String; let description: String; let status: String; let action: String; let onAction: () -> Void
    var body: some View { VStack(alignment: .leading, spacing: 8) { Text(title).font(.title3.bold()); Text(description).foregroundStyle(.secondary); Text(status).font(.caption).foregroundStyle(.tint); Button(action, action: onAction).buttonStyle(.borderedProminent).frame(maxWidth: .infinity) }.padding(18).background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18)) }
}
