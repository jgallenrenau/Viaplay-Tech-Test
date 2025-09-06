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
        var sections: [ContentSection] = []
        
        // Extract sections from viaplay:sections
        if let viaplaySections = dto.links.viaplaySections {
            let mappedSections: [ContentSection] = viaplaySections.compactMap { sectionDTO in
                guard let href = URL(string: sectionDTO.href) else { return nil }
                
                return ContentSection(
                    title: sectionDTO.title,
                    description: nil, // API doesn't provide description for sections
                    href: href
                )
            }
            sections.append(contentsOf: mappedSections)
        }
        
        // If no sections found in viaplay:sections, try primary navigation
        if sections.isEmpty, let primaryNav = dto.links.viaplayPrimaryNavigation {
            let mappedSections: [ContentSection] = primaryNav.compactMap { sectionDTO in
                guard let href = URL(string: sectionDTO.href) else { return nil }
                
                return ContentSection(
                    title: sectionDTO.title,
                    description: nil,
                    href: href
                )
            }
            sections.append(contentsOf: mappedSections)
        }
        
        // If still no sections, try secondary navigation
        if sections.isEmpty, let secondaryNav = dto.links.viaplaySecondaryNavigation {
            let mappedSections: [ContentSection] = secondaryNav.compactMap { sectionDTO in
                guard let href = URL(string: sectionDTO.href) else { return nil }
                
                return ContentSection(
                    title: sectionDTO.title,
                    description: nil,
                    href: href
                )
            }
            sections.append(contentsOf: mappedSections)
        }
        
        return sections
    }
}
