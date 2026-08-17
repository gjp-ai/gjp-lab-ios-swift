import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack { LinearGradient(colors: [LabTheme.splashStart, LabTheme.splashEnd], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea(); VStack(spacing: 20) {
            ZStack { RoundedRectangle(cornerRadius: 30).fill(.black.opacity(0.18)); Text("S").font(.system(size: 72, weight: .black)).foregroundStyle(.cyan); Text("›").font(.system(size: 30, weight: .bold)).foregroundStyle(.orange).offset(x: 34, y: -30) }.frame(width: 112, height: 112)
            Text("GJP Lab").font(.system(size: 30, weight: .bold, design: .rounded)).tracking(4).foregroundStyle(.white)
            Text("iOS feature lab").foregroundStyle(.white.opacity(0.7))
        } }
    }
}
