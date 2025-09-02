import Foundation

public struct Page: Equatable, Codable, Sendable {
    public let title: String
    public let description: String?
    public let sections: [Section]
    public init(title: String, description: String? = nil, sections: [Section]) {
        self.title = title
        self.description = description
        self.sections = sections
    }
}

public struct Section: Equatable, Codable, Sendable {
    public let title: String
    public let description: String?
    public let href: URL?
    public init(title: String, description: String? = nil, href: URL? = nil) {
        self.title = title
        self.description = description
        self.href = href
    }
}

public enum DomainError: Error, Sendable {
    case network
    case decoding
    case storage
    case notModified
}


