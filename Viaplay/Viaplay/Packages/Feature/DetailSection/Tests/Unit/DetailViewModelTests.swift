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
        XCTAssertFalse(sut.isLoading)
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
        
        // Verify initial state
        XCTAssertFalse(sut.isLoading)
        
        // Start loading
        await sut.loadDetail()
        
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
    
    func test_loadDetail_withEmptyItems() async {
        let expectedDetailPage = Domain.DetailPage(
            title: "Empty Section",
            description: "No items",
            items: []
        )
        useCase.result = .success(expectedDetailPage)
        
        await sut.loadDetail()
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(sut.detailPage?.items.count, 0)
    }
    
    func test_loadDetail_withMultipleItems() async {
        let expectedDetailPage = Domain.DetailPage(
            title: "Multi Item Section",
            description: "Multiple items",
            items: [
                Domain.DetailItem(id: "1", title: "Item 1"),
                Domain.DetailItem(id: "2", title: "Item 2"),
                Domain.DetailItem(id: "3", title: "Item 3")
            ]
        )
        useCase.result = .success(expectedDetailPage)
        
        await sut.loadDetail()
        
        XCTAssertEqual(sut.detailPage?.items.count, 3)
        XCTAssertEqual(sut.detailPage?.title, "Multi Item Section")
    }
    
    func test_loadDetail_concurrentCalls() async {
        let expectedDetailPage = Domain.DetailPage(title: "Test", items: [])
        useCase.result = .success(expectedDetailPage)
        
        // Start multiple concurrent loads
        async let load1: Void = sut.loadDetail()
        async let load2: Void = sut.loadDetail()
        async let load3: Void = sut.loadDetail()
        
        await load1
        await load2
        await load3
        
        // Should have called use case multiple times
        XCTAssertGreaterThan(useCase.executeCalls, 1)
    }
    
    func test_sectionProperty() {
        XCTAssertEqual(sut.section.title, "Test Section")
        XCTAssertEqual(sut.section.description, "Test Description")
    }
    
    func test_loadDetail_withNilDescription() async {
        let sectionWithNilDescription = ContentSection(title: "Test", description: nil)
        sut = DetailViewModel(section: sectionWithNilDescription, fetchDetailUseCase: useCase)
        
        let expectedDetailPage = Domain.DetailPage(
            title: "Test",
            description: nil,
            items: []
        )
        useCase.result = .success(expectedDetailPage)
        
        await sut.loadDetail()
        
        XCTAssertEqual(sut.detailPage?.description, nil)
    }
    
    func test_loadDetail_cancellation_setsLoadingFalseAndNoDetail() async {
        let delayedUseCase = DelayedFetchDetailUseCaseSpy(delayNanos: 500_000_000, result: .success(Domain.DetailPage(title: "T", items: [])))
        sut = DetailViewModel(section: section, fetchDetailUseCase: delayedUseCase)
        
        let task = Task { await sut.loadDetail() }
        
        // Give it a moment to flip isLoading to true, then cancel
        try? await Task.sleep(nanoseconds: 50_000_000)
        task.cancel()
        
        // Wait a bit to allow cancellation to propagate
        try? await Task.sleep(nanoseconds: 50_000_000)
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.detailPage)
    }
    
    func test_loadDetail_withInvalidSection_setsError() async {
        let invalidSection = ContentSection(title: "", description: nil)
        sut = DetailViewModel(section: invalidSection, fetchDetailUseCase: useCase)
        useCase.result = .failure(TestError.generic)
        
        await sut.loadDetail()
        
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertNil(sut.detailPage)
        XCTAssertFalse(sut.isLoading)
    }
}

private enum TestError: LocalizedError, Equatable {
    case generic
    var errorDescription: String? { "Test Error" }
}

// Local delayed use case for cancellation testing
private final class DelayedFetchDetailUseCaseSpy: Domain.FetchDetailUseCaseProtocol {
    let delayNanos: UInt64
    let result: Result<Domain.DetailPage, Error>
    init(delayNanos: UInt64, result: Result<Domain.DetailPage, Error>) {
        self.delayNanos = delayNanos
        self.result = result
    }
    func execute(section: ContentSection) async throws -> Domain.DetailPage {
        try await Task.sleep(nanoseconds: delayNanos)
        switch result {
        case let .success(value): return value
        case let .failure(error): throw error
        }
    }
}
