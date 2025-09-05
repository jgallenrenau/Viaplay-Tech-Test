import XCTest
import Domain
@testable import DetailSection

final class FetchDetailUseCaseTests: XCTestCase {
    var repository: DetailRepositorySpy!
    var sut: Domain.FetchDetailUseCase!
    var section: ContentSection!

    override func setUp() {
        super.setUp()
        repository = DetailRepositorySpy()
        section = ContentSection(title: "Test Section", description: "Test Description")
        sut = Domain.FetchDetailUseCase(repository: repository)
    }

    override func tearDown() {
        repository = nil
        sut = nil
        section = nil
        super.tearDown()
    }

    func test_execute_success() async throws {
        let expectedDetailPage = Domain.DetailPage(
            title: "Test Section",
            items: [Domain.DetailItem(id: "1", title: "Test Item")]
        )
        repository.result = .success(expectedDetailPage)

        let result = try await sut.execute(section: section)

        XCTAssertEqual(result, expectedDetailPage)
        XCTAssertEqual(repository.fetchDetailCalls, 1)
    }

    func test_execute_failure() async {
        let expectedError = TestError.generic
        repository.result = .failure(expectedError)

        do {
            _ = try await sut.execute(section: section)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? TestError, expectedError)
            XCTAssertEqual(repository.fetchDetailCalls, 1)
        }
    }
}

private enum TestError: LocalizedError, Equatable {
    case generic
    var errorDescription: String? { "Test Error" }
}
