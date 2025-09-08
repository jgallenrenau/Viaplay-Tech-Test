import XCTest
import SwiftUI
import SnapshotTesting
@testable import DSKit

@MainActor
final class SplashViewtvOSSnapshotTests: XCTestCase {
    
    func testSplashViewtvOSInitialState() {
        let view = SplashView(onAnimationEnd: {})
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .tv))
    }
    
    func testSplashViewtvOSWithCustomCallback() {
        var callbackExecuted = false
        let view = SplashView {
            callbackExecuted = true
        }
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .tv))
    }
    
    func testSplashViewtvOSInDarkMode() {
        let view = SplashView(onAnimationEnd: {})
            .preferredColorScheme(.dark)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .tv))
    }
    
    func testSplashViewtvOSAccessibility() {
        let view = SplashView(onAnimationEnd: {})
            .accessibilityLabel("Viaplay App Loading")
            .accessibilityHint("App is starting up")
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .tv))
    }
}
