import SwiftUI

public struct LoadingView: View {
    let title: String
    let animationName: String

    public init(title: String = "Loading…", animationName: String = "Loading") {
        self.title = title
        self.animationName = animationName
    }

    public var body: some View {
        VStack(spacing: DSSpacing.medium) {
            // This can be moved to inside LottieView, instead of do the logic here
            if Bundle.module.url(forResource: animationName, withExtension: "json") != nil {
                LottieView(name: animationName, accessibilityLabel: title)
                    .frame(width: 250, height: 120)
                    .accessibilityIdentifier("loadingAnimation")
            } else {
                ProgressView()
                    .scaleEffect(1.2)
                    .accessibilityIdentifier("defaultAnimation")
                Text(title)
                    .font(DSTypography.body)
                    .foregroundColor(DSPalette.textSecondary)
            }
        }
        .padding()
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
    }
}

#Preview("LoadingView") {
    LoadingView()
}
