import XCTest
import Domain
@testable import Sections

@MainActor
final class SectionsViewModelTests: XCTestCase {
    private var repo: SectionsRepositorySpy!
    private var useCase: FetchSectionsUseCase!
    private var cacheService: SectionDescriptionCacheService!
    private var sut: SectionsViewModel!

    override func setUp() async throws {
        try await super.setUp()
        repo = SectionsRepositorySpy()
        useCase = FetchSectionsUseCase(repository: repo)
        cacheService = SectionDescriptionCacheService()
        sut = SectionsViewModel(fetchSectionsUseCase: useCase, cacheService: cacheService)
    }

    override func tearDown() async throws {
        repo = nil
        useCase = nil
        cacheService = nil
        sut = nil
        try await super.tearDown()
    }

    func test_loadSections_success_setsSections() async {
        repo.result = .success(SectionsPage(title: "Home", sections: [
            Section(id: "id", title: "Title")
        ]))

        await sut.loadSections()

        XCTAssertEqual(sut.sections.count, 1)
        XCTAssertEqual(sut.sections.first?.title, "Title")
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }

    func test_loadSections_failure_setsError() async {
        enum FetchError: Error { case generic }
        repo.result = .failure(FetchError.generic)

        await sut.loadSections()

        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.sections.isEmpty)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_initialState() {
        XCTAssertTrue(sut.sections.isEmpty)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_loadSections_multipleCalls() async {
        repo.result = .success(SectionsPage(title: "Home", sections: [
            Section(id: "id", title: "Title")
        ]))

        await sut.loadSections()
        await sut.loadSections()

        XCTAssertEqual(repo.fetchSectionsCalls, 2)
        XCTAssertEqual(sut.sections.count, 1)
    }
    
    func test_loadSections_loadingState() async {
        repo.result = .success(SectionsPage(title: "Home", sections: []))
        
        // Verify initial state
        XCTAssertFalse(sut.isLoading)
        
        // Start loading
        await sut.loadSections()
        
        // Verify loading state is false after completion
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_errorMessage_clearedOnSuccessfulLoad() async {
        // First load with error
        enum FetchError: Error { case generic }
        repo.result = .failure(FetchError.generic)
        await sut.loadSections()
        
        XCTAssertNotNil(sut.errorMessage)
        
        // Second load with success
        repo.result = .success(SectionsPage(title: "Home", sections: []))
        await sut.loadSections()
        
        XCTAssertNil(sut.errorMessage)
        XCTAssertTrue(sut.sections.isEmpty)
    }
    
    func test_loadSections_withEmptySections() async {
        repo.result = .success(SectionsPage(title: "Home", sections: []))

        await sut.loadSections()

        XCTAssertTrue(sut.sections.isEmpty)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_loadSections_withMultipleSections() async {
        repo.result = .success(SectionsPage(title: "Home", sections: [
            Section(id: "1", title: "Section 1"),
            Section(id: "2", title: "Section 2"),
            Section(id: "3", title: "Section 3")
        ]))

        await sut.loadSections()

        XCTAssertEqual(sut.sections.count, 3)
        XCTAssertEqual(sut.sections[0].title, "Section 1")
        XCTAssertEqual(sut.sections[1].title, "Section 2")
        XCTAssertEqual(sut.sections[2].title, "Section 3")
    }
    
    func test_loadSections_cachesRootPageAndSections() async {
        let section1 = Section(id: "1", title: "One", href: nil, imageURL: nil, description: "Desc 1")
        let section2 = Section(id: "2", title: "Two", href: nil, imageURL: nil, description: "Desc 2")
        let sectionsPage = SectionsPage(title: "Home", description: "Root Desc", sections: [section1, section2], rootDescription: "Root Desc")
        repo.result = .success(sectionsPage)
        
        await sut.loadSections()
        
        XCTAssertEqual(sut.rootPageDescription, "Root Desc")
        XCTAssertTrue(cacheService.isSectionCached("1"))
        XCTAssertTrue(cacheService.isSectionCached("2"))
        XCTAssertEqual(cacheService.getSectionDescription(for: "1")?.description, "Desc 1")
        XCTAssertEqual(cacheService.getSectionDescription(for: "2")?.description, "Desc 2")
    }
    
    func test_getSectionDescription_and_isSectionCached_afterLoad() async {
        let section = Section(id: "abc", title: "S", href: nil, imageURL: nil, description: "D")
        repo.result = .success(SectionsPage(title: "T", description: nil, sections: [section], rootDescription: nil))
        
        await sut.loadSections()
        
        XCTAssertTrue(sut.isSectionCached("abc"))
        XCTAssertEqual(sut.getSectionDescription(for: "abc"), "D")
    }
}
