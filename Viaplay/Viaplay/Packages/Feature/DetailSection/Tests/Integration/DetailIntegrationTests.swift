import XCTest
import Domain
@testable import DetailSection

final class DetailIntegrationTests: XCTestCase {
    final class RepoStub: DetailRepositoryProtocol {
        var result: Result<DetailPage, Error> = .success(DetailPage(title: "T", items: []))
        func fetchDetail(for section: ContentSection) async throws -> DetailPage {
            switch result { case .success(let p): return p; case .failure(let e): throw e }
        }
    }
    
    @MainActor
    func test_endToEnd_viewModelLoadsFromRepository() async {
        let repo = RepoStub()
        let useCase = FetchDetailUseCase(repository: repo)
        let section = ContentSection(title: "S", description: "D")
        let sut = DetailViewModel(section: section, fetchDetailUseCase: useCase)
        await sut.loadDetail()
        XCTAssertEqual(sut.detailPage?.title, "T")
        XCTAssertNil(sut.errorMessage)
    }
    
    @MainActor
    func test_offline_setsError_andStopsLoading() async {
        let repo = RepoStub(); repo.result = .failure(TestError.generic)
        let useCase = FetchDetailUseCase(repository: repo)
        let section = ContentSection(title: "S", description: "D")
        let sut = DetailViewModel(section: section, fetchDetailUseCase: useCase)
        await sut.loadDetail()
        XCTAssertNotNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    @MainActor
    func test_parallelLoad_doesNotLeaveLoadingTrue() async {
        let repo = RepoStub()
        let useCase = FetchDetailUseCase(repository: repo)
        let section = ContentSection(title: "S", description: "D")
        let sut = DetailViewModel(section: section, fetchDetailUseCase: useCase)
        async let a: Void = sut.loadDetail()
        async let b: Void = sut.loadDetail()
        _ = await (a, b)
        XCTAssertFalse(sut.isLoading)
    }
}

private enum TestError: Error { case generic }
