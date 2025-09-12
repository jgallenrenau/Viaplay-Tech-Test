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
    
    func test_fetchSections_successWithMultipleSections() async throws {
        let mockRepository = MockPageRepository()
        mockRepository.getRootPageResult = .success(Domain.Page(
            title: "Test Page",
            description: "Test Description",
            sections: [
                ContentSection(title: "Section 1", description: "Description 1", href: URL(string: "https://example.com/1")),
                ContentSection(title: "Section 2", description: "Description 2", href: URL(string: "https://example.com/2")),
                ContentSection(title: "Section 3", description: "Description 3", href: nil)
            ]
        ))
        
        let sut = SectionsDataSource(pageRepository: mockRepository)
        let result = try await sut.fetchSections()
        
        XCTAssertEqual(result.title, "Test Page")
        XCTAssertEqual(result.description, "Test Description")
        XCTAssertEqual(result.sections.count, 3)
        
        XCTAssertEqual(result.sections[0].title, "Section 1")
        XCTAssertEqual(result.sections[0].description, "Description 1")
        XCTAssertEqual(result.sections[0].href, URL(string: "https://example.com/1"))
        XCTAssertEqual(result.sections[0].id, "section-1")
        
        XCTAssertEqual(result.sections[1].title, "Section 2")
        XCTAssertEqual(result.sections[1].description, "Description 2")
        XCTAssertEqual(result.sections[1].href, URL(string: "https://example.com/2"))
        XCTAssertEqual(result.sections[1].id, "section-2")
        
        XCTAssertEqual(result.sections[2].title, "Section 3")
        XCTAssertEqual(result.sections[2].description, "Description 3")
        XCTAssertNil(result.sections[2].href)
        XCTAssertEqual(result.sections[2].id, "section-3")
    }
    
    func test_fetchSections_successWithEmptySections() async throws {
        let mockRepository = MockPageRepository()
        mockRepository.getRootPageResult = .success(Domain.Page(
            title: "Empty Page",
            description: "Empty Description",
            sections: []
        ))
        
        let sut = SectionsDataSource(pageRepository: mockRepository)
        let result = try await sut.fetchSections()
        
        XCTAssertEqual(result.title, "Empty Page")
        XCTAssertEqual(result.description, "Empty Description")
        XCTAssertTrue(result.sections.isEmpty)
    }
    
    func test_fetchSections_propagatesRepositoryError() async {
        let mockRepository = MockPageRepository()
        mockRepository.getRootPageResult = .failure(TestError.generic)
        
        let sut = SectionsDataSource(pageRepository: mockRepository)
        
        do {
            _ = try await sut.fetchSections()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
    
    func test_fetchSections_generatesCorrectIds() async throws {
        let mockRepository = MockPageRepository()
        mockRepository.getRootPageResult = .success(Domain.Page(
            title: "Test Page",
            sections: [
                ContentSection(title: "Section With Spaces", description: "Description", href: nil),
                ContentSection(title: "Section!@#$%", description: "Description", href: nil),
                ContentSection(title: "UPPERCASE SECTION", description: "Description", href: nil)
            ]
        ))
        
        let sut = SectionsDataSource(pageRepository: mockRepository)
        let result = try await sut.fetchSections()
        
        XCTAssertEqual(result.sections[0].id, "section-with-spaces")
        XCTAssertEqual(result.sections[1].id, "section!@#$%")
        XCTAssertEqual(result.sections[2].id, "uppercase-section")
    }
    
    func test_fetchSections_callsRepository() async throws {
        let mockRepository = MockPageRepository()
        mockRepository.getRootPageResult = .success(Domain.Page(title: "Test", sections: []))
        
        let sut = SectionsDataSource(pageRepository: mockRepository)
        _ = try await sut.fetchSections()
        
        XCTAssertEqual(mockRepository.getRootPageCallCount, 1)
    }
    
    func test_fetchSections_handlesURLVariants() async throws {
        let mockRepository = MockPageRepository()
        mockRepository.getRootPageResult = .success(Domain.Page(
            title: "Test",
            sections: [
                ContentSection(title: "With Query", description: nil, href: URL(string: "https://example.com/p?x=1&y=2")),
                ContentSection(title: "With Fragment", description: nil, href: URL(string: "https://example.com/p#frag")),
                ContentSection(title: "With Port", description: nil, href: URL(string: "https://example.com:8080/p"))
            ]
        ))
        let sut = SectionsDataSource(pageRepository: mockRepository)
        let result = try await sut.fetchSections()
        
        XCTAssertEqual(result.sections[0].href?.absoluteString, "https://example.com/p?x=1&y=2")
        XCTAssertEqual(result.sections[1].href?.absoluteString, "https://example.com/p#frag")
        XCTAssertEqual(result.sections[2].href?.absoluteString, "https://example.com:8080/p")
    }
    
    func test_fetchSections_duplicateTitles_generateStableIds() async throws {
        let mockRepository = MockPageRepository()
        mockRepository.getRootPageResult = .success(Domain.Page(
            title: "Test",
            sections: [
                ContentSection(title: "Dup", description: nil, href: nil),
                ContentSection(title: "Dup", description: nil, href: nil)
            ]
        ))
        let sut = SectionsDataSource(pageRepository: mockRepository)
        let result = try await sut.fetchSections()
        
        XCTAssertEqual(result.sections[0].id, "dup")
        XCTAssertEqual(result.sections[1].id, "dup")
    }
    
}


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
