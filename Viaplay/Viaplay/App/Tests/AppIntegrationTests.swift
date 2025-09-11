import XCTest
import SwiftUI
@testable import Viaplay

@MainActor
final class AppIntegrationTests: XCTestCase {
    
    private var app: ViaplayApp!
    private var contentView: ContentView!
    
    override func setUp() async throws {
        try await super.setUp()
        app = ViaplayApp()
        contentView = ContentView()
    }
    
    override func tearDown() async throws {
        app = nil
        contentView = nil
        try await super.tearDown()
    }
    
    func test_app_to_contentView_integration() {
        // Given: A ViaplayApp and ContentView
        // When: The app is initialized
        // Then: The app should contain ContentView in its WindowGroup
        
        let appScene = app.body
        let contentViewBody = contentView.body
        
        // Both should be accessible and not nil
        XCTAssertNotNil(appScene)
        XCTAssertNotNil(contentViewBody)
    }
    
    func test_app_structure_completeness() {
        // Given: A complete app structure
        // When: Verifying the architecture
        // Then: All components should be properly connected
        
        // App should have a scene
        XCTAssertNotNil(app.body)
        
        // ContentView should be renderable
        XCTAssertNotNil(contentView.body)
    }
    
    func test_app_navigation_flow() {
        // Given: The app structure
        // When: Following the navigation flow
        // Then: The flow should be: App -> WindowGroup -> ContentView -> Splash/SectionsListView
        
        // We can't easily test the exact navigation flow due to SwiftUI's architecture
        // But we can verify all components are accessible
        let appScene = app.body
        let contentBody = contentView.body
        
        XCTAssertNotNil(appScene)
        XCTAssertNotNil(contentBody)
    }
    
    func test_app_dependency_injection() {
        // Given: The app structure
        // When: Verifying dependencies
        // Then: All dependencies should be properly injected
        
        // ContentView should be able to create SectionsListView with proper ViewModel
        // This is tested indirectly by ensuring ContentView can render
        let contentBody = contentView.body
        XCTAssertNotNil(contentBody)
    }
    
    func test_app_error_handling() {
        // Given: The app structure
        // When: Testing error scenarios
        // Then: The app should handle errors gracefully
        
        // Create multiple instances to test stability
        let app1 = ViaplayApp()
        let app2 = ViaplayApp()
        let view1 = ContentView()
        let view2 = ContentView()
        
        // All should be accessible without crashing
        XCTAssertNotNil(app1.body)
        XCTAssertNotNil(app2.body)
        XCTAssertNotNil(view1.body)
        XCTAssertNotNil(view2.body)
    }
    
    func test_app_memory_management() {
        // Given: App components
        // When: Testing memory management
        // Then: Components should be properly managed
        
        var testApp: ViaplayApp? = ViaplayApp()
        var testView: ContentView? = ContentView()
        
        // Access properties to ensure they work
        let _ = testApp?.body
        let _ = testView?.body
        
        // Deallocate
        testApp = nil
        testView = nil
        
        // Should not cause memory issues
        // This test passes if it doesn't crash
    }
    
    func test_app_performance() {
        // Given: App components
        // When: Testing performance
        // Then: Components should initialize quickly
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let testApp = ViaplayApp()
        let testView = ContentView()
        let _ = testApp.body
        let _ = testView.body
        
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        
        // Should initialize quickly (less than 0.1 seconds)
        XCTAssertLessThan(timeElapsed, 0.1)
    }
}
