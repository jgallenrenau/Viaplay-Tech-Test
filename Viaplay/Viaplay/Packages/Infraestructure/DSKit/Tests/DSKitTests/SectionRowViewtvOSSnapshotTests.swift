#if os(tvOS)
import XCTest
import SwiftUI
import SnapshotTesting
import TVUIKit
@testable import DSKit

final class SectionRowViewtvOSSnapshotTests: XCTestCase {
    private let isRecording = false
    
    private let config1080p = ViewImageConfig(
        safeArea: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 1920, height: 1080),
        traits: UITraitCollection(traitsFrom: [
            .init(displayScale: 1.0),
            .init(userInterfaceStyle: .light)
        ])
    )
    
    func testSectionRowViewtvOSWithSections() {
        let model = SectionRowView.Model(title: "Sections", description: "A list of sections")
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p, precision: 0.98), record: isRecording)
    }
    
    func testSectionRowViewtvOSWithLongTitles() {
        let model = SectionRowView.Model(title: String(repeating: "Long Title ", count: 10), description: String(repeating: "Long Description ", count: 10))
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p, precision: 0.98), record: isRecording)
    }
    
    func testSectionRowViewtvOSFocused() {
        let model = SectionRowView.Model(title: "Focused", description: "Focus state")
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p, precision: 0.98), record: isRecording)
    }
    
    func testSectionRowViewtvOSAccessibility() {
        let model = SectionRowView.Model(title: "Accessibility", description: "A11y")
        let view = SectionRowView(model: model)
            .accessibilityLabel("Section: Accessibility")
            .accessibilityHint("A11y")
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p, precision: 0.98), record: isRecording)
    }
    
    func testSectionRowViewtvOSWithEmptyDescription() {
        let model = SectionRowView.Model(title: "Empty", description: "")
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p, precision: 0.98), record: isRecording)
    }
    
    func testSectionRowViewtvOSWithLongDescription() {
        let model = SectionRowView.Model(title: "Title", description: String(repeating: "Long Description ", count: 10))
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p, precision: 0.98), record: isRecording)
    }
}
#endif

