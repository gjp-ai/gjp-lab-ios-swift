import SwiftUI

struct MaintenanceScreen: View {
    let onRetry: () -> Void
    var body: some View { VStack(spacing: 14) { Text("We'll be back soon").font(.title.bold()); Text("GJP Lab is temporarily unavailable while we perform maintenance. Please try again shortly.").multilineTextAlignment(.center).foregroundStyle(.secondary); Button("Try again", action: onRetry).buttonStyle(.borderedProminent) }.padding(28) }
}
