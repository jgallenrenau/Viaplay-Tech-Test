import XCTest
import SwiftUI
import SnapshotTesting
#if canImport(UIKit)
import UIKit
#endif
@testable import DSKit

final class SectionRowViewtvOSSnapshotTests: XCTestCase {
    
    // MARK: - 1080p Fixed Resolution Configuration for tvOS
    private let config1080p = ViewImageConfig(
        safeArea: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 1920, height: 1080),
        traits: UITraitCollection(traitsFrom: [
            .init(displayScale: 1.0),
            .init(userInterfaceStyle: .light)
        ])
    )
    
    func testSectionRowViewtvOSWithTitleOnly() {
        let model = SectionRowView.Model(title: "Test Title")
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p, precision: 0.98))
    }
    
    func testSectionRowViewtvOSWithTitleAndDescription() {
        let model = SectionRowView.Model(title: "Test Title", description: "Test Description")
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p, precision: 0.98))
    }
    
    func testSectionRowViewtvOSWithEmptyDescription() {
        let model = SectionRowView.Model(title: "Test Title", description: "")
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p, precision: 0.98))
    }
    
    func testSectionRowViewtvOSWithLongTitle() {
        let model = SectionRowView.Model(
            title: "This is a very long title that should test text wrapping and layout on Apple TV",
            description: "Short description"
        )
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p, precision: 0.98))
    }
    
    func testSectionRowViewtvOSWithLongDescription() {
        let model = SectionRowView.Model(
            title: "Short Title",
            description: "This is a very long description that should test text wrapping and layout behavior in the UI component on Apple TV"
        )
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p, precision: 0.98))
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
        assertSnapshot(of: vc, as: .image(on: config1080p, precision: 0.98))
    }
    
    func testSectionRowViewtvOSAccessibility() {
        let model = SectionRowView.Model(title: "Accessible Title", description: "Accessible Description")
        let view = SectionRowView(model: model)
            .accessibilityLabel("Section: Accessible Title")
            .accessibilityHint("Accessible Description")
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p))
    }
}
