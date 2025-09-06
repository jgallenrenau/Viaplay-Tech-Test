import Foundation
import SwiftUI
import Sections
import DetailSection

/// Examples of different Dependency Injection patterns and configurations
public struct DependencyInjectionExamples {
    
    // MARK: - Example 1: Basic DIContainer Usage
    public static func basicExample() -> some View {
        ContentView()
            .environment(\.diContainer, DIContainer.shared)
    }
    
    // MARK: - Example 2: Service Locator Pattern
    public static func serviceLocatorExample() -> some View {
        let locator = ServiceLocator.shared
        return SectionsListView(viewModel: locator.makeSectionsViewModel())
    }
    
    // MARK: - Example 3: Builder Pattern with Configuration
    public static func builderPatternExample() -> some View {
        let configuration = DependencyBuilder()
            .environment(.development)
            .cacheStrategy(.hybrid)
            .networkStrategy(.real)
            .enableLogging(true)
            .build()
        
        let factory = ConfiguredDIFactory(configuration: configuration)
        return SectionsListView(viewModel: factory.makeSectionsViewModel())
    }
    
    // MARK: - Example 4: Environment-based Configuration
    public static func environmentBasedExample() -> some View {
        let appConfig = AppConfiguration.shared
        let diFactory = EnvironmentDIFactory(configuration: appConfig)
        let container = diFactory.makeDIContainer()
        
        return ContentView()
            .environment(\.diContainer, container)
    }
    
    // MARK: - Example 5: Testing Configuration
    public static func testingExample() -> some View {
        let testConfig = AppConfiguration.createForTesting()
        let diFactory = EnvironmentDIFactory(configuration: testConfig)
        let container = diFactory.makeDIContainer()
        
        return ContentView()
            .environment(\.diContainer, container)
    }
    
    // MARK: - Example 6: Custom Dependencies
    public static func customDependenciesExample() -> some View {
        let container = DIContainer.shared
        
        // Register custom dependencies
        ServiceLocator.shared.registerMock(HTTPClient.self, mock: MockHTTPClient())
        ServiceLocator.shared.registerMock(JSONDiskCache.self, mock: MemoryJSONDiskCache())
        
        return ContentView()
            .environment(\.diContainer, container)
    }
}

// MARK: - Advanced DI Patterns

/// Protocol-based dependency injection for better testability
public protocol DIFactoryProtocol {
    func makeSectionsViewModel() -> SectionsViewModel
    func makeDetailViewModel(for section: ContentSection) -> DetailViewModel
}

/// Production DI Factory
public final class ProductionDIFactory: DIFactoryProtocol {
    public init() {}
    
    public func makeSectionsViewModel() -> SectionsViewModel {
        let configuration = DependencyBuilder()
            .environment(.production)
            .cacheStrategy(.hybrid)
            .networkStrategy(.real)
            .enableLogging(false)
            .build()
        
        let factory = ConfiguredDIFactory(configuration: configuration)
        return factory.makeSectionsViewModel()
    }
    
    public func makeDetailViewModel(for section: ContentSection) -> DetailViewModel {
        let configuration = DependencyBuilder()
            .environment(.production)
            .cacheStrategy(.hybrid)
            .networkStrategy(.real)
            .enableLogging(false)
            .build()
        
        let factory = ConfiguredDIFactory(configuration: configuration)
        return factory.makeDetailViewModel(for: section)
    }
}

/// Testing DI Factory
public final class TestingDIFactory: DIFactoryProtocol {
    public init() {}
    
    public func makeSectionsViewModel() -> SectionsViewModel {
        let configuration = DependencyBuilder()
            .environment(.testing)
            .cacheStrategy(.memory)
            .networkStrategy(.mock)
            .enableLogging(false)
            .build()
        
        let factory = ConfiguredDIFactory(configuration: configuration)
        return factory.makeSectionsViewModel()
    }
    
    public func makeDetailViewModel(for section: ContentSection) -> DetailViewModel {
        let configuration = DependencyBuilder()
            .environment(.testing)
            .cacheStrategy(.memory)
            .networkStrategy(.mock)
            .enableLogging(false)
            .build()
        
        let factory = ConfiguredDIFactory(configuration: configuration)
        return factory.makeDetailViewModel(for: section)
    }
}

// MARK: - Dependency Injection Best Practices

/// Best practices for dependency injection in SwiftUI
public struct DIBestPractices {
    
    /// 1. Use Environment for DI Container
    public static func useEnvironmentForContainer() -> some View {
        ContentView()
            .environment(\.diContainer, DIContainer.shared)
    }
    
    /// 2. Inject Dependencies in ViewModels
    public static func injectInViewModels() -> some View {
        let viewModel = DIContainer.shared.makeSectionsViewModel()
        return SectionsListView(viewModel: viewModel)
    }
    
    /// 3. Use Protocols for Testability
    public static func useProtocolsForTesting() -> some View {
        let factory: DIFactoryProtocol = TestingDIFactory()
        return SectionsListView(viewModel: factory.makeSectionsViewModel())
    }
    
    /// 4. Configure for Different Environments
    public static func configureForEnvironments() -> some View {
        #if DEBUG
        let factory = TestingDIFactory()
        #else
        let factory = ProductionDIFactory()
        #endif
        
        return SectionsListView(viewModel: factory.makeSectionsViewModel())
    }
    
    /// 5. Use Builder Pattern for Complex Configurations
    public static func useBuilderPattern() -> some View {
        let configuration = DependencyBuilder()
            .environment(.development)
            .cacheStrategy(.hybrid)
            .networkStrategy(.real)
            .enableLogging(true)
            .enableAnalytics(false)
            .build()
        
        let factory = ConfiguredDIFactory(configuration: configuration)
        return SectionsListView(viewModel: factory.makeSectionsViewModel())
    }
}

// MARK: - Mock Implementations for Testing
private class MockHTTPClient: HTTPClient {
    func get(_ url: URL, headers: [String: String]) async throws -> HTTPResponse {
        // Return mock data for testing
        let mockData = """
        {
            "type": "page",
            "pageType": "sections",
            "title": "Mock Sections",
            "description": "Mock data for testing",
            "_links": {
                "viaplay:sections": []
            }
        }
        """.data(using: .utf8)!
        
        return HTTPResponse(statusCode: 200, data: mockData, headers: [:])
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
