import XCTest
import Domain
import Data
@testable import DetailSection

final class DetailDataSourceTests: XCTestCase {
    
    class MockPageRepository: PageRepository {
        var getRootPageResult: Result<Domain.Page, Error> = .success(Domain.Page(title: "Test", sections: []))
        var getRootPageCallCount = 0
        
        func getRootPage() async throws -> Domain.Page {
            getRootPageCallCount += 1
            switch getRootPageResult {
            case .success(let page):
                return page
            case .failure(let error):
                throw error
            }
        }
        
        func getPage(by url: URL) async throws -> Domain.Page {
            throw TestError.notImplemented
        }
    }
    
    var mockRepository: MockPageRepository!
    var sut: DetailDataSource!
    var section: ContentSection!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockPageRepository()
        sut = DetailDataSource(pageRepository: mockRepository)
        section = ContentSection(title: "Test Section", description: "Test Description")
    }
    
    override func tearDown() {
        mockRepository = nil
        sut = nil
        section = nil
        super.tearDown()
    }
    
    func test_fetchDetail_success() async throws {
        let result = try await sut.fetchDetail(for: section)
        
        XCTAssertEqual(result.title, section.title)
        XCTAssertEqual(result.description, section.description)
        XCTAssertEqual(result.navigationTitle, section.title)
        XCTAssertEqual(result.items.count, 1)
        
        let item = result.items.first!
        XCTAssertEqual(item.title, section.title)
        XCTAssertEqual(item.description, section.description)
        XCTAssertEqual(item.href, section.href)
        XCTAssertTrue(item.content?.contains("This is detailed content for") == true)
        XCTAssertEqual(item.tags, ["featured", "popular"])
        XCTAssertNotNil(item.publishedDate)
    }
    
    func test_fetchDetail_callsRepository() async throws {
        _ = try await sut.fetchDetail(for: section)
        
        XCTAssertEqual(mockRepository.getRootPageCallCount, 1)
    }
    
    func test_fetchDetail_propagatesRepositoryError() async {
        mockRepository.getRootPageResult = .failure(TestError.generic)
        
        do {
            _ = try await sut.fetchDetail(for: section)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
    
    func test_fetchDetail_withHref() async throws {
        let sectionWithHref = ContentSection(
            title: "Section With Href",
            description: "Description",
            href: URL(string: "https://example.com")
        )
        
        let result = try await sut.fetchDetail(for: sectionWithHref)
        
        XCTAssertEqual(result.items.first?.href, sectionWithHref.href)
    }
    
    func test_fetchDetail_withoutHref() async throws {
        let sectionWithoutHref = ContentSection(
            title: "Section Without Href",
            description: "Description",
            href: nil
        )
        
        let result = try await sut.fetchDetail(for: sectionWithoutHref)
        
        XCTAssertNil(result.items.first?.href)
    }
    
    func test_fetchDetail_generatesCorrectId() async throws {
        let sectionWithSpaces = ContentSection(title: "Section With Spaces", description: "Description")
        
        let result = try await sut.fetchDetail(for: sectionWithSpaces)
        
        let expectedId = "section-with-spaces"
        XCTAssertEqual(result.items.first?.id, expectedId)
    }
    
    func test_fetchDetail_withSpecialCharacters() async throws {
        let sectionWithSpecialChars = ContentSection(title: "Section!@#$%^&*()", description: "Description")
        
        let result = try await sut.fetchDetail(for: sectionWithSpecialChars)
        
        let item = result.items.first!
        XCTAssertTrue(item.id.contains("section"))
        XCTAssertFalse(item.id.contains("!"))
        XCTAssertFalse(item.id.contains("@"))
    }
    
    func test_fetchDetail_multipleCalls() async throws {
        _ = try await sut.fetchDetail(for: section)
        _ = try await sut.fetchDetail(for: section)
        
        XCTAssertEqual(mockRepository.getRootPageCallCount, 2)
    }
}

private enum TestError: LocalizedError, Equatable {
    case generic
    case notImplemented
    
    var errorDescription: String? {
        switch self {
        case .generic:
            return "Generic test error"
        case .notImplemented:
            return "Not implemented"
        }
    }
}