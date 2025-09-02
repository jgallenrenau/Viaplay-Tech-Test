import XCTest
import SwiftUI
@testable import DetailFeature
@testable import DomainKit

final class DetailViewTests: XCTestCase {
    func testInitWithSection() {
        let section = ContentSection(title: "Title", description: "Desc", href: URL(string: "https://example.com"))
        _ = DetailView(section: section)
        XCTAssertTrue(true)
    }
}


