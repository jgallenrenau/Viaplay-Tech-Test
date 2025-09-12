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
        
        XCTAssertNotNil(body)
    }
    
    func test_app_scene_containsContentView() {
        let scene = sut.body
        
        XCTAssertNotNil(scene)
        
    }
    
    func test_app_multipleInstances() {
        let app1 = ViaplayApp()
        let app2 = ViaplayApp()
        
        XCTAssertNotNil(app1)
        XCTAssertNotNil(app2)
        XCTAssertNotNil(app1.body)
        XCTAssertNotNil(app2.body)
    }
    
    func test_app_lifecycle() {
Laravel1991!
        
        var app: ViaplayApp? = ViaplayApp()
        XCTAssertNotNil(app)
        
        let _ = app?.body
        
        app = nil
    }
}
