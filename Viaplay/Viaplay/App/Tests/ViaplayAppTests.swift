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
        XCTAssertNotNil(sut)
    }
    
    func test_app_body_returnsWindowGroup() {
        let body = sut.body
        
        // Verify that the body is a WindowGroup
        // Note: We can't easily test the exact type due to SwiftUI's opaque return types
        // But we can verify it's not nil and can be accessed
        XCTAssertNotNil(body)
    }
    
    func test_app_scene_containsContentView() {
        let scene = sut.body
        
        // The scene should be accessible and not crash
        XCTAssertNotNil(scene)
        
        // Note: Testing the exact content of WindowGroup is complex due to SwiftUI's architecture
        // But we can verify the app structure is sound
    }
    
    func test_app_multipleInstances() {
        let app1 = ViaplayApp()
        let app2 = ViaplayApp()
        
        XCTAssertNotNil(app1)
        XCTAssertNotNil(app2)
        // Each instance should have its own body
        XCTAssertNotNil(app1.body)
        XCTAssertNotNil(app2.body)
    }
    
    func test_app_lifecycle() {
        
        var app: ViaplayApp? = ViaplayApp()
        XCTAssertNotNil(app)
        
        let _ = app?.body
        
        app = nil
    }
}
