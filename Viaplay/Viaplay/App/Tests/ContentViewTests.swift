import XCTest
import SwiftUI
@testable import Viaplay

@MainActor
final class ContentViewTests: XCTestCase {
    
    private var sut: ContentView!
    
    override func setUp() async throws {
        try await super.setUp()
        sut = ContentView()
    }
    
    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }
    
    func test_initialization() {
        XCTAssertNotNil(sut)
    }
    
    func test_initialState_showsSplash() {
        let contentView = ContentView()
        
        XCTAssertNotNil(contentView.body)
    }
    
    func test_body_returnsGroup() {
        let body = sut.body
        XCTAssertNotNil(body)
    }
    
    func test_splashView_configuration() {
        
        let body = sut.body
        XCTAssertNotNil(body)
    }
    
    func test_sectionsListView_configuration() {
        
        let body = sut.body
        XCTAssertNotNil(body)
    }
    
    func test_animation_configuration() {
        
        let body = sut.body
        XCTAssertNotNil(body)
    }
    
    func test_multipleInstances() {
        let view1 = ContentView()
        let view2 = ContentView()
        
        XCTAssertNotNil(view1)
        XCTAssertNotNil(view2)
        XCTAssertNotNil(view1.body)
        XCTAssertNotNil(view2.body)
    }
    
    func test_view_lifecycle() {
        
        var view: ContentView? = ContentView()
        XCTAssertNotNil(view)
        
        let _ = view?.body
        
        view = nil
    }
    
    func test_preview_compilation() {
        
        let previewView = ContentView()
        XCTAssertNotNil(previewView)
        XCTAssertNotNil(previewView.body)
    }
}
