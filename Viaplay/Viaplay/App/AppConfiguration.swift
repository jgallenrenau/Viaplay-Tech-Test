import Foundation
import SwiftUI

/// Application configuration for different environments
public final class AppConfiguration: ObservableObject {
    public static let shared = AppConfiguration()
    
    @Published public var environment: DependencyBuilder.Environment = .production
    @Published public var enableLogging: Bool = true
    @Published public var enableAnalytics: Bool = false
    
    private init() {
        configureForCurrentEnvironment()
    }
    
    private func configureForCurrentEnvironment() {
        #if DEBUG
        environment = .development
        enableLogging = true
        #else
        environment = .production
        enableLogging = false
        #endif
        
        #if TESTING
        environment = .testing
        #endif
    }
    
    public func configureForTesting() {
        environment = .testing
        enableLogging = false
        enableAnalytics = false
    }
}

// MARK: - Environment-based Factory
public final class EnvironmentDIFactory {
    private let configuration: AppConfiguration
    
    public init(configuration: AppConfiguration = .shared) {
        self.configuration = configuration
    }
    
    public func makeDIContainer() -> DIContainer {
        let builder = DependencyBuilder()
            .environment(configuration.environment)
            .enableLogging(configuration.enableLogging)
            .enableAnalytics(configuration.enableAnalytics)
        
        let config = builder.build()
        let factory = ConfiguredDIFactory(configuration: config)
        
        // Create a custom DIContainer with the configured factory
        return CustomDIContainer(factory: factory)
    }
}

// MARK: - Custom DIContainer with Configuration
private final class CustomDIContainer: DIContainer {
    private let configuredFactory: ConfiguredDIFactory
    
    init(factory: ConfiguredDIFactory) {
        self.configuredFactory = factory
        super.init()
    }
    
    override func makeSectionsViewModel() -> SectionsViewModel {
        configuredFactory.makeSectionsViewModel()
    }
    
    override func makeDetailViewModel(for section: ContentSection) -> DetailViewModel {
        configuredFactory.makeDetailViewModel(for: section)
    }
}

// MARK: - Testing Support
public extension AppConfiguration {
    static func createForTesting() -> AppConfiguration {
        let config = AppConfiguration()
        config.configureForTesting()
        return config
    }
}

// MARK: - Environment Detection
public extension AppConfiguration {
    var isProduction: Bool {
        environment == .production
    }
    
    var isDevelopment: Bool {
        environment == .development
    }
    
    var isTesting: Bool {
        environment == .testing
    }
}
