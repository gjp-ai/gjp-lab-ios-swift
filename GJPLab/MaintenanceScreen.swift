import SwiftUI

struct MaintenanceScreen: View {
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "wrench.and.screwdriver")
                .font(.system(size: 34, weight: .semibold))
                .foregroundStyle(LabTheme.primary)
                .padding(.bottom, 4)
            Text("We'll be back soon")
                .font(.title.bold())
            Text("GJP Lab is temporarily unavailable while we perform maintenance. Please try again shortly.")
                .multilineTextAlignment(.center)
                .foregroundStyle(LabTheme.onSurfaceVariant)
            Button("Try again", action: onRetry)
                .buttonStyle(.borderedProminent)
                .padding(.top, 10)
        }
        .frame(maxWidth: 520)
        .padding(28)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .labScreenBackground()
        .tint(LabTheme.primary)
    }
}

#Preview { MaintenanceScreen(onRetry: {}) }
