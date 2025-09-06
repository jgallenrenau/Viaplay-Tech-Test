import Foundation

// MARK: - Simple Page DTO for API Response

struct PageDTO: Codable {
    let title: String
    let description: String?
    let links: LinksDTO
    
    enum CodingKeys: String, CodingKey {
        case title, description
        case links = "_links"
    }
}

struct LinksDTO: Codable {
    let viaplaySections: [SectionDTO]?
    let viaplayPrimaryNavigation: [SectionDTO]?
    let viaplaySecondaryNavigation: [SectionDTO]?
    
    enum CodingKeys: String, CodingKey {
        case viaplaySections = "viaplay:sections"
        case viaplayPrimaryNavigation = "viaplay:primaryNavigation"
        case viaplaySecondaryNavigation = "viaplay:secondaryNavigation"
    }
}

struct SectionDTO: Codable {
    let title: String
    let href: String
}