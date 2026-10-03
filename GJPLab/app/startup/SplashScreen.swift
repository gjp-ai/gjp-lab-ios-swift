import SwiftUI

struct SplashScreen: View {
    var body: some View {
        VStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(LabTheme.primary)
                .overlay {
                    LabMark(color: LabTheme.onPrimary)
                        .frame(width: 88, height: 88)
                }
                .frame(width: 112, height: 112)

            Text("GJP Lab")
                .font(.system(size: 30, weight: .bold))
                .tracking(4)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .labScreenBackground()
    }
}

#Preview("Splash screen – light") {
    SplashScreen()
}

#Preview("Splash screen – dark") {
    SplashScreen()
        .preferredColorScheme(.dark)
}
