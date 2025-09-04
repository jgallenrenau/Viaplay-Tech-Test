import XCTest
@testable import Data
@testable import Domain
@testable import NetworkingKit
@testable import StorageKit

private final class StubHTTPClient: HTTPClient {
    let status: Int
    let headers: [String: String]
    let body: Data

    init(status: Int, body: Data, headers: [String: String] = [:]) {
        self.status = status
        self.headers = headers
        self.body = body
    }

    func get(_ url: URL, headers: [String: String]) async throws -> HTTPResponse {
        HTTPResponse(statusCode: status, headers: self.headers, data: body)
    }
}

private final class InMemoryKeyValueStore: KeyValueStore {
    private var storage: [String: String] = [:]

    func get(_ key: String) -> String? {
        storage[key]
    }

    func set(_ value: String, for key: String) {
        storage[key] = value
    }
}

final class PageRepositoryImplTests: XCTestCase {
    func testReturnsCachedOn304() async throws {
        let cache = FileJSONDiskCache()
        let keyValueStore = InMemoryKeyValueStore()
        let page = Page(title: "Home", sections: [ContentSection(title: "A")])
        try cache.write(page, for: "root.json")

        let client = StubHTTPClient(status: 304, body: Data())
        let repository = PageRepositoryImpl(
            http: client,
            cache: cache,
            etagStore: keyValueStore
        )

        let result = try await repository.getRootPage()
        XCTAssertEqual(result.sections.first?.title, "A")
    }
}
