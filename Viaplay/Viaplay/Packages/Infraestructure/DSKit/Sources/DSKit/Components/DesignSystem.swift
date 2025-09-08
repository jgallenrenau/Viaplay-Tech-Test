import SwiftUI

/// Simple Design System for Viaplay App
public struct DesignSystem {
    
    // MARK: - Colors
    public static let colors = DSPalette.self
    
    // MARK: - Components
    public struct Components {
        
        public static func errorView(
            title: String = "Oops! Something went wrong",
            message: String? = nil,
            retryAction: (() -> Void)? = nil
        ) -> ErrorView {
            ErrorView(title: title, message: message, retryAction: retryAction)
        }
        
        public static func splashView(
            onAnimationEnd: @escaping () -> Void
        ) -> SplashView {
            SplashView(onAnimationEnd: onAnimationEnd)
        }
        
        public static func sectionRowView(
            title: String,
            description: String? = nil,
            onTap: @escaping () -> Void = {}
        ) -> some View {
            let model = SectionRowView.Model(title: title, description: description)
            return SectionRowView(model: model, onTap: onTap)
        }
    }
}
