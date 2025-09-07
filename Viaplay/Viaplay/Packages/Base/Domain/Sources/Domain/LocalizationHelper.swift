import Foundation

public extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}

public struct LocalizationKeys {
    public struct Sections {
        public static let errorTitle = "sections.errorTitle"
    }
    public struct Detail {
        public static let errorTitle = "detail.errorTitle"
    }
    public struct Content {
        public static let elementsCount = "content.elementsCount"
        public static let category = "content.category"
        public static let status = "content.status"
        public static let title = "content.title"
    }
}

public struct SectionTitleLocalizer {
    public static func localizedTitle(for apiTitle: String) -> String {
        let key = "section.\(apiTitle.lowercased())"
        let localized = key.localized
        return localized == key ? apiTitle : localized
    }
}
