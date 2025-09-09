import XCTest
import SwiftUI
@testable import DSKit

final class SplashViewLightTests: XCTestCase {
    func testSplashViewBuilds() {
        let view = DesignSystem.Components.splashView { }
        _ = view.body
        XCTAssertNotNil(view)
    }
}


