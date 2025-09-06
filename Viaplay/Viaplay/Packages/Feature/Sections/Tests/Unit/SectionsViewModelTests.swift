import XCTest
import Domain
@testable import Sections

@MainActor
final class SectionsViewModelTests: XCTestCase {
    private var repo: SectionsRepositorySpy!
    private var useCase: FetchSectionsUseCase!
    private var sut: SectionsViewModel!

    override func setUp() async throws {
        try await super.setUp()
        repo = SectionsRepositorySpy()
        useCase = FetchSectionsUseCase(repository: repo)
        sut = SectionsViewModel(fetchSectionsUseCase: useCase)
    }

    override func tearDown() async throws {
        repo = nil
        useCase = nil
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
        XCTAssertTrue(sut.isLoading)
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
        
        // Start loading
        let loadingTask = Task {
            await sut.loadSections()
        }
        
        // Verify loading state is true during execution
        XCTAssertTrue(sut.isLoading)
        
        await loadingTask.value
        
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
}
