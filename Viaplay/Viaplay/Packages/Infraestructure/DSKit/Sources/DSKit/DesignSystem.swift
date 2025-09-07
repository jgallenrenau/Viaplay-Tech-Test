import SwiftUI

/// Simple Design System for Viaplay App
public struct DesignSystem {
    
    // MARK: - Colors
    public static let colors = AppColors.self
    
    // MARK: - Components
    public struct Components {
        public static func loadingView(
            title: String = "Loading...",
            subtitle: String? = nil,
            showSpinner: Bool = true
        ) -> LoadingView {
            LoadingView(title: title, subtitle: subtitle, showSpinner: showSpinner)
        }
        
        public static func errorView(
            title: String = "Oops! Something went wrong",
            message: String? = nil,
            retryAction: (() -> Void)? = nil
        ) -> ErrorView {
            ErrorView(title: title, message: message, retryAction: retryAction)
        }
    }
}
