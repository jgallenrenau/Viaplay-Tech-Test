import Foundation
import DomainKit
import NetworkingKit
import StorageKit

public final class PageRepositoryImpl: PageRepository {
    private let http: HTTPClient
    private let cache: JSONDiskCache
    private let etagStore: KeyValueStore

    public init(http: HTTPClient, cache: JSONDiskCache, etagStore: KeyValueStore) {
        self.http = http
        self.cache = cache
        self.etagStore = etagStore
    }

    public func getRootPage() async throws -> Page {
        try await fetch(url: ViaplayAPI.rootURL(), cacheKey: "root.json")
    }

    public func getPage(by url: URL) async throws -> Page {
        try await fetch(url: url, cacheKey: url.lastPathComponent + ".json")
    }

    private func fetch(url: URL, cacheKey: String) async throws -> Page {
        var headers: [String: String] = [:]
        if let etag = etagStore.get(cacheKey) { headers["If-None-Match"] = etag }
        let response = try await http.get(url, headers: headers)
        if response.statusCode == 304, let cached: Page = try cache.read(for: cacheKey, as: Page.self) {
            return cached
        }
        if let etag = response.headers["ETag"] { etagStore.set(etag, for: cacheKey) }
        let page = try JSONDecoder().decode(Page.self, from: response.data)
        try? cache.write(page, for: cacheKey)
        return page
    }
}


