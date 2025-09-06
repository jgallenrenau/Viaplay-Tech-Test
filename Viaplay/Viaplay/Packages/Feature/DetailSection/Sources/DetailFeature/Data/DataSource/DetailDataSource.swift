import Data
import Domain
import Foundation
import NetworkingKit
import StorageKit

public final class DetailDataSource: DetailDataSourceProtocol {
    private let pageRepository: PageRepository

    public init(pageRepository: PageRepository) {
        self.pageRepository = pageRepository
    }

    public func fetchDetail(for section: ContentSection) async throws -> Domain.DetailPage {
        // For now, we'll simulate fetching detail data
        // In a real app, this would fetch from a specific detail endpoint
        // We use the pageRepository to ensure it's available and can throw errors
        _ = try await pageRepository.getRootPage()
        
        let detailItems = [
            Domain.DetailItem(
                id: generateId(from: section.title),
                title: section.title,
                description: section.description,
                href: section.href,
                content: "This is detailed content for \(section.title).",
                publishedDate: Date(),
                tags: ["featured", "popular"]
            )
        ]

        return Domain.DetailPage(
            title: section.title,
            description: section.description,
            items: detailItems,
            navigationTitle: section.title
        )
    }
    
    private func generateId(from title: String) -> String {
        // Remove all special characters except letters, numbers, and spaces
        let allowedCharacters = CharacterSet.alphanumerics.union(CharacterSet.whitespaces)
        let cleaned = title
            .lowercased()
            .components(separatedBy: allowedCharacters.inverted)
            .joined(separator: "")
            .replacingOccurrences(of: " ", with: "-")
        
        return cleaned
    }
}
