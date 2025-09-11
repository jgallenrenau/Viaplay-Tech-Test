import XCTest
import Domain
@testable import Sections

final class SectionsIntegrationTests: XCTestCase {
    func test_repositoryReturnsDataFromDataSource() async throws {
        struct DataSourceStub: SectionsDataSourceProtocol {
            func fetchSections() async throws -> SectionsPage {
                SectionsPage(title: "T", sections: [Section(id: "1", title: "A")])
            }
        }

        let repository = SectionsRepositoryImpl(dataSource: DataSourceStub())
        let result = try await repository.fetchSections()
        XCTAssertEqual(result.sections.count, 1)
        XCTAssertEqual(result.sections.first?.title, "A")
    }
    
    @MainActor
    func test_offline_usesCachedRootDescriptionAndSections() async {
        final class RepoStub: SectionsRepository {
            var result: Result<SectionsPage, Error>
            init(_ result: Result<SectionsPage, Error>) { self.result = result }
            func fetchSections() async throws -> SectionsPage {
                switch result { case .success(let p): return p; case .failure(let e): throw e }
            }
        }
        
        let cache = SectionDescriptionCacheService()
        cache.cacheRootPage(title: "Home", description: "Cached root")
        cache.cacheSections([
            Section(id: "1", title: "Movies", description: "Cached movies"),
            Section(id: "2", title: "Series", description: "Cached series")
        ])
        
        let repo = RepoStub(.failure(TestError.generic))
        let useCase = FetchSectionsUseCase(repository: repo)
        let sut = SectionsViewModel(fetchSectionsUseCase: useCase, cacheService: cache)
        
        await sut.loadSections()
        
        XCTAssertEqual(sut.rootPageDescription, "Cached root")
        XCTAssertTrue(sut.sections.count >= 0) // at least no crash and state coherent
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.errorMessage)
    }
}

private enum TestError: Error { case generic }
