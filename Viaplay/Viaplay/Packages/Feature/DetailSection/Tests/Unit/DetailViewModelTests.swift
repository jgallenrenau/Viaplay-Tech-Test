import XCTest
import Domain
@testable import DetailSection

@MainActor
final class DetailViewModelTests: XCTestCase {
    var useCase: FetchDetailUseCaseSpy!
    var section: ContentSection!
    var sut: DetailViewModel!

    override func setUp() {
        super.setUp()
        useCase = FetchDetailUseCaseSpy()
        section = ContentSection(title: "Test Section", description: "Test Description")
        sut = DetailViewModel(section: section, fetchDetailUseCase: useCase)
    }

    override func tearDown() {
        useCase = nil
        section = nil
        sut = nil
        super.tearDown()
    }

    func test_loadDetail_success() async {
        let expectedDetailPage = Domain.DetailPage(
            title: "Test Section",
            items: [Domain.DetailItem(id: "1", title: "Test Item")]
        )
        useCase.result = .success(expectedDetailPage)

        await sut.loadDetail()

        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(sut.detailPage, expectedDetailPage)
        XCTAssertEqual(useCase.executeCalls, 1)
    }

    func test_loadDetail_failure() async {
        let expectedError = TestError.generic
        useCase.result = .failure(expectedError)

        await sut.loadDetail()

        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.errorMessage, expectedError.localizedDescription)
        XCTAssertNil(sut.detailPage)
        XCTAssertEqual(useCase.executeCalls, 1)
    }
}

private enum TestError: LocalizedError, Equatable {
    case generic
    var errorDescription: String? { "Test Error" }
}
