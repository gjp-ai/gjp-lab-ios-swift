import SwiftUI

struct DeviceInfoScreen: View {
    private let info = DeviceInfoRepository().read()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("A snapshot of the device this app is running on.")
                    .foregroundStyle(LabTheme.onSurfaceVariant)
                InfoSection(title: "iOS", rows: info.0)
                InfoSection(title: "Hardware", rows: info.1)
            }
            .frame(maxWidth: 720)
            .padding(20)
            .frame(maxWidth: .infinity)
        }
        .navigationTitle("OS & hardware")
        .labScreenBackground()
    }
}

private struct InfoSection: View {
    let title: String
    let rows: [InfoRow]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 8)
            ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                HStack(alignment: .top) {
                    Text(row.label).foregroundStyle(LabTheme.onSurfaceVariant)
                    Spacer(minLength: 16)
                    Text(row.value)
                        .fontWeight(.medium)
                        .multilineTextAlignment(.trailing)
                }
                .padding(.vertical, 11)
                if index < rows.count - 1 {
                    Divider().overlay(LabTheme.outlineVariant.opacity(0.5))
                }
            }
        }
        .padding(18)
        .labCard(cornerRadius: 18)
    }
}
