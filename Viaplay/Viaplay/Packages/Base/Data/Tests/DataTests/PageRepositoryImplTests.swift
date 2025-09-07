import XCTest
@testable import Data
@testable import Domain
@testable import NetworkingKit
@testable import StorageKit

fileprivate final class StubHTTPClient: HTTPClient {
    let status: Int
    let headers: [String: String]
    let body: Data
    let shouldThrowError: Bool

    init(status: Int, body: Data, headers: [String: String] = [:], shouldThrowError: Bool = false) {
        self.status = status
        self.headers = headers
        self.body = body
        self.shouldThrowError = shouldThrowError
    }

    func get(_ url: URL, headers: [String: String]) async throws -> HTTPResponse {
        if shouldThrowError {
            throw MockHTTPClientError.networkFailure
        }
        return HTTPResponse(statusCode: status, headers: self.headers, data: body)
    }
}

fileprivate enum MockHTTPClientError: Error {
    case networkFailure
}

fileprivate final class InMemoryKeyValueStore: KeyValueStore {
    private var storage: [String: String] = [:]

    func get(_ key: String) -> String? {
        storage[key]
    }

    func set(_ value: String, for key: String) {
        storage[key] = value
    }
}

final class PageRepositoryImplTests: XCTestCase {
    var cache: FileJSONDiskCache!
    fileprivate var keyValueStore: InMemoryKeyValueStore!
    var repository: PageRepositoryImpl!
    
    override func setUp() {
        super.setUp()
        cache = FileJSONDiskCache()
        keyValueStore = InMemoryKeyValueStore()
        
        // Clear any existing cache data
        try? cache.delete(for: "root.json")
    }
    
    override func tearDown() {
        cache = nil
        keyValueStore = nil
        repository = nil
        super.tearDown()
    }
    
    func testReturnsCachedOn304() async throws {
        let page = Page(title: "Home", sections: [ContentSection(title: "A")])
        try cache.write(page, for: "root.json")

        let client = StubHTTPClient(status: 304, body: Data())
        repository = PageRepositoryImpl(
            http: client,
            cache: cache,
            etagStore: keyValueStore
        )

        let result = try await repository.getRootPage()
        XCTAssertEqual(result.sections.first?.title, "A")
    }
    
    func testFetchesFromNetworkOn200() async throws {
        let pageData = """
        {
            "title": "Home",
            "description": "Home page",
            "_links": {
                "viaplay:sections": [
                    {
                        "title": "Sports",
                        "href": "https://example.com/sports"
                    }
                ]
            }
        }
        """.data(using: .utf8)!
        
        let client = StubHTTPClient(
            status: 200,
            body: pageData,
            headers: ["ETag": "\"abc123\""]
        )
        repository = PageRepositoryImpl(
            http: client,
            cache: cache,
            etagStore: keyValueStore
        )

        let result = try await repository.getRootPage()
        XCTAssertEqual(result.title, "Home")
        XCTAssertEqual(result.sections.first?.title, "Sports")
        XCTAssertEqual(keyValueStore.get("root.json"), "\"abc123\"")
    }
    
    func testCachesDataOnSuccessfulFetch() async throws {
        let pageData = """
        {
            "title": "Home",
            "description": "Home page",
            "_links": {
                "viaplay:sections": [
                    {
                        "title": "Movies",
                        "href": "https://example.com/movies"
                    }
                ]
            }
        }
        """.data(using: .utf8)!
        
        let client = StubHTTPClient(status: 200, body: pageData)
        repository = PageRepositoryImpl(
            http: client,
            cache: cache,
            etagStore: keyValueStore
        )

        _ = try await repository.getRootPage()
        
        // Verify data was cached
        let cachedPage: Page? = try? cache.read(for: "root.json", as: Page.self)
        XCTAssertNotNil(cachedPage)
        XCTAssertEqual(cachedPage?.title, "Home")
    }
    
    func testHandlesNetworkError() async {
        let client = StubHTTPClient(status: 500, body: Data())
        repository = PageRepositoryImpl(
            http: client,
            cache: cache,
            etagStore: keyValueStore
        )

        do {
            _ = try await repository.getRootPage()
            XCTFail("Expected error to be thrown")
        } catch {
            // Network error should be thrown
            XCTAssertNotNil(error)
        }
    }
    
    func testHandlesInvalidJSON() async {
        let invalidJSON = "invalid json".data(using: .utf8)!
        let client = StubHTTPClient(status: 200, body: invalidJSON)
        repository = PageRepositoryImpl(
            http: client,
            cache: cache,
            etagStore: keyValueStore
        )

        do {
            _ = try await repository.getRootPage()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func testUsesCachedDataWhenNetworkFails() async throws {
        let page = Page(title: "Cached Home", sections: [ContentSection(title: "Cached Section")])
        try cache.write(page, for: "root.json")
        
        // Use network error to trigger cache fallback
        let client = StubHTTPClient(status: 500, body: Data(), shouldThrowError: true)
        repository = PageRepositoryImpl(
            http: client,
            cache: cache,
            etagStore: keyValueStore
        )

        let result = try await repository.getRootPage()
        XCTAssertEqual(result.title, "Cached Home")
        XCTAssertEqual(result.sections.first?.title, "Cached Section")
    }
        
    func testHandlesEmptyResponse() async throws {
        let emptyData = """
        {
            "title": "",
            "description": null,
            "_links": {
                "viaplay:sections": []
            }
        }
        """.data(using: .utf8)!
        let client = StubHTTPClient(status: 200, body: emptyData)
        repository = PageRepositoryImpl(
            http: client,
            cache: cache,
            etagStore: keyValueStore
        )

        let result = try await repository.getRootPage()
        XCTAssertEqual(result.title, "")
        XCTAssertEqual(result.sections.count, 0)
    }
    
    func testHandlesLargeResponse() async throws {
        let largeSections = (1...100).map { i in
            ContentSection(
                title: "Section \(i)",
                description: "Description \(i)",
                href: URL(string: "https://example.com/section\(i)")
            )
        }
        let largePage = Page(title: "Large Page", sections: largeSections)
        
        // Create proper DTO structure for large response
        let sectionsDTO = largeSections.map { section in
            SectionDTO(title: section.title, href: section.href?.absoluteString ?? "")
        }
        let pageDTO = PageDTO(
            title: largePage.title,
            description: largePage.description,
            links: LinksDTO(
                viaplaySections: sectionsDTO,
                viaplayPrimaryNavigation: nil,
                viaplaySecondaryNavigation: nil
            )
        )
        let pageData = try JSONEncoder().encode(pageDTO)
        
        let client = StubHTTPClient(status: 200, body: pageData)
        repository = PageRepositoryImpl(
            http: client,
            cache: cache,
            etagStore: keyValueStore
        )

        let result = try await repository.getRootPage()
        XCTAssertEqual(result.sections.count, 100)
        XCTAssertEqual(result.sections.first?.title, "Section 1")
        XCTAssertEqual(result.sections.last?.title, "Section 100")
    }
    
    func testConcurrentRequests() async throws {
        let pageData = """
        {
            "title": "Concurrent Test",
            "description": "Concurrent test page",
            "_links": {
                "viaplay:sections": [
                    {
                        "title": "Test Section",
                        "href": "https://example.com/test"
                    }
                ]
            }
        }
        """.data(using: .utf8)!
        
        let client = StubHTTPClient(status: 200, body: pageData)
        repository = PageRepositoryImpl(
            http: client,
            cache: cache,
            etagStore: keyValueStore
        )

        async let result1 = repository.getRootPage()
        async let result2 = repository.getRootPage()
        async let result3 = repository.getRootPage()
        
        let (page1, page2, page3) = try await (result1, result2, result3)
        
        XCTAssertEqual(page1.title, "Concurrent Test")
        XCTAssertEqual(page2.title, "Concurrent Test")
        XCTAssertEqual(page3.title, "Concurrent Test")
    }
}
