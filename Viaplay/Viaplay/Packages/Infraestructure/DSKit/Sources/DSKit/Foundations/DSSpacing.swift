import CoreGraphics

public enum DSSpacing {
    // MARK: - iOS Spacing (Compact & Mobile-Optimized)
    public static let extraSmall: CGFloat = 4
    public static let small: CGFloat = 8
    public static let medium: CGFloat = 12
    public static let large: CGFloat = 16
    public static let extraLarge: CGFloat = 24
    public static let huge: CGFloat = 32
    
    // MARK: - tvOS Spacing (Large & TV-Optimized)
    public static let tvExtraSmall: CGFloat = 12
    public static let tvSmall: CGFloat = 20
    public static let tvMedium: CGFloat = 32
    public static let tvLarge: CGFloat = 48
    public static let tvExtraLarge: CGFloat = 64
    public static let tvHuge: CGFloat = 96
    public static let tvMassive: CGFloat = 128
    
    // MARK: - Platform-Specific Helpers
    public static func extraSmall(for platform: Platform) -> CGFloat {
        #if os(tvOS)
        return tvExtraSmall
        #else
        return extraSmall
        #endif
    }
    
    public static func small(for platform: Platform) -> CGFloat {
        #if os(tvOS)
        return tvSmall
        #else
        return small
        #endif
    }
    
    public static func medium(for platform: Platform) -> CGFloat {
        #if os(tvOS)
        return tvMedium
        #else
        return medium
        #endif
    }
    
    public static func large(for platform: Platform) -> CGFloat {
        #if os(tvOS)
        return tvLarge
        #else
        return large
        #endif
    }
    
    public static func extraLarge(for platform: Platform) -> CGFloat {
        #if os(tvOS)
        return tvExtraLarge
        #else
        return extraLarge
        #endif
    }
}
