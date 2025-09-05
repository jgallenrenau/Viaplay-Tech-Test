import XCTest
import Domain
@testable import Sections

final class SectionsIntegrationTests: XCTestCase {
    func test_repositoryReturnsDataFromDataSource() async throws {
        struct DataSourceStub: SectionsDataSourceProtocol {
            func fetchSections() async throws -> SectionsPage {
                SectionsPage(title: "T", sections: [Section(id: "1", title: "A")])
            }
        }

        let repository = SectionsRepositoryImpl(dataSource: DataSourceStub())
        let result = try await repository.fetchSections()
        XCTAssertEqual(result.sections.count, 1)
        XCTAssertEqual(result.sections.first?.title, "A")
    }
}
