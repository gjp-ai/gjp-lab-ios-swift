import SwiftUI
import UIKit

enum LabTheme {
    static let primary = Color(light: 0x000000, dark: 0xFFFFFF)
    static let onPrimary = Color(light: 0xFFFFFF, dark: 0x000000)
    static let primaryContainer = Color(light: 0xE8E8E8, dark: 0x343434)
    static let background = Color(light: 0xFFFCF8, dark: 0x0D0D0D)
    static let surface = Color(light: 0xFFFFFF, dark: 0x151515)
    static let surfaceContainer = Color(light: 0xF1F1F1, dark: 0x222222)
    static let onSurface = Color(light: 0x1A1A1A, dark: 0xE8E8E8)
    static let onSurfaceVariant = Color(light: 0x474747, dark: 0xC6C6C6)
    static let outlineVariant = Color(light: 0xC6C6C6, dark: 0x474747)
    static let error = Color(light: 0xBA1A1A, dark: 0xFFB4AB)
    static let errorContainer = Color(light: 0xFFDAD6, dark: 0x93000A)
    static let onErrorContainer = Color(light: 0x410002, dark: 0xFFDAD6)
    static let success = Color(light: 0x2E7D32, dark: 0x81C784)
}

extension View {
    func labScreenBackground() -> some View {
        background(LabTheme.background.ignoresSafeArea())
            .foregroundStyle(LabTheme.onSurface)
    }

    func labCard(cornerRadius: CGFloat = 24) -> some View {
        background(LabTheme.surface, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: .black.opacity(0.08), radius: 7, y: 2)
    }
}

private extension Color {
    init(light: UInt32, dark: UInt32) {
        self.init(
            UIColor { traits in
                UIColor(rgb: traits.userInterfaceStyle == .dark ? dark : light)
            }
        )
    }
}

private extension UIColor {
    convenience init(rgb: UInt32) {
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255,
            green: CGFloat((rgb >> 8) & 0xFF) / 255,
            blue: CGFloat(rgb & 0xFF) / 255,
            alpha: 1
        )
    }
}
