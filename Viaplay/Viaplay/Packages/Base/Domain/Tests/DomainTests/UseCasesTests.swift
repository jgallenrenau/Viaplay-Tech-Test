import XCTest
@testable import Domain

// Fake repository for testing use cases
private final class FakeSectionsRepository: SectionsRepository {
    var sectionsPage: SectionsPage
    init(sectionsPage: SectionsPage) { self.sectionsPage = sectionsPage }
    func fetchSections() async throws -> SectionsPage { sectionsPage }
}

private final class FakeDetailRepository: DetailRepositoryProtocol {
    var detailPage: DetailPage
    init(detailPage: DetailPage) { self.detailPage = detailPage }
    func fetchDetail(for section: ContentSection) async throws -> DetailPage { detailPage }
}

final class UseCasesTests: XCTestCase {
    func testFetchSectionsReturnsSectionsPage() async throws {
        let sectionsPage = SectionsPage(
            title: "Sections",
            description: "Available sections",
            sections: [
                Section(id: "sport", title: "Sport", href: URL(string: "https://example.com/sport")!, imageURL: nil, description: "Sports content"),
                Section(id: "movies", title: "Movies", href: URL(string: "https://example.com/movies")!, imageURL: nil, description: "Movie content")
            ]
        )
        let repo = FakeSectionsRepository(sectionsPage: sectionsPage)
        let useCase = FetchSectionsUseCase(repository: repo)
        let result = try await useCase.execute()
        XCTAssertEqual(result.sections.count, 2)
        XCTAssertEqual(result.sections.first?.title, "Sport")
    }

    func testFetchDetailReturnsDetailPage() async throws {
        let section = ContentSection(title: "Sport", description: "Sports content", href: URL(string: "https://example.com/sport")!)
        let detailPage = DetailPage(
            title: "Sport",
            description: "Sports content",
            items: [
                DetailItem(id: "1", title: "Football", description: "Football content", href: URL(string: "https://example.com/football")!)
            ], navigationTitle: "Sport"
        )
        let repo = FakeDetailRepository(detailPage: detailPage)
        let useCase = FetchDetailUseCase(repository: repo)
        let result = try await useCase.execute(section: section)
        XCTAssertEqual(result.title, "Sport")
        XCTAssertEqual(result.items.count, 1)
        XCTAssertEqual(result.items.first?.title, "Football")
    }
}
