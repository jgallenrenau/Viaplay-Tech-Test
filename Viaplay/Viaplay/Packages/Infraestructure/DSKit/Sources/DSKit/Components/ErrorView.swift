import SwiftUI

/// Reusable error view component
public struct ErrorView: View {
    let title: String
    let message: String?
    let retryAction: (() -> Void)?
    
    public init(
        title: String = "Oops! Something went wrong",
        message: String? = nil,
        retryAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.retryAction = retryAction
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            // Error icon
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(AppColors.error)
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                if let message = message {
                    Text(message)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            
            if let retryAction = retryAction {
                Button(action: retryAction) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                        Text("Try Again")
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppColors.primaryGradient)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
    }
}

// MARK: - Convenience initializers
public extension ErrorView {
    static func networkError(retryAction: @escaping () -> Void) -> ErrorView {
        ErrorView(
            title: "Connection Error",
            message: "Please check your internet connection and try again.",
            retryAction: retryAction
        )
    }
    
    static func genericError(retryAction: @escaping () -> Void) -> ErrorView {
        ErrorView(
            title: "Something went wrong",
            message: "We're having trouble loading this content. Please try again.",
            retryAction: retryAction
        )
    }
}
