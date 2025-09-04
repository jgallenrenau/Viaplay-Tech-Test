import XCTest
import SwiftUI
@testable import DetailSection
@testable import Domain

final class DetailViewTests: XCTestCase {
    func testInitWithSection() {
        let section = ContentSection(title: "Title", description: "Desc", href: URL(string: "https://example.com"))
        _ = DetailView(section: section)
        XCTAssertTrue(true)
    }
}
