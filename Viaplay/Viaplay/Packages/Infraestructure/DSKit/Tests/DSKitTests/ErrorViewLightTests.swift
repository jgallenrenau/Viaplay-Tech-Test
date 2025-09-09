import XCTest
import SwiftUI
@testable import DSKit

final class ErrorViewLightTests: XCTestCase {
    func testErrorViewBuilds() {
        let view = DesignSystem.Components.errorView(title: "Error", description: "Try again", retryAction: {})
        _ = view.body
        XCTAssertNotNil(view)
    }
}


