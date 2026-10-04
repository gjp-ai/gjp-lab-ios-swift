import SwiftUI

struct AnimationScreen: View {
    @State private var isExpanded = false
    @State private var curve = CurveKind.spring
    @State private var isAtEnd = false
    @State private var transition = TransitionKind.scale
    @State private var isCardVisible = true
    @State private var selectedTab = Tab.first
    @State private var bounceCount = 0
    @Namespace private var tabUnderline
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        LabDemoPage(
            title: "Animation",
            intro: "SwiftUI animates the difference between two states. Change state inside withAnimation, or attach .animation(_:value:) to a view."
        ) {
            if reduceMotion {
                Label("Reduce Motion is on, so these samples change without moving.", systemImage: "figure.walk.motion")
                    .font(.subheadline)
                    .padding(14)
                    .labCard(cornerRadius: 14)
            }

            LabDemoSection(
                title: "Implicit animation",
                caption: ".animation(.bouncy, value: isExpanded) animates every change caused by that value."
            ) {
                HStack {
                    Spacer()
                    Circle()
                        .fill(isExpanded ? LabTheme.primary : LabTheme.outlineVariant)
                        .frame(width: isExpanded ? 120 : 60, height: isExpanded ? 120 : 60)
                        .animation(motion(.bouncy), value: isExpanded)
                        .accessibilityHidden(true)
                    Spacer()
                }
                .frame(height: 130)
                Button(isExpanded ? "Shrink" : "Grow") { isExpanded.toggle() }
                    .buttonStyle(.labPrimary)
            }

            LabDemoSection(
                title: "Timing curves",
                caption: "withAnimation(curve) animates the state change inside its closure. Compare how each curve starts and stops."
            ) {
                Picker("Curve", selection: $curve) {
                    ForEach(CurveKind.allCases) { Text($0.title).tag($0) }
                }
                .pickerStyle(.segmented)

                Circle()
                    .fill(LabTheme.primary)
                    .frame(width: 32, height: 32)
                    .frame(maxWidth: .infinity, alignment: isAtEnd ? .trailing : .leading)
                    .padding(6)
                    .background(LabTheme.surfaceContainer, in: Capsule())
                    .accessibilityHidden(true)

                Button("Move") {
                    withAnimation(motion(curve.animation)) { isAtEnd.toggle() }
                }
                .buttonStyle(.bordered)
            }

            LabDemoSection(
                title: "Transitions",
                caption: "A transition animates a view as it is inserted or removed by an if statement."
            ) {
                Picker("Transition", selection: $transition) {
                    ForEach(TransitionKind.allCases) { Text($0.title).tag($0) }
                }
                .pickerStyle(.menu)

                ZStack {
                    if isCardVisible {
                        Label("Hello", systemImage: "hand.wave")
                            .font(.headline)
                            .foregroundStyle(LabTheme.onPrimary)
                            .frame(maxWidth: .infinity, minHeight: 80)
                            .background(LabTheme.primary, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                            .transition(transition.transition)
                    }
                }
                .frame(height: 80)
                .frame(maxWidth: .infinity)
                .clipped()

                Button(isCardVisible ? "Remove" : "Insert") {
                    withAnimation(motion(.smooth)) { isCardVisible.toggle() }
                }
                .buttonStyle(.bordered)
            }

            LabDemoSection(
                title: "Matched geometry",
                caption: "matchedGeometryEffect lets one view appear to move between two places, like this tab underline."
            ) {
                HStack(spacing: 0) {
                    ForEach(Tab.allCases) { tab in
                        Button {
                            withAnimation(motion(.snappy)) { selectedTab = tab }
                        } label: {
                            VStack(spacing: 6) {
                                Text(tab.title)
                                    .fontWeight(selectedTab == tab ? .semibold : .regular)
                                    .foregroundStyle(selectedTab == tab ? LabTheme.onSurface : LabTheme.onSurfaceVariant)
                                ZStack {
                                    Capsule().fill(Color.clear).frame(height: 3)
                                    if selectedTab == tab {
                                        Capsule()
                                            .fill(LabTheme.primary)
                                            .frame(height: 3)
                                            .matchedGeometryEffect(id: "underline", in: tabUnderline)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityAddTraits(selectedTab == tab ? .isSelected : [])
                    }
                }
            }

            LabDemoSection(
                title: "Phase animation and symbol effects",
                caption: "PhaseAnimator loops through phases on its own. Symbol effects animate SF Symbols with one modifier."
            ) {
                HStack(spacing: 32) {
                    Group {
                        if reduceMotion {
                            Image(systemName: "heart.fill")
                        } else {
                            PhaseAnimator([false, true]) { isBeating in
                                Image(systemName: "heart.fill")
                                    .scaleEffect(isBeating ? 1.25 : 1)
                            } animation: { _ in .easeInOut(duration: 0.6) }
                        }
                    }
                    .font(.largeTitle)
                    .accessibilityHidden(true)

                    Button {
                        bounceCount += 1
                    } label: {
                        Image(systemName: "bell.fill")
                            .font(.largeTitle)
                            .symbolEffect(.bounce, value: bounceCount)
                            .frame(minWidth: 44, minHeight: 44)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Ring bell")
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    /// No movement when the user turns on Reduce Motion in Settings → Accessibility → Motion.
    private func motion(_ animation: Animation) -> Animation? {
        reduceMotion ? nil : animation
    }
}

private enum CurveKind: CaseIterable, Identifiable {
    case linear, easeInOut, spring, bouncy

    var id: Self { self }

    var title: String {
        switch self {
        case .linear: "Linear"
        case .easeInOut: "Ease"
        case .spring: "Spring"
        case .bouncy: "Bouncy"
        }
    }

    var animation: Animation {
        switch self {
        case .linear: .linear(duration: 0.8)
        case .easeInOut: .easeInOut(duration: 0.8)
        case .spring: .spring(duration: 0.8)
        case .bouncy: .bouncy(duration: 0.8, extraBounce: 0.2)
        }
    }
}

private enum TransitionKind: CaseIterable, Identifiable {
    case opacity, scale, slide, move, asymmetric

    var id: Self { self }

    var title: String {
        switch self {
        case .opacity: "Opacity"
        case .scale: "Scale"
        case .slide: "Slide"
        case .move: "Move from bottom"
        case .asymmetric: "Asymmetric"
        }
    }

    var transition: AnyTransition {
        switch self {
        case .opacity: .opacity
        case .scale: .scale.combined(with: .opacity)
        case .slide: .slide
        case .move: .move(edge: .bottom).combined(with: .opacity)
        case .asymmetric: .asymmetric(insertion: .push(from: .leading), removal: .push(from: .trailing))
        }
    }
}

private enum Tab: CaseIterable, Identifiable {
    case first, second, third

    var id: Self { self }

    var title: String {
        switch self {
        case .first: "Recent"
        case .second: "Popular"
        case .third: "Saved"
        }
    }
}

#Preview("Animation – light") {
    NavigationStack { AnimationScreen() }
}

#Preview("Animation – dark") {
    NavigationStack { AnimationScreen() }
        .preferredColorScheme(.dark)
}
