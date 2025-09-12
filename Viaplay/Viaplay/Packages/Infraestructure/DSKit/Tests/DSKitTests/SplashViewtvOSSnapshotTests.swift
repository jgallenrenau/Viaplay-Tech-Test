import XCTest
import SwiftUI
import SnapshotTesting
@testable import DSKit

final class SplashViewtvOSSnapshotTests: XCTestCase {
    private let isRecording = false
    
    private let config1080p = ViewImageConfig(
        safeArea: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 1920, height: 1080),
        traits: UITraitCollection(traitsFrom: [
            .init(displayScale: 1.0),
            .init(userInterfaceStyle: .light)
        ])
    )
    
    func testSplashViewtvOSInitialState() {
        let view = SplashView(onAnimationEnd: {})
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p, precision: 0.98), record: isRecording)
    }
    
    func testSplashViewtvOSWithCustomCallback() {
        let view = SplashView(onAnimationEnd: {})
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p), record: isRecording)
    }
    
    func testSplashViewtvOSInDarkMode() {
        let view = SplashView(onAnimationEnd: {})
            .preferredColorScheme(.dark)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p), record: isRecording)
    }
    
    func testSplashViewtvOSAccessibility() {
        let view = SplashView(onAnimationEnd: {})
            .accessibilityLabel("Viaplay App Loading")
            .accessibilityHint("App is starting up")
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p), record: isRecording)
    }
}
