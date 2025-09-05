import XCTest
import Domain
@testable import Sections

final class FetchSectionsUseCaseTests: XCTestCase {
    private var repo: SectionsRepositorySpy!
    private var sut: FetchSectionsUseCase!

    override func setUp() {
        super.setUp()
        repo = SectionsRepositorySpy()
        sut = FetchSectionsUseCase(repository: repo)
    }

    override func tearDown() {
        repo = nil
        sut = nil
        super.tearDown()
    }

    func test_execute_returnsSections() async throws {
        let expected = SectionsPage(title: "t", sections: [Section(id: "1", title: "A")])
        repo.result = .success(expected)

        let out = try await sut.execute()

        XCTAssertEqual(out.sections.count, 1)
        XCTAssertEqual(repo.fetchSectionsCalls, 1)
    }

    func test_execute_propagatesError() async {
        enum FetchError: Error { case generic }
        repo.result = .failure(FetchError.generic)
        do {
            _ = try await sut.execute()
            XCTFail("Expected error")
        } catch { }
        XCTAssertEqual(repo.fetchSectionsCalls, 1)
    }
}
