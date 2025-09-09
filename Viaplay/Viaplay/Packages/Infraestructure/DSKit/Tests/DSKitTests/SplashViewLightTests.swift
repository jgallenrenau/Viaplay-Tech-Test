import XCTest
import SwiftUI
@testable import DSKit

final class SplashViewLightTests: XCTestCase {
    func testSplashViewBuilds() {
        let exp = expectation(description: "build")
        let view = DesignSystem.Components.splashView { exp.fulfill() }
        _ = view.body // force lazy body evaluation
        wait(for: [exp], timeout: 0.1)
    }
}


