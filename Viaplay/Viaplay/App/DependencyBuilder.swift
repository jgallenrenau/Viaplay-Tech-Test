import Foundation
import Data
import Domain
import NetworkingKit
import StorageKit

/// Builder pattern for creating dependency configurations
public final class DependencyBuilder {
    
    // MARK: - Configuration Types
    public enum Environment {
        case production
        case development
        case testing
    }
    
    public enum CacheStrategy {
        case memory
        case disk
        case hybrid
    }
    
    public enum NetworkStrategy {
        case real
        case mock
        case stubbed
    }
    
    // MARK: - Properties
    private var environment: Environment = .production
    private var cacheStrategy: CacheStrategy = .hybrid
    private var networkStrategy: NetworkStrategy = .real
    private var enableLogging: Bool = true
    private var enableAnalytics: Bool = false
    
    // MARK: - Configuration Methods
    public func environment(_ env: Environment) -> DependencyBuilder {
        self.environment = env
        return self
    }
    
    public func cacheStrategy(_ strategy: CacheStrategy) -> DependencyBuilder {
        self.cacheStrategy = strategy
        return self
    }
    
    public func networkStrategy(_ strategy: NetworkStrategy) -> DependencyBuilder {
        self.networkStrategy = strategy
        return self
    }
    
    public func enableLogging(_ enabled: Bool) -> DependencyBuilder {
        self.enableLogging = enabled
        return self
    }
    
    public func enableAnalytics(_ enabled: Bool) -> DependencyBuilder {
        self.enableAnalytics = enabled
        return self
    }
    
    // MARK: - Build Methods
    public func build() -> DependencyConfiguration {
        DependencyConfiguration(
            environment: environment,
            cacheStrategy: cacheStrategy,
            networkStrategy: networkStrategy,
            enableLogging: enableLogging,
            enableAnalytics: enableAnalytics
        )
    }
}

// MARK: - Configuration
public struct DependencyConfiguration {
    let environment: DependencyBuilder.Environment
    let cacheStrategy: DependencyBuilder.CacheStrategy
    let networkStrategy: DependencyBuilder.NetworkStrategy
    let enableLogging: Bool
    let enableAnalytics: Bool
}

// MARK: - Factory with Configuration
public final class ConfiguredDIFactory {
    private let configuration: DependencyConfiguration
    
    public init(configuration: DependencyConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: - Infrastructure Creation
    public func makeHTTPClient() -> HTTPClient {
        switch configuration.networkStrategy {
        case .real:
            return URLSessionHTTPClient()
        case .mock:
            return MockHTTPClient()
        case .stubbed:
            return StubbedHTTPClient()
        }
    }
    
    public func makeCache() -> JSONDiskCache {
        switch configuration.cacheStrategy {
        case .memory:
            return MemoryJSONDiskCache()
        case .disk:
            return FileJSONDiskCache()
        case .hybrid:
            return HybridJSONDiskCache()
        }
    }
    
    public func makeEtagStore() -> KeyValueStore {
        switch configuration.environment {
        case .testing:
            return InMemoryKeyValueStore()
        default:
            return UserDefaultsStore()
        }
    }
    
    // MARK: - Repository Creation
    public func makePageRepository() -> PageRepositoryProtocol {
        PageRepositoryImpl(
            http: makeHTTPClient(),
            cache: makeCache(),
            etagStore: makeEtagStore()
        )
    }
    
    // MARK: - Use Case Creation
    public func makeFetchSectionsUseCase() -> FetchSectionsUseCaseProtocol {
        let repository = makePageRepository()
        let dataSource = SectionsDataSource(pageRepository: repository)
        let sectionsRepository = SectionsRepositoryImpl(dataSource: dataSource)
        return FetchSectionsUseCase(repository: sectionsRepository)
    }
    
    public func makeFetchDetailUseCase() -> Domain.FetchDetailUseCaseProtocol {
        let repository = makePageRepository()
        let dataSource = DetailDataSource(pageRepository: repository)
        let detailRepository = DetailRepositoryImpl(dataSource: dataSource)
        return Domain.FetchDetailUseCase(repository: detailRepository)
    }
    
    // MARK: - ViewModel Creation
    public func makeSectionsViewModel() -> SectionsViewModel {
        SectionsViewModel(fetchSectionsUseCase: makeFetchSectionsUseCase())
    }
    
    public func makeDetailViewModel(for section: ContentSection) -> DetailViewModel {
        DetailViewModel(section: section, fetchDetailUseCase: makeFetchDetailUseCase())
    }
}

// MARK: - Mock Implementations (for testing)
private class MockHTTPClient: HTTPClient {
    func get(_ url: URL, headers: [String: String]) async throws -> HTTPResponse {
        HTTPResponse(statusCode: 200, data: Data(), headers: [:])
    }
}

private class StubbedHTTPClient: HTTPClient {
    func get(_ url: URL, headers: [String: String]) async throws -> HTTPResponse {
        // Return stubbed data based on URL
        let stubbedData = """
        {
            "type": "page",
            "pageType": "sections",
            "title": "Viaplay Sections",
            "description": "Stubbed data for testing",
            "_links": {
                "viaplay:sections": [
                    {
                        "id": "1",
                        "title": "Stubbed Section",
                        "href": "https://example.com/section1",
                        "type": "section",
                        "sectionSort": 1,
                        "name": "stubbed-section",
                        "templated": false
                    }
                ]
            }
        }
        """.data(using: .utf8)!
        
        return HTTPResponse(statusCode: 200, data: stubbedData, headers: [:])
    }
}

private class MemoryJSONDiskCache: JSONDiskCache {
    private var cache: [String: Data] = [:]
    
    func write<T: Codable>(_ object: T, for key: String) throws {
        let data = try JSONEncoder().encode(object)
        cache[key] = data
    }
    
    func read<T: Codable>(for key: String, as type: T.Type) throws -> T? {
        guard let data = cache[key] else { return nil }
        return try JSONDecoder().decode(type, from: data)
    }
    
    func remove(for key: String) throws {
        cache.removeValue(forKey: key)
    }
    
    func clear() throws {
        cache.removeAll()
    }
}

private class HybridJSONDiskCache: JSONDiskCache {
    private let memoryCache = MemoryJSONDiskCache()
    private let diskCache = FileJSONDiskCache()
    
    func write<T: Codable>(_ object: T, for key: String) throws {
        try memoryCache.write(object, for: key)
        try diskCache.write(object, for: key)
    }
    
    func read<T: Codable>(for key: String, as type: T.Type) throws -> T? {
        if let memoryResult = try memoryCache.read(for: key, as: type) {
            return memoryResult
        }
        
        if let diskResult = try diskCache.read(for: key, as: type) {
            // Populate memory cache
            try memoryCache.write(diskResult, for: key)
            return diskResult
        }
        
        return nil
    }
    
    func remove(for key: String) throws {
        try memoryCache.remove(for: key)
        try diskCache.remove(for: key)
    }
    
    func clear() throws {
        try memoryCache.clear()
        try diskCache.clear()
    }
}

private class InMemoryKeyValueStore: KeyValueStore {
    private var store: [String: String] = [:]
    
    func set(_ value: String, for key: String) {
        store[key] = value
    }
    
    func get(_ key: String) -> String? {
        store[key]
    }
    
    func remove(for key: String) {
        store.removeValue(forKey: key)
    }
    
    func clear() {
        store.removeAll()
    }
}
