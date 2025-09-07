import SwiftUI

public enum DSTypography {
    // MARK: - iOS Typography (Compact & Mobile-Optimized)
    public static let title: Font = .system(.title3, design: .rounded).weight(.bold)
    public static let body: Font = .system(size: 18, weight: .semibold, design: .rounded)
    public static let caption: Font = .system(size: 14, weight: .medium, design: .rounded)
    public static let small: Font = .system(size: 12, weight: .regular, design: .rounded)
    
    // MARK: - tvOS Typography (Large & TV-Optimized)
    public static let tvTitle: Font = .system(size: 48, weight: .bold, design: .rounded)
    public static let tvSubtitle: Font = .system(size: 36, weight: .semibold, design: .rounded)
    public static let tvBody: Font = .system(size: 28, weight: .medium, design: .rounded)
    public static let tvCaption: Font = .system(size: 24, weight: .regular, design: .rounded)
    public static let tvLarge: Font = .system(size: 64, weight: .bold, design: .rounded)
    
    // MARK: - Platform-Specific Helpers
    public static func title(for platform: Platform) -> Font {
        #if os(tvOS)
        return tvTitle
        #else
        return title
        #endif
    }
    
    public static func body(for platform: Platform) -> Font {
        #if os(tvOS)
        return tvBody
        #else
        return body
        #endif
    }
    
    public static func caption(for platform: Platform) -> Font {
        #if os(tvOS)
        return tvCaption
        #else
        return caption
        #endif
    }
}

public enum Platform {
    case iOS
    case tvOS
}
