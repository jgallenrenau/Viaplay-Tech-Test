import XCTest
import SwiftUI
@testable import SectionsFeature

final class SectionsListViewTests: XCTestCase {
    func testConstructsWithMockClient() {
        class MockClient: ViaplayAPIClientProtocol {
            func fetchSections(from url: URL) async throws -> [ViaplaySection] { [] }
        }
        let _ = SectionsListView(apiClient: MockClient())
        XCTAssertTrue(true)
    }
}


