import SwiftUI

/// Reusable loading view component
public struct LoadingView: View {
    let title: String
    let subtitle: String?
    let showSpinner: Bool
    
    @State private var isAnimating = false
    
    public init(
        title: String = "Loading...",
        subtitle: String? = nil,
        showSpinner: Bool = true
    ) {
        self.title = title
        self.subtitle = subtitle
        self.showSpinner = showSpinner
    }
    
    public var body: some View {
        VStack(spacing: 24) {
            if showSpinner {
                spinnerView
            }
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding()
        .onAppear {
            withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        }
    }
    
    private var spinnerView: some View {
        ZStack {
            Circle()
                .stroke(AppColors.primary.opacity(0.3), lineWidth: 4)
                .frame(width: 60, height: 60)
            
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(
                    AppColors.primaryGradient,
                    style: StrokeStyle(lineWidth: 4, lineCap: .round)
                )
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
        }
    }
}

// MARK: - Convenience initializers
public extension LoadingView {
    static func contentLoading() -> LoadingView {
        LoadingView(
            title: "Loading content",
            subtitle: "Preparing the best series and movies..."
        )
    }
    
    static func detailsLoading() -> LoadingView {
        LoadingView(
            title: "Loading details",
            subtitle: "Getting the latest information..."
        )
    }
    
    static func simple(_ title: String) -> LoadingView {
        LoadingView(title: title, subtitle: nil)
    }
}
