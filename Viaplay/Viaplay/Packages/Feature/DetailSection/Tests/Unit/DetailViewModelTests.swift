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
    
    func test_initialState() {
        XCTAssertTrue(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertNil(sut.detailPage)
        XCTAssertEqual(useCase.executeCalls, 0)
    }
    
    func test_loadDetail_multipleCalls() async {
        let expectedDetailPage = Domain.DetailPage(
            title: "Test Section",
            items: [Domain.DetailItem(id: "1", title: "Test Item")]
        )
        useCase.result = .success(expectedDetailPage)

        await sut.loadDetail()
        await sut.loadDetail()

        XCTAssertEqual(useCase.executeCalls, 2)
        XCTAssertEqual(sut.detailPage, expectedDetailPage)
    }
    
    func test_loadDetail_loadingState() async {
        useCase.result = .success(Domain.DetailPage(title: "Test", items: []))
        
        // Start loading
        let loadingTask = Task {
            await sut.loadDetail()
        }
        
        // Verify loading state is true during execution
        XCTAssertTrue(sut.isLoading)
        
        await loadingTask.value
        
        // Verify loading state is false after completion
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_errorMessage_clearedOnSuccessfulLoad() async {
        // First load with error
        useCase.result = .failure(TestError.generic)
        await sut.loadDetail()
        
        XCTAssertNotNil(sut.errorMessage)
        
        // Second load with success
        let expectedDetailPage = Domain.DetailPage(title: "Test", items: [])
        useCase.result = .success(expectedDetailPage)
        await sut.loadDetail()
        
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(sut.detailPage, expectedDetailPage)
    }
}

private enum TestError: LocalizedError, Equatable {
    case generic
    var errorDescription: String? { "Test Error" }
}
