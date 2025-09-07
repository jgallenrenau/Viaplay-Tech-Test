import SwiftUI

public enum DSPalette {
    // MARK: - Base Colors (Shared)
    public static let brand = Color("Brand", bundle: .module)
    public static let textPrimary = Color("TextPrimary", bundle: .module)
    public static let textSecondary = Color("TextSecondary", bundle: .module)
    public static let background = Color("Background", bundle: .module)
    public static let surface = Color("Surface", bundle: .module)
    public static let error = Color("Error", bundle: .module)
    public static let shadow = Color("Shadow", bundle: .module)
    
    // MARK: - iOS Colors (Subtle & Mobile-Optimized)
    public static let iOSAccent = brand.opacity(0.1)
    public static let iOSCardBackground = surface.opacity(0.8)
    public static let iOSBorder = shadow.opacity(0.2)
    
    // MARK: - tvOS Colors (Bold & TV-Optimized)
    public static let tvAccent = brand.opacity(0.2)
    public static let tvCardBackground = surface.opacity(0.9)
    public static let tvBorder = shadow.opacity(0.4)
    public static let tvFocus = brand.opacity(0.3)
    public static let tvHighlight = brand.opacity(0.15)
    public static let tvGlow = brand.opacity(0.6)
    
    // MARK: - Platform-Specific Helpers
    public static func accent(for platform: Platform) -> Color {
        #if os(tvOS)
        return tvAccent
        #else
        return iOSAccent
        #endif
    }
    
    public static func cardBackground(for platform: Platform) -> Color {
        #if os(tvOS)
        return tvCardBackground
        #else
        return iOSCardBackground
        #endif
    }
    
    public static func border(for platform: Platform) -> Color {
        #if os(tvOS)
        return tvBorder
        #else
        return iOSBorder
        #endif
    }
}
