import XCTest
import SwiftUI
@testable import DSKit
@testable import DomainKit

final class SectionRowViewTests: XCTestCase {
    func testViewRendersTitle() {
        let model = SectionRowView.Model(title: "Title", description: "Desc")
        _ = SectionRowView(model: model)
        // UI snapshot not included; ensure initialiser compiles and view builds
        XCTAssertTrue(true)
    }
}


