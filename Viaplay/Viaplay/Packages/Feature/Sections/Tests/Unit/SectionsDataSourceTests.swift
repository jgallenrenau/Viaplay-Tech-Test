import XCTest
import Domain
import Data
@testable import Sections

final class SectionsDataSourceTests: XCTestCase {
    struct PageRepoStub: PageRepository {
        func getRootPage() async throws -> Page {
            Page(
                title: "t",
                sections: [
                    ContentSection(title: "A", description: "d", href: nil)
                ]
            )
        }
        func getPage(by url: URL) async throws -> Page { fatalError() }
    }
    private var sut: SectionsDataSource!

    override func setUp() {
        super.setUp()
        sut = SectionsDataSource(pageRepository: PageRepoStub())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_mapsDomainModelsToFeatureModels() async throws {
        let page = try await sut.fetchSections()
        XCTAssertEqual(page.sections.first?.title, "A")
    }
}
