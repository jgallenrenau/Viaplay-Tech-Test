import Foundation

public struct Page: Equatable, Codable, Sendable {
    public let title: String
    public let description: String?
    public let sections: [ContentSection]
    public init(title: String, description: String? = nil, sections: [ContentSection]) {
        self.title = title
        self.description = description
        self.sections = sections
    }
}

public struct ContentSection: Equatable, Codable, Sendable {
    public let title: String
    public let description: String?
    public let href: URL?
    public init(title: String, description: String? = nil, href: URL? = nil) {
        self.title = title
        self.description = description
        self.href = href
    }
}

// MARK: - Sections Feature Models

public struct Section: Equatable, Codable, Sendable {
    public let id: String
    public let title: String
    public let description: String?
    public let href: URL?
    public let imageURL: URL?

    public init(
        id: String,
        title: String,
        href: URL? = nil,
        imageURL: URL? = nil,
        description: String? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.href = href
        self.imageURL = imageURL
    }
}

public struct SectionsPage: Equatable, Codable, Sendable {
    public let title: String
    public let description: String?
    public let sections: [Section]

    public init(
        title: String,
        description: String? = nil,
        sections: [Section]
    ) {
        self.title = title
        self.description = description
        self.sections = sections
    }
}
public enum DomainError: Error, Sendable {
    case network
    case decoding
    case storage
    case notModified
}
