#if os(iOS)
import XCTest
import SwiftUI
import SnapshotTesting
import UIKit
@testable import DSKit

final class SectionRowViewSnapshotTests: XCTestCase {
    
    func testSectionRowViewWithTitleOnly() {
        let model = SectionRowView.Model(title: "Test Title")
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .iPhoneX(.portrait)))
    }
    
    func testSectionRowViewWithTitleAndDescription() {
        let model = SectionRowView.Model(title: "Test Title", description: "Test Description")
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .iPhoneX(.portrait)))
    }
    
    func testSectionRowViewWithEmptyDescription() {
        let model = SectionRowView.Model(title: "Test Title", description: "")
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .iPhoneX(.portrait)))
    }
    
    func testSectionRowViewWithLongTitle() {
        let model = SectionRowView.Model(
            title: "This is a very long title that should test text wrapping and layout",
            description: "Short description"
        )
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .iPhoneX(.portrait)))
    }
    
    func testSectionRowViewWithLongDescription() {
        let model = SectionRowView.Model(
            title: "Short Title",
            description: "This is a very long description that should test text wrapping and layout behavior in the UI component"
        )
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .iPhoneX(.portrait)))
    }
    
    func testSectionRowViewInDarkMode() {
        let model = SectionRowView.Model(title: "Dark Mode Title", description: "Dark Mode Description")
        let view = SectionRowView(model: model)
            .preferredColorScheme(.dark)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .iPhoneX(.portrait)))
    }
    
    func testSectionRowViewAccessibility() {
        let model = SectionRowView.Model(title: "Accessible Title", description: "Accessible Description")
        let view = SectionRowView(model: model)
            .accessibilityLabel("Section: Accessible Title")
            .accessibilityHint("Accessible Description")
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .iPhoneX(.portrait)))
    }
    
    func testSectionRowViewPortrait() {
        let model = SectionRowView.Model(title: "Portrait Title", description: "Portrait Description")
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .iPhoneX(.portrait)))
    }
}
#endif
