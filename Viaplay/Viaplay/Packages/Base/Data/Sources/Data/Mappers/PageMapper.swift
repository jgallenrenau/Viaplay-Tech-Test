import Foundation
import Domain

struct PageMapper {
    static func map(_ dto: PageDTO) -> Page {
        let sections = extractSections(from: dto)
        
        return Page(
            title: dto.title,
            description: dto.description,
            sections: sections
        )
    }
    
    private static func extractSections(from dto: PageDTO) -> [ContentSection] {
        // Try viaplay:sections first
        if let sections = dto.links.viaplaySections {
            return mapSections(sections)
        }
        
        // Fallback to primary navigation
        if let sections = dto.links.viaplayPrimaryNavigation {
            return mapSections(sections)
        }
        
        // Fallback to secondary navigation
        if let sections = dto.links.viaplaySecondaryNavigation {
            return mapSections(sections)
        }
        
        return []
    }
    
    private static func mapSections(_ sections: [SectionDTO]) -> [ContentSection] {
        return sections.compactMap { sectionDTO in
            guard let href = URL(string: sectionDTO.href) else { return nil }
            
            return ContentSection(
                title: sectionDTO.title,
                description: nil,
                href: href
            )
        }
    }
}