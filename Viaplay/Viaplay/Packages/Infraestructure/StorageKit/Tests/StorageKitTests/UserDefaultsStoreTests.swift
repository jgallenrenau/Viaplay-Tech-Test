import XCTest
@testable import StorageKit

final class UserDefaultsStoreTests: XCTestCase {
    
    private var sut: UserDefaultsStore!
    private var userDefaults: UserDefaults!
    private let testSuiteName = "UserDefaultsStoreTests"
    
    override func setUp() async throws {
        try await super.setUp()
        
        // Create a test-specific UserDefaults suite
        userDefaults = UserDefaults(suiteName: testSuiteName)!
        userDefaults.removePersistentDomain(forName: testSuiteName)
        
        // Initialize SUT with test UserDefaults
        sut = UserDefaultsStore(defaults: userDefaults)
    }
    
    override func tearDown() async throws {
        // Clean up test data
        userDefaults.removePersistentDomain(forName: testSuiteName)
        
        sut = nil
        userDefaults = nil
        
        try await super.tearDown()
    }
    
    // MARK: - Get Tests
    
    func test_get_returnsNilForNonExistentKey() {
        let result = sut.get("non-existent-key")
        XCTAssertNil(result)
    }
    
    func test_get_returnsStoredValue() {
        let key = "test-key"
        let value = "test-value"
        
        sut.set(value, for: key)
        let result = sut.get(key)
        
        XCTAssertEqual(result, value)
    }
    
    func test_get_returnsNilForEmptyKey() {
        let result = sut.get("")
        XCTAssertNil(result)
    }
    
    func test_get_withSpecialCharacters() {
        let key = "key-with-special-chars-!@#$%^&*()"
        let value = "value-with-special-chars-!@#$%^&*()"
        
        sut.set(value, for: key)
        let result = sut.get(key)
        
        XCTAssertEqual(result, value)
    }
    
    func test_get_withUnicodeCharacters() {
        let key = "key-with-unicode-🚀"
        let value = "value-with-unicode-🎉"
        
        sut.set(value, for: key)
        let result = sut.get(key)
        
        XCTAssertEqual(result, value)
    }
    
    // MARK: - Set Tests
    
    func test_set_storesValue() {
        let key = "storage-key"
        let value = "storage-value"
        
        sut.set(value, for: key)
        
        XCTAssertEqual(userDefaults.string(forKey: key), value)
    }
    
    func test_set_overwritesExistingValue() {
        let key = "overwrite-key"
        let firstValue = "first-value"
        let secondValue = "second-value"
        
        sut.set(firstValue, for: key)
        XCTAssertEqual(userDefaults.string(forKey: key), firstValue)
        
        sut.set(secondValue, for: key)
        XCTAssertEqual(userDefaults.string(forKey: key), secondValue)
    }
    
    func test_set_withEmptyValue() {
        let key = "empty-value-key"
        let value = ""
        
        sut.set(value, for: key)
        let result = sut.get(key)
        
        XCTAssertEqual(result, value)
    }
    
    func test_set_withEmptyKey() {
        let key = ""
        let value = "empty-key-value"
        
        sut.set(value, for: key)
        let result = sut.get(key)
        
        XCTAssertEqual(result, value)
    }
    
    func test_set_withLongValue() {
        let key = "long-value-key"
        let value = String(repeating: "a", count: 10000)
        
        sut.set(value, for: key)
        let result = sut.get(key)
        
        XCTAssertEqual(result, value)
    }
    
    // MARK: - Integration Tests
    
    func test_setAndGet_multipleKeys() {
        let keyValuePairs = [
            ("key1", "value1"),
            ("key2", "value2"),
            ("key3", "value3")
        ]
        
        // Set all values
        for (key, value) in keyValuePairs {
            sut.set(value, for: key)
        }
        
        // Verify all values
        for (key, expectedValue) in keyValuePairs {
            let result = sut.get(key)
            XCTAssertEqual(result, expectedValue, "Failed for key: \(key)")
        }
    }
    
    func test_setAndGet_sameKeyMultipleTimes() {
        let key = "multiple-times-key"
        let values = ["value1", "value2", "value3", "value4"]
        
        for value in values {
            sut.set(value, for: key)
            let result = sut.get(key)
            XCTAssertEqual(result, value)
        }
    }
    
    // MARK: - Edge Cases Tests
    
    func test_get_afterUserDefaultsClear() {
        let key = "clear-test-key"
        let value = "clear-test-value"
        
        sut.set(value, for: key)
        XCTAssertEqual(sut.get(key), value)
        
        // Clear UserDefaults
        userDefaults.removePersistentDomain(forName: testSuiteName)
        
        // Value should be nil after clear
        XCTAssertNil(sut.get(key))
    }
    
    func test_set_withNilValue() {
        let key = "nil-value-key"
        
        // This should not crash
        sut.set("", for: key)
        sut.set("", for: key)
        
        XCTAssertEqual(sut.get(key), "")
    }
    
    func test_concurrentAccess() {
        let key = "concurrent-key"
        let value = "concurrent-value"
        
        let expectation = XCTestExpectation(description: "Concurrent access")
        expectation.expectedFulfillmentCount = 10
        
        DispatchQueue.concurrentPerform(iterations: 10) { index in
            let testValue = "\(value)-\(index)"
            self.sut.set(testValue, for: "\(key)-\(index)")
            let result = self.sut.get("\(key)-\(index)")
            XCTAssertEqual(result, testValue)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}
