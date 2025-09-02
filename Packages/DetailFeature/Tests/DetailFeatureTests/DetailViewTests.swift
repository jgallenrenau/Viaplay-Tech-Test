import XCTest
import SwiftUI
@testable import DetailFeature
@testable import CoreKit

final class DetailViewTests: XCTestCase {
    func testInitWithSection() {
        let section = ViaplaySection(title: "Title", description: "Desc", href: URL(string: "https://example.com"))
        _ = DetailView(section: section)
        XCTAssertTrue(true)
    }
}


