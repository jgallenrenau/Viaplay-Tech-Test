import XCTest
import SwiftUI
import SnapshotTesting
@testable import DSKit

final class SplashViewtvOSSnapshotTests: XCTestCase {
    
    func testSplashViewtvOSInitialState() {
        let view = SplashView(onAnimationEnd: {})
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
    
    func testSplashViewtvOSWithCustomCallback() {
        var callbackExecuted = false
        let view = SplashView {
            callbackExecuted = true
        }
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
    
    func testSplashViewtvOSInDarkMode() {
        let view = SplashView(onAnimationEnd: {})
            .preferredColorScheme(.dark)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
    
    func testSplashViewtvOSAccessibility() {
        let view = SplashView(onAnimationEnd: {})
            .accessibilityLabel("Viaplay App Loading")
            .accessibilityHint("App is starting up")
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
}
