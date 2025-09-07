import XCTest
import SwiftUI
import SnapshotTesting
@testable import DSKit

final class SectionRowViewSnapshotTests: XCTestCase {
    
    func testSectionRowViewWithTitleOnly() {
        let model = SectionRowView.Model(title: "Test Title")
        let view = SectionRowView(model: model)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)))
    }
    
    func testSectionRowViewWithTitleAndDescription() {
        let model = SectionRowView.Model(title: "Test Title", description: "Test Description")
        let view = SectionRowView(model: model)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)))
    }
    
    func testSectionRowViewWithEmptyDescription() {
        let model = SectionRowView.Model(title: "Test Title", description: "")
        let view = SectionRowView(model: model)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)))
    }
    
    func testSectionRowViewWithLongTitle() {
        let model = SectionRowView.Model(
            title: "This is a very long title that should test text wrapping and layout",
            description: "Short description"
        )
        let view = SectionRowView(model: model)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)))
    }
    
    func testSectionRowViewWithLongDescription() {
        let model = SectionRowView.Model(
            title: "Short Title",
            description: "This is a very long description that should test text wrapping and layout behavior in the UI component"
        )
        let view = SectionRowView(model: model)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)))
    }
    
    func testSectionRowViewInDarkMode() {
        let model = SectionRowView.Model(title: "Dark Mode Title", description: "Dark Mode Description")
        let view = SectionRowView(model: model)
            .preferredColorScheme(.dark)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)))
    }
    
    func testSectionRowViewAccessibility() {
        let model = SectionRowView.Model(title: "Accessible Title", description: "Accessible Description")
        let view = SectionRowView(model: model)
            .accessibilityLabel("Section: Accessible Title")
            .accessibilityHint("Accessible Description")
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)))
    }
}
