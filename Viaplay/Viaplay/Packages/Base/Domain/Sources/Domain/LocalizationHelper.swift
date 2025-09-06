import Foundation

/// Helper class for managing localization throughout the app
public class LocalizationHelper {
    
    /// Shared instance for easy access
    public static let shared = LocalizationHelper()
    
    private init() {}
    
    /// Get localized string for a key
    /// - Parameter key: The localization key
    /// - Returns: Localized string or the key itself if not found
    public func localizedString(for key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    
    /// Get localized string with arguments
    /// - Parameters:
    ///   - key: The localization key
    ///   - arguments: Arguments to format into the string
    /// - Returns: Formatted localized string
    public func localizedString(for key: String, arguments: CVarArg...) -> String {
        let format = NSLocalizedString(key, comment: "")
        return String(format: format, arguments: arguments)
    }
    
    /// Get current language code
    /// - Returns: Current language code (e.g., "en", "es", "de")
    public var currentLanguage: String {
        return Locale.current.languageCode ?? "en"
    }
    
    /// Check if current language is RTL (Right-to-Left)
    /// - Returns: True if current language is RTL
    public var isRTL: Bool {
        return Locale.current.languageCode?.contains("ar") == true || 
               Locale.current.languageCode?.contains("he") == true
    }
}

// MARK: - String Extension for Easy Localization
extension String {
    /// Get localized version of this string
    /// - Returns: Localized string
    public var localized: String {
        return LocalizationHelper.shared.localizedString(for: self)
    }
    
    /// Get localized version with arguments
    /// - Parameter arguments: Arguments to format into the string
    /// - Returns: Formatted localized string
    public func localized(arguments: CVarArg...) -> String {
        return LocalizationHelper.shared.localizedString(for: self, arguments: arguments)
    }
}

// MARK: - Common Localization Keys
public struct LocalizationKeys {
    
    // MARK: - Common
    public static let loading = "loading"
    public static let error = "error"
    public static let retry = "retry"
    public static let refresh = "refresh"
    public static let cancel = "cancel"
    public static let ok = "ok"
    public static let done = "done"
    public static let back = "back"
    public static let next = "next"
    public static let previous = "previous"
    public static let close = "close"
    
    // MARK: - Sections
    public struct Sections {
        public static let title = "sections.title"
        public static let loading = "sections.loading"
        public static let errorTitle = "sections.error.title"
        public static let errorMessage = "sections.error.message"
        public static let emptyTitle = "sections.empty.title"
        public static let emptyMessage = "sections.empty.message"
    }
    
    // MARK: - Detail Section
    public struct Detail {
        public static let title = "detail.title"
        public static let loading = "detail.loading"
        public static let errorTitle = "detail.error.title"
        public static let errorMessage = "detail.error.message"
        public static let emptyTitle = "detail.empty.title"
        public static let emptyMessage = "detail.empty.message"
    }
    
    // MARK: - Content
    public struct Content {
        public static let title = "content.title"
        public static let elementsCount = "content.elements.count"
        public static let category = "content.category"
        public static let status = "content.status"
        public static let section = "content.section"
        public static let linkAvailable = "content.link.available"
        public static let linkUnavailable = "content.link.unavailable"
    }
    
    // MARK: - Actions
    public struct Actions {
        public static let explore = "action.explore"
        public static let share = "action.share"
        public static let bookmark = "action.bookmark"
        public static let favorite = "action.favorite"
    }
    
    // MARK: - Status
    public struct Status {
        public static let active = "status.active"
        public static let inactive = "status.inactive"
        public static let pending = "status.pending"
        public static let completed = "status.completed"
    }
    
    // MARK: - Categories
    public struct Categories {
        public static let sports = "category.sports"
        public static let movies = "category.movies"
        public static let series = "category.series"
        public static let news = "category.news"
        public static let kids = "category.kids"
        public static let documentary = "category.documentary"
        public static let entertainment = "category.entertainment"
    }
}
