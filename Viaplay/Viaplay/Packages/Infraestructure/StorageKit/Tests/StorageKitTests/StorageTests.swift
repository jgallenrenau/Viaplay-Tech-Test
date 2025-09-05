import XCTest
@testable import StorageKit

final class StorageTests: XCTestCase {
    func testJSONDiskCacheRoundtrip() throws {
        struct CacheObject: Codable, Equatable { let value: Int }
        let temp = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: temp, withIntermediateDirectories: true)
        let cache = FileJSONDiskCache(directory: temp)
        let value = CacheObject(value: 42)
        try cache.write(value, for: "etag.json")
        let restored: CacheObject? = try cache.read(for: "etag.json", as: CacheObject.self)
        XCTAssertEqual(restored, value)
    }

    func testKeyValueStore() {
        let store = UserDefaultsStore()
        let etagKey = "etag.test.\(UUID().uuidString)"
        store.set("abc", for: etagKey)
        XCTAssertEqual(store.get(etagKey), "abc")
    }
}
