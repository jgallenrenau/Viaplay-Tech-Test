import Data
import Domain
import Foundation
import NetworkingKit
import StorageKit

public final class SectionsFactory {
    @MainActor public static func makeSectionsViewModel() -> SectionsViewModel {
        let pageRepository = PageRepositoryImpl(
            http: URLSessionHTTPClient(),
            cache: FileJSONDiskCache(),
            etagStore: UserDefaultsStore()
        )

        let dataSource = SectionsDataSource(pageRepository: pageRepository)
        let repository = SectionsRepositoryImpl(dataSource: dataSource)
        let useCase = FetchSectionsUseCase(repository: repository)
        
        // Create the cache service for descriptions
        let cacheService = SectionDescriptionCacheService()

        return SectionsViewModel(fetchSectionsUseCase: useCase, cacheService: cacheService)
    }
}
