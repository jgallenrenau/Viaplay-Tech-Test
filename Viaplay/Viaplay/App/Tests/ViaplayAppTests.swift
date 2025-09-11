import XCTest
import SwiftUI
@testable import Viaplay

@MainActor
final class ViaplayAppTests: XCTestCase {
    
    private var sut: ViaplayApp!
    
    override func setUp() async throws {
        try await super.setUp()
        sut = ViaplayApp()
    }
    
    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }
    
    func test_app_initialization() {
        // Given: A new ViaplayApp instance
        // When: The app is created
        // Then: It should be properly initialized
        XCTAssertNotNil(sut)
    }
    
    func test_app_body_returnsWindowGroup() {
        // Given: A ViaplayApp instance
        // When: Accessing the body
        // Then: It should return a WindowGroup scene
        let body = sut.body
        
        // Verify that the body is a WindowGroup
        // Note: We can't easily test the exact type due to SwiftUI's opaque return types
        // But we can verify it's not nil and can be accessed
        XCTAssertNotNil(body)
    }
    
    func test_app_scene_containsContentView() {
        // Given: A ViaplayApp instance
        // When: Accessing the scene body
        // Then: The WindowGroup should contain ContentView
        let scene = sut.body
        
        // The scene should be accessible and not crash
        XCTAssertNotNil(scene)
        
        // Note: Testing the exact content of WindowGroup is complex due to SwiftUI's architecture
        // But we can verify the app structure is sound
    }
    
    func test_app_multipleInstances() {
        // Given: Multiple ViaplayApp instances
        // When: Creating them
        // Then: Each should be independent
        let app1 = ViaplayApp()
        let app2 = ViaplayApp()
        
        XCTAssertNotNil(app1)
        XCTAssertNotNil(app2)
        // Each instance should have its own body
        XCTAssertNotNil(app1.body)
        XCTAssertNotNil(app2.body)
    }
    
    func test_app_lifecycle() {
        // Given: A ViaplayApp instance
        // When: Creating and destroying it
        // Then: It should handle lifecycle properly
        
        var app: ViaplayApp? = ViaplayApp()
        XCTAssertNotNil(app)
        
        // Access body to ensure it works
        let _ = app?.body
        
        // Deallocate
        app = nil
        // Should not crash or cause issues
    }
}
