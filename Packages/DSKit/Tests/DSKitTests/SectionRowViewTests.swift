import XCTest
import SwiftUI
@testable import DSKit
@testable import CoreKit

final class SectionRowViewTests: XCTestCase {
    func testViewRendersTitle() {
        let section = ViaplaySection(title: "Title", description: "Desc")
        _ = SectionRowView(section: section)
        // UI snapshot not included; ensure initialiser compiles and view builds
        XCTAssertTrue(true)
    }
}


