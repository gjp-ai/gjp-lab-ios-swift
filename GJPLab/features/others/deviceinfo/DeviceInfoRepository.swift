import Foundation
import UIKit

struct DeviceInfoRepository {
    func read() -> ([InfoRow], [InfoRow]) {
        let device = UIDevice.current
        let screen = currentScreen()?.nativeBounds.size
        return ([InfoRow(label: "iOS version", value: device.systemVersion), InfoRow(label: "Device", value: device.model), InfoRow(label: "Screen", value: screen.map { "\(Int($0.width)) × \(Int($0.height))" } ?? "Unknown"),InfoRow(label: "Interface", value: device.userInterfaceIdiom == .pad ? "iPad" : "iPhone")], [InfoRow(label: "Model", value: machineIdentifier()), InfoRow(label: "CPU cores", value: ProcessInfo.processInfo.activeProcessorCount.formatted()), InfoRow(label: "Memory", value: ByteCountFormatter.string(fromByteCount: Int64(ProcessInfo.processInfo.physicalMemory), countStyle: .memory)), InfoRow(label: "Architecture", value: "Native")])
    }
    // UIScreen.main is deprecated (iOS 26); read the screen from the active window scene.
    private func currentScreen() -> UIScreen? {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        return (scenes.first { $0.activationState == .foregroundActive } ?? scenes.first)?.screen
    }
    private func machineIdentifier() -> String { var info = utsname(); uname(&info); return withUnsafeBytes(of: &info.machine) { String(bytes: $0.prefix { $0 != 0 }, encoding: .ascii) ?? "Unknown" } }
}
