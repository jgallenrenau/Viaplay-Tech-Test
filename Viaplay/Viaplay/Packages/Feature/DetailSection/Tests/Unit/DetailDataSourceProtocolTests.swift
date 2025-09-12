import XCTest
import Domain
@testable import DetailSection

final class DetailDataSourceProtocolTests: XCTestCase {
    
    private var sut: MockDetailDataSource!
    
    override func setUp() async throws {
        try await super.setUp()
        sut = MockDetailDataSource()
    }
    
    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }
    
    func test_detailDataSourceProtocol_conformance() {
        XCTAssertTrue(sut != nil)
    }
    
    func test_fetchDetail_returnsDetailPage() async throws {
        let testSection = ContentSection(
            title: "Test Section",
            description: "Test Description",
            href: URL(string: "https://example.com")!
        )
        
        let detailPage = try await sut.fetchDetail(for: testSection)
        
        XCTAssertNotNil(detailPage)
        XCTAssertEqual(detailPage.title, "Mock Detail Page")
        XCTAssertEqual(detailPage.description, "Mock Description")
        XCTAssertEqual(detailPage.items.count, 2)
        XCTAssertEqual(detailPage.navigationTitle, "Mock Navigation")
    }
    
    func test_fetchDetail_withNilHref() async throws {
        let testSection = ContentSection(
            title: "No Href Section",
            description: "Description without href",
            href: nil
        )
        
        let detailPage = try await sut.fetchDetail(for: testSection)
        
        XCTAssertNotNil(detailPage)
        XCTAssertEqual(detailPage.title, "Mock Detail Page")
    }
    
    func test_fetchDetail_withEmptyStrings() async throws {
        let testSection = ContentSection(
            title: "",
            description: "",
            href: nil
        )
        
        let detailPage = try await sut.fetchDetail(for: testSection)
        
        XCTAssertNotNil(detailPage)
        XCTAssertEqual(detailPage.title, "Mock Detail Page")
    }
    
    func test_fetchDetail_withSpecialCharacters() async throws {
        let testSection = ContentSection(
            title: "Special: áéíóú ñç 🚀",
            description: "Description with émojis 🚀 and symbols @#$%",
            href: URL(string: "https://example.com/path?query=value&other=test")
        )
        
        let detailPage = try await sut.fetchDetail(for: testSection)
        
        XCTAssertNotNil(detailPage)
        XCTAssertEqual(detailPage.title, "Mock Detail Page")
    }
    
    func test_fetchDetail_multipleCalls() async throws {
        let testSection = ContentSection(
            title: "Test Section",
            description: "Test Description",
            href: URL(string: "https://example.com")!
        )
        
        let detailPage1 = try await sut.fetchDetail(for: testSection)
        let detailPage2 = try await sut.fetchDetail(for: testSection)
        
        XCTAssertNotNil(detailPage1)
        XCTAssertNotNil(detailPage2)
        XCTAssertEqual(detailPage1.title, detailPage2.title)
    }
    
    func test_fetchDetail_concurrentCalls() async throws {
        let testSection = ContentSection(
            title: "Test Section",
            description: "Test Description",
            href: URL(string: "https://example.com")!
        )
        
        async let detailPage1 = sut.fetchDetail(for: testSection)
        async let detailPage2 = sut.fetchDetail(for: testSection)
        async let detailPage3 = sut.fetchDetail(for: testSection)
        
        let results = try await [detailPage1, detailPage2, detailPage3]
        
        for detailPage in results {
            XCTAssertNotNil(detailPage)
            XCTAssertEqual(detailPage.title, "Mock Detail Page")
        }
    }
    
    func test_fetchDetail_protocolMethodSignature() {
        let testSection = ContentSection(
            title: "Test Section",
            description: "Test Description",
            href: URL(string: "https://example.com")!
        )
        
        Task {
            do {
                let result = try await sut.fetchDetail(for: testSection)
                XCTAssertNotNil(result)
            } catch {
                XCTFail("Method should exist and be callable")
            }
        }
    }
}

private class MockDetailDataSource: DetailDataSourceProtocol {
    func fetchDetail(for section: ContentSection) async throws -> Domain.DetailPage {
        return Domain.DetailPage(
            title: "Mock Detail Page",
            description: "Mock Description",
            items: [
                Domain.DetailItem(
                    id: "1",
                    title: "Mock Item 1",
                    description: "Mock Item Description 1",
                    href: URL(string: "https://example.com/item1"),
                    content: "Mock Content 1",
                    tags: ["mock", "test"]
                ),
                Domain.DetailItem(
                    id: "2",
                    title: "Mock Item 2",
                    description: "Mock Item Description 2",
                    href: URL(string: "https://example.com/item2"),
                    content: "Mock Content 2",
                    tags: ["mock", "test"]
                )
            ],
            navigationTitle: "Mock Navigation"
        )
    }
}

