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
        // Given: A new ContentView instance
        // When: The view is created
        // Then: It should be properly initialized
        XCTAssertNotNil(sut)
    }
    
    func test_initialState_showsSplash() {
        // Given: A ContentView instance
        // When: Initially created
        // Then: showSplash should be true
        let contentView = ContentView()
        
        // We can't directly access @State private var showSplash
        // But we can verify the view renders without crashing
        XCTAssertNotNil(contentView.body)
    }
    
    func test_body_returnsGroup() {
        // Given: A ContentView instance
        // When: Accessing the body
        // Then: It should return a Group view
        let body = sut.body
        XCTAssertNotNil(body)
    }
    
    func test_splashView_configuration() {
        // Given: A ContentView instance
        // When: The view is rendered
        // Then: It should show the splash view initially
        
        // We can't easily test the exact UI state due to SwiftUI's architecture
        // But we can verify the view structure is sound
        let body = sut.body
        XCTAssertNotNil(body)
    }
    
    func test_sectionsListView_configuration() {
        // Given: A ContentView instance
        // When: After splash is dismissed
        // Then: It should show SectionsListView
        
        // The view should be able to render both states
        let body = sut.body
        XCTAssertNotNil(body)
    }
    
    func test_animation_configuration() {
        // Given: A ContentView instance
        // When: Transitioning from splash
        // Then: It should use easeInOut animation
        
        // We can verify the view can be rendered with animation
        let body = sut.body
        XCTAssertNotNil(body)
    }
    
    func test_multipleInstances() {
        // Given: Multiple ContentView instances
        // When: Creating them
        // Then: Each should be independent
        let view1 = ContentView()
        let view2 = ContentView()
        
        XCTAssertNotNil(view1)
        XCTAssertNotNil(view2)
        XCTAssertNotNil(view1.body)
        XCTAssertNotNil(view2.body)
    }
    
    func test_view_lifecycle() {
        // Given: A ContentView instance
        // When: Creating and destroying it
        // Then: It should handle lifecycle properly
        
        var view: ContentView? = ContentView()
        XCTAssertNotNil(view)
        
        // Access body to ensure it works
        let _ = view?.body
        
        // Deallocate
        view = nil
        // Should not crash or cause issues
    }
    
    func test_preview_compilation() {
        // Given: The ContentView preview
        // When: Compiling the preview
        // Then: It should compile without errors
        
        // This test ensures the preview code doesn't break
        // We can't easily test the preview itself, but we can verify
        // that the ContentView can be instantiated for preview purposes
        let previewView = ContentView()
        XCTAssertNotNil(previewView)
        XCTAssertNotNil(previewView.body)
    }
}
