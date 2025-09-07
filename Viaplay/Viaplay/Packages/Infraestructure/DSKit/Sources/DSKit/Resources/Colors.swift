import SwiftUI

/// Simple color palette for Viaplay app
public struct AppColors {
    
    // MARK: - Colors used in the app
    public static let primary = Color.blue
    public static let secondary = Color.purple
    public static let accent = Color.orange
    public static let success = Color.green
    public static let error = Color.red
    public static let gray = Color.gray
    
    // MARK: - Gradients used in the app
    public static let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [primary, secondary]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    public static let accentGradient = LinearGradient(
        gradient: Gradient(colors: [accent, error]),
        startPoint: .leading,
        endPoint: .trailing
    )
    
    // MARK: - Background colors
    #if os(tvOS)
    public static let background = Color.black
    public static let backgroundSecondary = Color.black.opacity(0.1)
    #else
    public static let background = Color(.systemBackground)
    public static let backgroundSecondary = Color(.secondarySystemBackground)
    #endif
    
    // MARK: - Text colors
    public static let textPrimary = Color.primary
    public static let textSecondary = Color.secondary
}
