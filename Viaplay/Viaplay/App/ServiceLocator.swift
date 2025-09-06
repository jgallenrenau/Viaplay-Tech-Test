import Foundation
import Data
import Domain
import NetworkingKit
import StorageKit

/// Advanced Service Locator with protocol-based registration
public final class ServiceLocator {
    public static let shared = ServiceLocator()
    
    private var services: [String: Any] = [:]
    private var factories: [String: () -> Any] = [:]
    private let lock = NSLock()
    
    private init() {
        registerDefaultServices()
    }
    
    // MARK: - Registration
    public func register<T>(_ type: T.Type, instance: T) {
        let key = String(describing: type)
        lock.lock()
        defer { lock.unlock() }
        services[key] = instance
    }
    
    public func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        lock.lock()
        defer { lock.unlock() }
        factories[key] = factory
    }
    
    // MARK: - Resolution
    public func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        
        lock.lock()
        defer { lock.unlock() }
        
        // Check for existing instance
        if let instance = services[key] as? T {
            return instance
        }
        
        // Check for factory
        if let factory = factories[key] as? () -> T {
            let instance = factory()
            services[key] = instance
            return instance
        }
        
        fatalError("Service of type \(type) not registered")
    }
    
    // MARK: - Default Services Registration
    private func registerDefaultServices() {
        // Infrastructure
        register(HTTPClient.self, instance: URLSessionHTTPClient())
        register(JSONDiskCache.self, instance: FileJSONDiskCache())
        register(KeyValueStore.self, instance: UserDefaultsStore())
        
        // Repositories
        register(PageRepositoryProtocol.self) {
            PageRepositoryImpl(
                http: self.resolve(HTTPClient.self),
                cache: self.resolve(JSONDiskCache.self),
                etagStore: self.resolve(KeyValueStore.self)
            )
        }
        
        // Data Sources
        register(SectionsDataSource.self) {
            SectionsDataSource(pageRepository: self.resolve(PageRepositoryProtocol.self))
        }
        
        register(DetailDataSource.self) {
            DetailDataSource(pageRepository: self.resolve(PageRepositoryProtocol.self))
        }
        
        // Repositories
        register(SectionsRepositoryProtocol.self) {
            SectionsRepositoryImpl(dataSource: self.resolve(SectionsDataSource.self))
        }
        
        register(Domain.DetailRepositoryProtocol.self) {
            DetailRepositoryImpl(dataSource: self.resolve(DetailDataSource.self))
        }
        
        // Use Cases
        register(FetchSectionsUseCaseProtocol.self) {
            FetchSectionsUseCase(repository: self.resolve(SectionsRepositoryProtocol.self))
        }
        
        register(Domain.FetchDetailUseCaseProtocol.self) {
            Domain.FetchDetailUseCase(repository: self.resolve(Domain.DetailRepositoryProtocol.self))
        }
    }
    
    // MARK: - Testing Support
    public func reset() {
        lock.lock()
        defer { lock.unlock() }
        services.removeAll()
        factories.removeAll()
        registerDefaultServices()
    }
    
    public func registerMock<T>(_ type: T.Type, mock: T) {
        let key = String(describing: type)
        lock.lock()
        defer { lock.unlock() }
        services[key] = mock
    }
}

// MARK: - Convenience Extensions
extension ServiceLocator {
    public func makeSectionsViewModel() -> SectionsViewModel {
        SectionsViewModel(fetchSectionsUseCase: resolve(FetchSectionsUseCaseProtocol.self))
    }
    
    public func makeDetailViewModel(for section: ContentSection) -> DetailViewModel {
        DetailViewModel(section: section, fetchDetailUseCase: resolve(Domain.FetchDetailUseCaseProtocol.self))
    }
}
