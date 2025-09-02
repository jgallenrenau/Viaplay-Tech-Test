import XCTest
@testable import DataKit
@testable import DomainKit

private final class StubHTTPClient: HTTPClient {
    let status: Int
    let headers: [String: String]
    let body: Data
    init(status: Int, headers: [String: String] = [:], body: Data) {
        self.status = status; self.headers = headers; self.body = body
    }
    func get(_ url: URL, headers: [String : String]) async throws -> HTTPResponse {
        HTTPResponse(statusCode: status, headers: self.headers, data: body)
    }
}

private final class InMemoryKV: KeyValueStore { var map: [String:String] = [:]; func get(_ k: String) -> String? { map[k] }; func set(_ v: String, for k: String) { map[k]=v } }

final class PageRepositoryImplTests: XCTestCase {
    func testReturnsCachedOn304() async throws {
        let cache = FileJSONDiskCache()
        let kv = InMemoryKV()
        let page = Page(title: "Home", sections: [ContentSection(title: "A")])
        try cache.write(page, for: "root.json")
        let client = StubHTTPClient(status: 304, body: Data())
        let repo = PageRepositoryImpl(http: client, cache: cache, etagStore: kv)
        let result = try await repo.getRootPage()
        XCTAssertEqual(result.sections.first?.title, "A")
    }
}
