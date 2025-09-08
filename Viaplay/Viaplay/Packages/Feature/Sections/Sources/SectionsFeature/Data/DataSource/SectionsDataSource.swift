import Data
import Domain
import Foundation

public final class SectionsDataSource: SectionsDataSourceProtocol {
    private let pageRepository: PageRepository

    public init(pageRepository: PageRepository) {
        self.pageRepository = pageRepository
    }

    public func fetchSections() async throws -> SectionsPage {
        let page = try await pageRepository.getRootPage()
        
        // Convert Page sections to Domain.Section
        let sections = page.sections.map { contentSection in
            Domain.Section(
                id: contentSection.title.lowercased().replacingOccurrences(of: " ", with: "-"),
                title: contentSection.title,
                href: contentSection.href,
                imageURL: nil,
                description: contentSection.description
            )
        }
        
        return SectionsPage(
            title: page.title,
            description: page.description,
            sections: sections,
            rootDescription: page.description
        )
    }
}
