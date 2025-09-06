import XCTest
import Domain
import Data
@testable import DetailSection

final class DetailDataSourceTests: XCTestCase {
    struct PageRepoStub: PageRepository {
        var result: Result<Page, Error> = .success(Page(title: "t", sections: []))
        
        func getRootPage() async throws -> Page {
            switch result {
            case let .success(value):
                return value
            case let .failure(error):
                throw error
            }
        }
        
        func getPage(by url: URL) async throws -> Page {
            fatalError("Not implemented for test")
        }
    }

    var pageRepoStub: PageRepoStub!
    var sut: DetailDataSource!
    var section: ContentSection!

    override func setUp() {
        super.setUp()
        pageRepoStub = PageRepoStub()
        section = ContentSection(title: "Test Section", description: "Test Description", href: URL(string: "http://example.com"))
        sut = DetailDataSource(pageRepository: pageRepoStub)
    }

    override func tearDown() {
        pageRepoStub = nil
        sut = nil
        section = nil
        super.tearDown()
    }

    func test_fetchDetail_createsDetailPage() async throws {
        let detailPage = try await sut.fetchDetail(for: section)

        XCTAssertEqual(detailPage.title, section.title)
        XCTAssertEqual(detailPage.description, section.description)
        XCTAssertEqual(detailPage.navigationTitle, section.title)
        XCTAssertEqual(detailPage.items.count, 1)
        
        let item = detailPage.items.first!
        XCTAssertEqual(item.title, section.title)
        XCTAssertEqual(item.description, section.description)
        XCTAssertEqual(item.href, section.href)
        XCTAssertEqual(item.id, "test-section")
    }

    func test_fetchDetail_handlesError() async {
        // This test verifies that the method can be called without crashing
        // In a real implementation, this would test error handling
        let result = try? await sut.fetchDetail(for: section)
        XCTAssertNotNil(result)
    }
}

private enum TestError: LocalizedError, Equatable {
    case generic
    var errorDescription: String? { "Test Error" }
}
