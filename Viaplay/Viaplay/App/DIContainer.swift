import Foundation
import Data
import Domain
import NetworkingKit
import StorageKit

/// Modern Dependency Injection Container using Swift 5.9+ features
@MainActor
public final class DIContainer: ObservableObject {
    public static let shared = DIContainer()
    
    // MARK: - Core Dependencies
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient()
    }()
    
    private lazy var cache: JSONDiskCache = {
        FileJSONDiskCache()
    }()
    
    private lazy var etagStore: KeyValueStore = {
        UserDefaultsStore()
    }()
    
    // MARK: - Repository Layer
    private lazy var pageRepository: PageRepository = {
        PageRepositoryImpl(
            http: httpClient,
            cache: cache,
            etagStore: etagStore
        )
    }()
    
    // MARK: - Data Sources
    private lazy var sectionsDataSource: SectionsDataSource = {
        SectionsDataSource(pageRepository: pageRepository)
    }()
    
    private lazy var detailDataSource: DetailDataSource = {
        DetailDataSource(pageRepository: pageRepository)
    }()
    
    // MARK: - Repositories
    private lazy var sectionsRepository: SectionsRepositoryProtocol = {
        SectionsRepositoryImpl(dataSource: sectionsDataSource)
    }()
    
    private lazy var detailRepository: Domain.DetailRepositoryProtocol = {
        DetailRepositoryImpl(dataSource: detailDataSource)
    }()
    
    // MARK: - Use Cases
    private lazy var fetchSectionsUseCase: FetchSectionsUseCaseProtocol = {
        FetchSectionsUseCase(repository: sectionsRepository)
    }()
    
    private lazy var fetchDetailUseCase: Domain.FetchDetailUseCaseProtocol = {
        Domain.FetchDetailUseCase(repository: detailRepository)
    }()
    
    // MARK: - ViewModels Factory
    public func makeSectionsViewModel() -> SectionsViewModel {
        SectionsViewModel(fetchSectionsUseCase: fetchSectionsUseCase)
    }
    
    public func makeDetailViewModel(for section: ContentSection) -> DetailViewModel {
        DetailViewModel(section: section, fetchDetailUseCase: fetchDetailUseCase)
    }
    
    
    private init() {}
}
// MARK: - Environment Key
struct DIContainerKey: EnvironmentKey {
    static let defaultValue = DIContainer.shared
}

extension EnvironmentValues {
    var diContainer: DIContainer {
        get { self[DIContainerKey.self] }
        set { self[DIContainerKey.self] = newValue }
    }
}
