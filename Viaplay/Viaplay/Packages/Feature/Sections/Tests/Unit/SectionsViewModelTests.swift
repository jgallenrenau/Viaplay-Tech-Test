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
}
