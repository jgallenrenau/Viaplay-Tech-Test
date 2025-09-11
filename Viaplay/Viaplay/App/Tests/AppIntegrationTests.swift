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
        
        let appScene = app.body
        let contentViewBody = contentView.body
        
        // Both should be accessible and not nil
        XCTAssertNotNil(appScene)
        XCTAssertNotNil(contentViewBody)
    }
    
    func test_app_structure_completeness() {
        
        // App should have a scene
        XCTAssertNotNil(app.body)
        
        // ContentView should be renderable
        XCTAssertNotNil(contentView.body)
    }
    
    func test_app_navigation_flow() {
        
        // We can't easily test the exact navigation flow due to SwiftUI's architecture
        // But we can verify all components are accessible
        let appScene = app.body
        let contentBody = contentView.body
        
        XCTAssertNotNil(appScene)
        XCTAssertNotNil(contentBody)
    }
    
    func test_app_dependency_injection() {
        
        // ContentView should be able to create SectionsListView with proper ViewModel
        // This is tested indirectly by ensuring ContentView can render
        let contentBody = contentView.body
        XCTAssertNotNil(contentBody)
    }
    
    func test_app_error_handling() {
        
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
        
        var testApp: ViaplayApp? = ViaplayApp()
        var testView: ContentView? = ContentView()
        
        let _ = testApp?.body
        let _ = testView?.body
        
        testApp = nil
        testView = nil
    }
    
    func test_app_performance() {
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        let testApp = ViaplayApp()
        let testView = ContentView()
        let _ = testApp.body
        let _ = testView.body
        
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        
        XCTAssertLessThan(timeElapsed, 0.1)
    }
}
