import XCTest
import SwiftUI
import SnapshotTesting
@testable import DSKit

final class SectionRowViewtvOSSnapshotTests: XCTestCase {
    
    func testSectionRowViewtvOSWithTitleOnly() {
        let model = SectionRowView.Model(title: "Test Title")
        let view = SectionRowView(model: model)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
    
    func testSectionRowViewtvOSWithTitleAndDescription() {
        let model = SectionRowView.Model(title: "Test Title", description: "Test Description")
        let view = SectionRowView(model: model)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
    
    func testSectionRowViewtvOSWithEmptyDescription() {
        let model = SectionRowView.Model(title: "Test Title", description: "")
        let view = SectionRowView(model: model)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
    
    func testSectionRowViewtvOSWithLongTitle() {
        let model = SectionRowView.Model(
            title: "This is a very long title that should test text wrapping and layout on Apple TV",
            description: "Short description"
        )
        let view = SectionRowView(model: model)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
    
    func testSectionRowViewtvOSWithLongDescription() {
        let model = SectionRowView.Model(
            title: "Short Title",
            description: "This is a very long description that should test text wrapping and layout behavior in the UI component on Apple TV"
        )
        let view = SectionRowView(model: model)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
    
    func testSectionRowViewtvOSFocused() {
        let model = SectionRowView.Model(title: "Focused Title", description: "Focused Description")
        let view = SectionRowView(model: model)
            .focused(true)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
    
    func testSectionRowViewtvOSAccessibility() {
        let model = SectionRowView.Model(title: "Accessible Title", description: "Accessible Description")
        let view = SectionRowView(model: model)
            .accessibilityLabel("Section: Accessible Title")
            .accessibilityHint("Accessible Description")
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
}
