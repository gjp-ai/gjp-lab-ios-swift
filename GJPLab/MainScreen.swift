import SwiftUI

struct MainScreen: View {
    let onFeatureSelected: (FeatureRoute) -> Void
    private let features = [("01", "OS & hardware", "Explore device and iOS details", FeatureRoute.deviceInfo), ("02", "HttpURLConnection", "Make requests with the native API", FeatureRoute.http), ("03", "Firebase", "Explore Analytics, Config, Crashlytics, and Performance", FeatureRoute.firebase)]

    var body: some View {
        ScrollView { VStack(alignment: .leading, spacing: 0) {
            Text("Feature lab").font(.largeTitle.bold())
            Text("Small, focused samples for exploring iOS.").foregroundStyle(.secondary).padding(.top, 6).padding(.bottom, 24)
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                ForEach(features, id: \.1) { feature in
                    Button { onFeatureSelected(feature.3) } label: { FeatureCard(badge: feature.0, title: feature.1, description: feature.2) }.buttonStyle(.plain)
                }
            }
        }.padding(.horizontal, 20).padding(.top, 28) }
            .navigationTitle("GJP Lab").navigationBarTitleDisplayMode(.inline)
    }
}

private struct FeatureCard: View {
    let badge: String; let title: String; let description: String
    var body: some View { VStack(alignment: .leading, spacing: 8) { Text(badge).font(.headline).foregroundStyle(.tint); Spacer(minLength: 12); Text(title).font(.headline); Text(description).font(.caption).foregroundStyle(.secondary) }.frame(maxWidth: .infinity, minHeight: 180, alignment: .topLeading).padding(18).background(Color.accentColor.opacity(0.14), in: RoundedRectangle(cornerRadius: 24)) }
}
