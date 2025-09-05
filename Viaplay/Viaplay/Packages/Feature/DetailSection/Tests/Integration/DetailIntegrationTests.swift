import XCTest
import Domain
@testable import DetailSection
import Data

final class DetailIntegrationTests: XCTestCase {
    func test_fetchDetail_integration() async throws {
        struct MockPageRepository: PageRepository {
            func getRootPage() async throws -> Page {
                Page(title: "Integration Test", description: nil, sections: [])
            }
            
            func getPage(by url: URL) async throws -> Page {
                fatalError("Not implemented for integration test")
            }
        }

        let pageRepository = MockPageRepository()
        let dataSource = DetailDataSource(pageRepository: pageRepository)
        let repository = DetailRepositoryImpl(dataSource: dataSource)
        let useCase = Domain.FetchDetailUseCase(repository: repository)
        
        let section = ContentSection(title: "Integration Test Section", description: "Test Description")

        let detailPage = try await useCase.execute(section: section)

        XCTAssertEqual(detailPage.title, "Integration Test Section")
        XCTAssertEqual(detailPage.description, "Test Description")
        XCTAssertEqual(detailPage.navigationTitle, "Integration Test Section")
        XCTAssertEqual(detailPage.items.count, 1)
        XCTAssertEqual(detailPage.items.first?.title, "Integration Test Section")
    }
}
