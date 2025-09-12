import XCTest
@testable import StorageKit

final class FileJSONDiskCacheErrorTests: XCTestCase {
    
    private var sut: FileJSONDiskCache!
    private var tempDirectory: URL!
    
    override func setUp() async throws {
        try await super.setUp()
        
        tempDirectory = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        
        try FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true)
        
        sut = FileJSONDiskCache(directory: tempDirectory)
    }
    
    override func tearDown() async throws {
        try? FileManager.default.removeItem(at: tempDirectory)
        
        sut = nil
        tempDirectory = nil
        
        try await super.tearDown()
    }
    
    
    func test_read_throwsErrorForInvalidJSON() throws {
        let key = "invalid-json-key"
        let invalidJSON = "{ invalid json }"
        let fileURL = tempDirectory.appendingPathComponent(key)
        
        try invalidJSON.data(using: .utf8)!.write(to: fileURL)
        
        XCTAssertThrowsError(try sut.read(for: key, as: TestCodable.self)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func test_read_returnsNilForNonExistentFile() throws {
        let result = try sut.read(for: "non-existent-key", as: TestCodable.self)
        XCTAssertNil(result)
    }
    
    func test_write_throwsErrorForInvalidDirectory() throws {
        let invalidDirectory = tempDirectory.appendingPathComponent("non-existent-subdirectory")
        let invalidCache = FileJSONDiskCache(directory: invalidDirectory)
        
        let testData = TestCodable(name: "test", value: 123)
        
        XCTAssertThrowsError(try invalidCache.write(testData, for: "test-key")) { error in
            XCTAssertNotNil(error)
        }
    }
    
    func test_delete_handlesNonExistentFile() throws {
        XCTAssertNoThrow(try sut.delete(for: "non-existent-key"))
    }
    
    func test_write_handlesEncodingError() throws {
        let failingEncoder = FailingJSONEncoder()
        let failingCache = FileJSONDiskCache(directory: tempDirectory, encoder: failingEncoder)
        
        let testData = TestCodable(name: "test", value: 123)
        
        XCTAssertThrowsError(try failingCache.write(testData, for: "test-key")) { error in
            XCTAssertTrue(error is EncodingError)
        }
    }
    
    func test_read_handlesDecodingError() throws {
        let failingDecoder = FailingJSONDecoder()
        let failingCache = FileJSONDiskCache(directory: tempDirectory, decoder: failingDecoder)
        
        let testData = TestCodable(name: "test", value: 123)
        try sut.write(testData, for: "test-key")
        
        XCTAssertThrowsError(try failingCache.read(for: "test-key", as: TestCodable.self)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    
    func test_write_handlesFileSystemErrors() throws {
        let invalidDirectory = tempDirectory.appendingPathComponent("will-be-removed")
        try FileManager.default.createDirectory(at: invalidDirectory, withIntermediateDirectories: true)
        
        let cache = FileJSONDiskCache(directory: invalidDirectory)
        
        try FileManager.default.removeItem(at: invalidDirectory)
        
        let testData = TestCodable(name: "test", value: 123)
        
        XCTAssertThrowsError(try cache.write(testData, for: "test-key"))
    }
    
    func test_delete_handlesFileSystemErrors() throws {
        let key = "external-deletion-key"
        let testData = TestCodable(name: "test", value: 123)
        
        try sut.write(testData, for: key)
        
        let fileURL = tempDirectory.appendingPathComponent(key)
        try FileManager.default.removeItem(at: fileURL)
        
        XCTAssertNoThrow(try sut.delete(for: key))
    }
    
    
    func test_concurrentReadWrite() throws {
        let key = "concurrent-key"
        let _ = TestCodable(name: "concurrent", value: 999)
        
        let expectation = XCTestExpectation(description: "Concurrent operations")
        expectation.expectedFulfillmentCount = 10
        
        DispatchQueue.concurrentPerform(iterations: 5) { index in
            do {
                let data = TestCodable(name: "concurrent-\(index)", value: index)
                try self.sut.write(data, for: "\(key)-\(index)")
                let result = try self.sut.read(for: "\(key)-\(index)", as: TestCodable.self)
                XCTAssertEqual(result?.name, "concurrent-\(index)")
                XCTAssertEqual(result?.value, index)
                expectation.fulfill()
            } catch {
                XCTFail("Concurrent operation failed: \(error)")
            }
        }
        
        DispatchQueue.concurrentPerform(iterations: 5) { index in
            do {
                try self.sut.delete(for: "\(key)-\(index)")
                expectation.fulfill()
            } catch {
                XCTFail("Concurrent delete failed: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    
    func test_read_withEmptyFile() throws {
        let key = "empty-file-key"
        let fileURL = tempDirectory.appendingPathComponent(key)
        
        try Data().write(to: fileURL)
        
        XCTAssertThrowsError(try sut.read(for: key, as: TestCodable.self)) { error in
            XCTAssertTrue(error is DecodingError)
        }
    }
    
    func test_write_withSpecialCharactersInKey() throws {
        let key = "key-with-special-chars-!@#$%^&*()"
        let testData = TestCodable(name: "special", value: 456)
        
        XCTAssertNoThrow(try sut.write(testData, for: key))
        
        let result = try sut.read(for: key, as: TestCodable.self)
        XCTAssertEqual(result?.name, "special")
        XCTAssertEqual(result?.value, 456)
    }
    
    func test_write_withVeryLongKey() throws {
        let key = String(repeating: "a", count: 1000)
        let testData = TestCodable(name: "long-key", value: 789)
        
        do {
            try sut.write(testData, for: key)
            
            let result = try sut.read(for: key, as: TestCodable.self)
            XCTAssertEqual(result?.name, "long-key")
            XCTAssertEqual(result?.value, 789)
        } catch {
            XCTAssertNotNil(error)
        }
    }
}


private struct TestCodable: Codable, Equatable {
    let name: String
    let value: Int
}

private class FailingJSONEncoder: JSONEncoder {
    override func encode<T>(_ value: T) throws -> Data where T : Encodable {
        throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: [], debugDescription: "Failing encoder"))
    }
}

private class FailingJSONDecoder: JSONDecoder {
    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Failing decoder"))
    }
}
