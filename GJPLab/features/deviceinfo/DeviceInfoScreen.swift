import SwiftUI

struct DeviceInfoScreen: View {
    private let info = DeviceInfoRepository().read()
    var body: some View { ScrollView { VStack(alignment: .leading, spacing: 18) { Text("A snapshot of the device this app is running on.").foregroundStyle(.secondary); InfoSection(title: "iOS", rows: info.0); InfoSection(title: "Hardware", rows: info.1) }.padding(20) }.navigationTitle("OS & hardware") }
}

private struct InfoSection: View {
    let title: String; let rows: [InfoRow]
    var body: some View { VStack(alignment: .leading, spacing: 0) { Text(title).font(.headline).padding(.bottom, 8); ForEach(rows) { row in HStack(alignment: .top) { Text(row.label).foregroundStyle(.secondary); Spacer(minLength: 16); Text(row.value).fontWeight(.medium).multilineTextAlignment(.trailing) }.padding(.vertical, 11); Divider() } }.padding(18).background(.regularMaterial, in: RoundedRectangle(cornerRadius: 18)) }
}
