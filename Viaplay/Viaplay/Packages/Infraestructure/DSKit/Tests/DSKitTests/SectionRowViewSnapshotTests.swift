#if os(iOS)
import XCTest
import SwiftUI
import SnapshotTesting
import UIKit
@testable import DSKit

final class SectionRowViewSnapshotTests: XCTestCase {
    private let isRecording = false
    
    private let config1080pPortrait = ViewImageConfig(
        safeArea: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 1080, height: 1920),
        traits: UITraitCollection(traitsFrom: [
            .init(displayScale: 1.0),
            .init(userInterfaceStyle: .light)
        ])
    )
    
    private let config1080pLandscape = ViewImageConfig(
        safeArea: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 1920, height: 1080),
        traits: UITraitCollection(traitsFrom: [
            .init(displayScale: 1.0),
            .init(userInterfaceStyle: .light)
        ])
    )
    
    func testSectionRowViewWithTitleOnly() {
        let model = SectionRowView.Model(title: "Test Title")
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080pPortrait, precision: 0.98), record: isRecording)
    }
    
    func testSectionRowViewWithTitleAndDescription() {
        let model = SectionRowView.Model(title: "Test Title", description: "Test Description")
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080pPortrait, precision: 0.98), record: isRecording)
    }
    
    func testSectionRowViewWithEmptyDescription() {
        let model = SectionRowView.Model(title: "Test Title", description: "")
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080pPortrait, precision: 0.98), record: isRecording)
    }
    
    func testSectionRowViewWithLongTitle() {
        let model = SectionRowView.Model(
            title: "This is a very long title that should test text wrapping and layout",
            description: "Short description"
        )
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080pPortrait, precision: 0.98), record: isRecording)
    }
    
    func testSectionRowViewWithLongDescription() {
        let model = SectionRowView.Model(
            title: "Short Title",
            description: "This is a very long description that should test text wrapping and layout behavior in the UI component"
        )
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080pPortrait, precision: 0.98), record: isRecording)
    }
    
    func testSectionRowViewInDarkMode() {
        let model = SectionRowView.Model(title: "Dark Mode Title", description: "Dark Mode Description")
        let view = SectionRowView(model: model)
            .preferredColorScheme(.dark)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080pPortrait, precision: 0.98), record: isRecording)
    }
    
    func testSectionRowViewAccessibility() {
        let model = SectionRowView.Model(title: "Accessible Title", description: "Accessible Description")
        let view = SectionRowView(model: model)
            .accessibilityLabel("Section: Accessible Title")
            .accessibilityHint("Accessible Description")
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080pPortrait, precision: 0.98), record: isRecording)
    }
    
    func testSectionRowViewPortrait() {
        let model = SectionRowView.Model(title: "Portrait Title", description: "Portrait Description")
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080pPortrait, precision: 0.98), record: isRecording)
    }
    
    func testSectionRowViewLandscapeWithTitleOnly() {
        let model = SectionRowView.Model(title: "Test Title")
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080pLandscape, precision: 0.98), record: isRecording)
    }
    
    func testSectionRowViewLandscapeWithTitleAndDescription() {
        let model = SectionRowView.Model(title: "Test Title", description: "Test Description")
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080pLandscape, precision: 0.98), record: isRecording)
    }
    
    func testSectionRowViewLandscapeWithLongTitle() {
        let model = SectionRowView.Model(
            title: "This is a very long title that should test text wrapping and layout in landscape",
            description: "Short description"
        )
        let view = SectionRowView(model: model)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080pLandscape, precision: 0.98), record: isRecording)
    }
    
    func testSectionRowViewLandscapeInDarkMode() {
        let model = SectionRowView.Model(title: "Dark Mode Title", description: "Dark Mode Description")
        let view = SectionRowView(model: model)
            .preferredColorScheme(.dark)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080pLandscape, precision: 0.98), record: isRecording)
    }
}
#endif
