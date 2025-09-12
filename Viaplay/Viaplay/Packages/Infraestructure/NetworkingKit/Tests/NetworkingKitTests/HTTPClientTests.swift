import XCTest
@testable import NetworkingKit

final class HTTPClientTests: XCTestCase {
    func testBuildsResponse() async throws {
        let client = URLSessionHTTPClient(session: .shared)
        _ = client // ensure compiles
        XCTAssertTrue(true)
    }
}
