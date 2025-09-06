import Foundation
import Domain
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
        print("🌐 [PageRepository] Fetching root page from: \(ViaplayAPI.rootURL())")
        let result = try await fetch(url: ViaplayAPI.rootURL(), cacheKey: "root.json")
        print("✅ [PageRepository] Root page fetched successfully with \(result.sections.count) sections")
        return result
    }

    public func getPage(by url: URL) async throws -> Page {
        print("🌐 [PageRepository] Fetching page from: \(url)")
        let result = try await fetch(url: url, cacheKey: url.lastPathComponent + ".json")
        print("✅ [PageRepository] Page fetched successfully with \(result.sections.count) sections")
        return result
    }

    private func fetch(url: URL, cacheKey: String) async throws -> Page {
        var headers: [String: String] = [:]
        if let etag = etagStore.get(cacheKey) { 
            headers["If-None-Match"] = etag
            print("📋 [PageRepository] Using ETag for cache validation: \(etag)")
        }
        
        print("🚀 [PageRepository] Making HTTP request to: \(url)")
        let response = try await http.get(url, headers: headers)
        print("📡 [PageRepository] HTTP response received - Status: \(response.statusCode)")
        
        if response.statusCode == 304, let cached: Page = try cache.read(for: cacheKey, as: Page.self) {
            print("💾 [PageRepository] Using cached data (304 Not Modified)")
            return cached
        }
        
        if let etag = response.headers["ETag"] { 
            etagStore.set(etag, for: cacheKey)
            print("🏷️ [PageRepository] Storing ETag for future requests: \(etag)")
        }
        
        print("🔄 [PageRepository] Decoding JSON response...")
        print("📄 [PageRepository] Raw JSON data: \(String(data: response.data, encoding: .utf8) ?? "Unable to convert to string")")
        
        // Decode DTO first, then map to domain model
        let pageDTO = try JSONDecoder().decode(PageDTO.self, from: response.data)
        let page = PageMapper.map(pageDTO)
        
        do {
            try cache.write(page, for: cacheKey)
            print("💾 [PageRepository] Data cached successfully for key: \(cacheKey)")
        } catch {
            print("⚠️ [PageRepository] Failed to cache data: \(error.localizedDescription)")
        }
        
        return page
    }
}
