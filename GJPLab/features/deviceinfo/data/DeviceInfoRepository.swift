import Foundation
import UIKit

struct DeviceInfoRepository {
    func read() -> ([InfoRow], [InfoRow]) {
        let device = UIDevice.current
        let screen = UIScreen.main.nativeBounds.size
        return ([InfoRow(label: "iOS version", value: device.systemVersion), InfoRow(label: "Device", value: device.model), InfoRow(label: "Screen", value: "\(Int(screen.width)) × \(Int(screen.height))"), InfoRow(label: "Interface", value: device.userInterfaceIdiom == .pad ? "iPad" : "iPhone")], [InfoRow(label: "Model", value: machineIdentifier()), InfoRow(label: "CPU cores", value: ProcessInfo.processInfo.activeProcessorCount.formatted()), InfoRow(label: "Memory", value: ByteCountFormatter.string(fromByteCount: Int64(ProcessInfo.processInfo.physicalMemory), countStyle: .memory)), InfoRow(label: "Architecture", value: "Native")])
    }
    private func machineIdentifier() -> String { var info = utsname(); uname(&info); return withUnsafeBytes(of: &info.machine) { String(bytes: $0.prefix { $0 != 0 }, encoding: .ascii) ?? "Unknown" } }
}
