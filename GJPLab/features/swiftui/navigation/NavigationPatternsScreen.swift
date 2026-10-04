import SwiftUI

struct NavigationPatternsScreen: View {
    @State private var isShowingSheet = false
    @State private var isShowingCover = false
    @State private var isShowingPopover = false
    @State private var isShowingInspector = false

    var body: some View {
        LabDemoPage(
            title: "Navigation",
            intro: "This app has one navigation structure: a split view whose columns follow selection, with a stack for pushes inside a feature. Everything else is a presentation on top."
        ) {
            LabDemoSection(
                title: "Push with a value",
                caption: "NavigationLink(value:) appends a DetailRoute to the stack's path; ContentView maps the value to a screen."
            ) {
                NavigationLink(value: DetailRoute.navigationLevel(1)) {
                    Label("Push level 1", systemImage: "arrow.right.square")
                }
                .buttonStyle(.labPrimary)
            }

            LabDemoSection(
                title: "Sheets and covers",
                caption: "A sheet slides up over the current screen and can stop at a medium height. A full-screen cover hides it completely."
            ) {
                HStack(spacing: 8) {
                    Button("Sheet") { isShowingSheet = true }
                    Button("Full screen") { isShowingCover = true }
                    Button("Popover") { isShowingPopover = true }
                        .popover(isPresented: $isShowingPopover) {
                            Text("Popovers point at their source on iPad. On iPhone, this one stays a popover because of .presentationCompactAdaptation(.popover).")
                                .padding()
                                .frame(idealWidth: 280)
                                .presentationCompactAdaptation(.popover)
                        }
                }
                .buttonStyle(.bordered)
            }

            LabDemoSection(
                title: "Toolbar and inspector",
                caption: "Toolbar items live in the navigation bar. The info button opens an inspector: a side panel on iPad, a sheet on iPhone."
            ) {
                Toggle("Show inspector", isOn: $isShowingInspector)
            }

            LabDemoSection(
                title: "Selection-driven columns",
                caption: "The sidebar and catalogue bind to ContentView's selectedCategory and selectedTopic. On iPhone the same split view collapses into one stack, so there is no separate iPhone navigation code."
            ) {
                Label("Rotate an iPad or resize its window to see the columns adapt.", systemImage: "rectangle.split.3x1")
                    .font(.subheadline)
                    .foregroundStyle(LabTheme.onSurfaceVariant)
            }
        }
        .inspector(isPresented: $isShowingInspector) {
            PresentationContent(
                title: "Inspector",
                message: "Inspectors show details about the current screen without leaving it.",
                dismissTitle: "Close"
            )
            .inspectorColumnWidth(min: 240, ideal: 300, max: 400)
        }
        // Set the title and toolbar after `.inspector`: on iPhone the inspector wraps the screen in a
        // container, and a title or toolbar set inside that container is not shown in the navigation bar.
        .navigationTitle("Navigation")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Inspector", systemImage: "info.circle") { isShowingInspector.toggle() }
            }
        }
        .sheet(isPresented: $isShowingSheet) {
            PresentationContent(
                title: "Sheet",
                message: "Drag the grabber to switch between medium and large heights, or swipe down to dismiss.",
                dismissTitle: "Done"
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $isShowingCover) {
            PresentationContent(
                title: "Full-screen cover",
                message: "A cover cannot be swiped away, so it always needs a visible way out.",
                dismissTitle: "Close"
            )
        }
    }
}

/// Content for each presentation. It closes itself with `dismiss`, so the presenter only owns the Bool.
private struct PresentationContent: View {
    let title: String
    let message: String
    let dismissTitle: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.title2.bold())
                .accessibilityAddTraits(.isHeader)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(LabTheme.onSurfaceVariant)
            Button(dismissTitle) { dismiss() }
                .buttonStyle(.labPrimary)
        }
        .padding(28)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .labScreenBackground()
    }
}

#Preview("Navigation – light") {
    NavigationStack { NavigationPatternsScreen() }
}

#Preview("Navigation – dark") {
    NavigationStack { NavigationPatternsScreen() }
        .preferredColorScheme(.dark)
}
