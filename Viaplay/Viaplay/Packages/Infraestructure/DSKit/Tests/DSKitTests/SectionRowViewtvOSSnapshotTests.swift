import XCTest
import SwiftUI
import SnapshotTesting
@testable import DSKit

final class SectionRowViewtvOSSnapshotTests: XCTestCase {
    
    func testSectionRowViewtvOSWithTitleOnly() {
        let model = SectionRowView.Model(title: "Test Title")
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .tv))
    }
    
    func testSectionRowViewtvOSWithTitleAndDescription() {
        let model = SectionRowView.Model(title: "Test Title", description: "Test Description")
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .tv))
    }
    
    func testSectionRowViewtvOSWithEmptyDescription() {
        let model = SectionRowView.Model(title: "Test Title", description: "")
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .tv))
    }
    
    func testSectionRowViewtvOSWithLongTitle() {
        let model = SectionRowView.Model(
            title: "This is a very long title that should test text wrapping and layout on Apple TV",
            description: "Short description"
        )
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .tv))
    }
    
    func testSectionRowViewtvOSWithLongDescription() {
        let model = SectionRowView.Model(
            title: "Short Title",
            description: "This is a very long description that should test text wrapping and layout behavior in the UI component on Apple TV"
        )
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .tv))
    }
    
    func testSectionRowViewtvOSFocused() {
        let model = SectionRowView.Model(title: "Focused Title", description: "Focused Description")
        #if os(tvOS)
        let base = SectionRowView(model: model)
        let view: AnyView
        if #available(tvOS 17.0, *) {
            view = AnyView(base.focusable(true))
        } else {
            view = AnyView(base)
        }
        #else
        let view: AnyView = AnyView(SectionRowView(model: model))
        #endif
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .tv))
    }
    
    func testSectionRowViewtvOSAccessibility() {
        let model = SectionRowView.Model(title: "Accessible Title", description: "Accessible Description")
        let view = SectionRowView(model: model)
            .accessibilityLabel("Section: Accessible Title")
            .accessibilityHint("Accessible Description")
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .tv))
    }
}
