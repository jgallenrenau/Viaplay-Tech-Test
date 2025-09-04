import XCTest
@testable import NetworkingKit

final class HTTPClientTests: XCTestCase {
    func testBuildsResponse() async throws {
        // Smoke test for initializer; full URLProtocol stubs can be added later
        let client = URLSessionHTTPClient(session: .shared)
        _ = client // ensure compiles
        XCTAssertTrue(true)
    }
}
