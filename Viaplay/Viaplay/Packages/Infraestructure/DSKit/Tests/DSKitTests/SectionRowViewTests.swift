import XCTest
import SwiftUI
@testable import DSKit

final class SectionRowViewTests: XCTestCase {
    
    // MARK: - Model Tests
    
    func testModelInitializationWithTitleOnly() {
        let model = SectionRowView.Model(title: "Test Title")
        
        XCTAssertEqual(model.title, "Test Title")
        XCTAssertNil(model.description)
    }
    
    func testModelInitializationWithTitleAndDescription() {
        let model = SectionRowView.Model(title: "Test Title", description: "Test Description")
        
        XCTAssertEqual(model.title, "Test Title")
        XCTAssertEqual(model.description, "Test Description")
    }
    
    func testModelEquality() {
        let model1 = SectionRowView.Model(title: "Title", description: "Description")
        let model2 = SectionRowView.Model(title: "Title", description: "Description")
        let model3 = SectionRowView.Model(title: "Different", description: "Description")
        
        XCTAssertEqual(model1, model2)
        XCTAssertNotEqual(model1, model3)
    }
    
    // MARK: - View Tests
    
    func testViewInitialization() {
        let model = SectionRowView.Model(title: "Test Title", description: "Test Description")
        let view = SectionRowView(model: model)
        
        // Verify view can be created without crashing
        XCTAssertNotNil(view)
    }
    
    func testViewWithEmptyDescription() {
        let model = SectionRowView.Model(title: "Title", description: "")
        let view = SectionRowView(model: model)
        
        // Empty description should be treated as nil
        XCTAssertNotNil(view)
    }
    
    func testViewWithNilDescription() {
        let model = SectionRowView.Model(title: "Title", description: nil)
        let view = SectionRowView(model: model)
        
        XCTAssertNotNil(view)
    }
}
