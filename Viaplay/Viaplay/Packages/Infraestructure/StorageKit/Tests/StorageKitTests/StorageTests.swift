import XCTest
@testable import StorageKit

final class StorageTests: XCTestCase {
    func testJSONDiskCacheRoundtrip() throws {
        struct Obj: Codable, Equatable { let x: Int }
        let temp = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: temp, withIntermediateDirectories: true)
        let cache = FileJSONDiskCache(directory: temp)
        let value = Obj(x: 42)
        try cache.write(value, for: "k.json")
        let restored: Obj? = try cache.read(for: "k.json", as: Obj.self)
        XCTAssertEqual(restored, value)
    }

    func testKeyValueStore() {
        let store = UserDefaultsStore()
        let k = "etag.test.\(UUID().uuidString)"
        store.set("abc", for: k)
        XCTAssertEqual(store.get(k), "abc")
    }
}
