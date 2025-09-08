import XCTest
import SwiftUI
import SnapshotTesting
import UIKit
@testable import DSKit

@MainActor
final class SplashViewtvOSSnapshotTests: XCTestCase {
    
    // MARK: - 1080p Fixed Resolution Configuration for tvOS
    private let config1080p = ViewImageConfig(
        size: CGSize(width: 1920, height: 1080),
        safeArea: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
        traits: UITraitCollection(traitsFrom: [
            .init(displayScale: 1.0),
            .init(userInterfaceStyle: .light)
        ])
    )
    
    func testSplashViewtvOSInitialState() {
        let view = SplashView(onAnimationEnd: {})
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p))
    }
    
    func testSplashViewtvOSWithCustomCallback() {
        var callbackExecuted = false
        let view = SplashView {
            callbackExecuted = true
        }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p))
    }
    
    func testSplashViewtvOSInDarkMode() {
        let view = SplashView(onAnimationEnd: {})
            .preferredColorScheme(.dark)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p))
    }
    
    func testSplashViewtvOSAccessibility() {
        let view = SplashView(onAnimationEnd: {})
            .accessibilityLabel("Viaplay App Loading")
            .accessibilityHint("App is starting up")
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p))
    }
}
