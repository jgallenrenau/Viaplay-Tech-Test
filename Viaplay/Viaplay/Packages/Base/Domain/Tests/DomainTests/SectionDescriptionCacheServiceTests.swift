import XCTest
@testable import Domain

@MainActor
final class SectionDescriptionCacheServiceTests: XCTestCase {
    
    private var sut: SectionDescriptionCacheService!
    private var userDefaults: UserDefaults!
    private let testSuiteName = "SectionDescriptionCacheServiceTests"
    
    override func setUp() async throws {
        try await super.setUp()
        
        // Create a test-specific UserDefaults suite
        userDefaults = UserDefaults(suiteName: testSuiteName)!
        userDefaults.removePersistentDomain(forName: testSuiteName)
        
        // Initialize SUT with test UserDefaults
        sut = SectionDescriptionCacheService()
        
        // Clear any existing cache
        sut.clearCache()
    }
    
    override func tearDown() async throws {
        // Clean up test data
        sut.clearCache()
        userDefaults.removePersistentDomain(forName: testSuiteName)
        
        sut = nil
        userDefaults = nil
        
        try await super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func test_init_hasEmptyCache() {
        XCTAssertTrue(sut.cachedSections.isEmpty)
        XCTAssertNil(sut.rootPageCache)
    }
    
    // MARK: - Root Page Caching Tests
    
    func test_cacheRootPage_savesTitleAndDescription() {
        let title = "Test Title"
        let description = "Test Description"
        
        sut.cacheRootPage(title: title, description: description)
        
        XCTAssertEqual(sut.rootPageCache?.title, title)
        XCTAssertEqual(sut.rootPageCache?.description, description)
    }
    
    func test_cacheRootPage_withNilDescription() {
        let title = "Test Title"
        
        sut.cacheRootPage(title: title, description: nil)
        
        XCTAssertEqual(sut.rootPageCache?.title, title)
        XCTAssertNil(sut.rootPageCache?.description)
    }
    
    func test_getRootPageDescription_returnsCachedData() {
        let title = "Test Title"
        let description = "Test Description"
        
        sut.cacheRootPage(title: title, description: description)
        let result = sut.getRootPageDescription()
        
        XCTAssertEqual(result?.title, title)
        XCTAssertEqual(result?.description, description)
    }
    
    func test_getRootPageDescription_returnsNilWhenNotCached() {
        let result = sut.getRootPageDescription()
        XCTAssertNil(result)
    }
    
    // MARK: - Sections Caching Tests
    
    func test_cacheSections_savesMultipleSections() {
        let sections = [
            Section(id: "1", title: "Section 1", href: URL(string: "https://example.com/1"), description: "Desc 1"),
            Section(id: "2", title: "Section 2", href: URL(string: "https://example.com/2"), description: "Desc 2"),
            Section(id: "3", title: "Section 3", href: nil, description: nil)
        ]
        
        sut.cacheSections(sections)
        
        XCTAssertEqual(sut.cachedSections.count, 3)
        XCTAssertEqual(sut.cachedSections["1"]?.title, "Section 1")
        XCTAssertEqual(sut.cachedSections["2"]?.title, "Section 2")
        XCTAssertEqual(sut.cachedSections["3"]?.title, "Section 3")
    }
    
    func test_cacheSections_handlesNilValues() {
        let sections = [
            Section(id: "1", title: "Section 1", href: nil, description: nil)
        ]
        
        sut.cacheSections(sections)
        
        let cached = sut.cachedSections["1"]
        XCTAssertEqual(cached?.title, "Section 1")
        XCTAssertNil(cached?.description)
        XCTAssertEqual(cached?.href, "")
    }
    
    func test_getSectionDescription_returnsCachedSection() {
        let sections = [
            Section(id: "test-id", title: "Test Section", href: URL(string: "https://example.com"), description: "Test Description")
        ]
        
        sut.cacheSections(sections)
        let result = sut.getSectionDescription(for: "test-id")
        
        XCTAssertEqual(result?.title, "Test Section")
        XCTAssertEqual(result?.description, "Test Description")
        XCTAssertEqual(result?.href, "https://example.com")
    }
    
    func test_getSectionDescription_returnsNilForNonExistentSection() {
        let result = sut.getSectionDescription(for: "non-existent")
        XCTAssertNil(result)
    }
    
    func test_isSectionCached_returnsTrueForCachedSection() {
        let sections = [
            Section(id: "cached-id", title: "Cached Section", href: nil, description: nil)
        ]
        
        sut.cacheSections(sections)
        
        XCTAssertTrue(sut.isSectionCached("cached-id"))
    }
    
    func test_isSectionCached_returnsFalseForNonCachedSection() {
        XCTAssertFalse(sut.isSectionCached("non-cached-id"))
    }
    
    // MARK: - Cache Management Tests
    
    func test_clearCache_removesAllData() {
        // First, add some data
        sut.cacheRootPage(title: "Test Title", description: "Test Description")
        sut.cacheSections([
            Section(id: "1", title: "Section 1", href: nil, description: nil)
        ])
        
        // Verify data exists
        XCTAssertNotNil(sut.rootPageCache)
        XCTAssertFalse(sut.cachedSections.isEmpty)
        
        // Clear cache
        sut.clearCache()
        
        // Verify data is removed
        XCTAssertNil(sut.rootPageCache)
        XCTAssertTrue(sut.cachedSections.isEmpty)
    }
    
    func test_clearCache_multipleCallsIsSafe() {
        sut.cacheRootPage(title: "Test", description: "Test")
        sut.clearCache()
        sut.clearCache() // Should not crash
        
        XCTAssertNil(sut.rootPageCache)
        XCTAssertTrue(sut.cachedSections.isEmpty)
    }
    
    // MARK: - Persistence Tests
    
    func test_cacheRootPage_persistsToUserDefaults() {
        let title = "Persistent Title"
        let description = "Persistent Description"
        
        sut.cacheRootPage(title: title, description: description)
        
        // Create a new instance to test persistence
        let newSut = SectionDescriptionCacheService()
        
        XCTAssertEqual(newSut.rootPageCache?.title, title)
        XCTAssertEqual(newSut.rootPageCache?.description, description)
    }
    
    func test_cacheSections_persistsToUserDefaults() {
        let sections = [
            Section(id: "persistent-1", title: "Persistent Section", href: URL(string: "https://example.com"), description: "Persistent Description")
        ]
        
        sut.cacheSections(sections)
        
        // Create a new instance to test persistence
        let newSut = SectionDescriptionCacheService()
        
        XCTAssertEqual(newSut.cachedSections.count, 1)
        XCTAssertEqual(newSut.cachedSections["persistent-1"]?.title, "Persistent Section")
    }
    
    // MARK: - Error Handling Tests
    
    func test_cacheSections_overwritesExistingData() {
        let firstSections = [
            Section(id: "1", title: "First Section", href: nil, description: nil)
        ]
        
        let secondSections = [
            Section(id: "2", title: "Second Section", href: nil, description: nil)
        ]
        
        sut.cacheSections(firstSections)
        XCTAssertEqual(sut.cachedSections.count, 1)
        
        sut.cacheSections(secondSections)
        XCTAssertEqual(sut.cachedSections.count, 1)
        XCTAssertEqual(sut.cachedSections["2"]?.title, "Second Section")
        XCTAssertNil(sut.cachedSections["1"])
    }
    
    func test_cacheRootPage_overwritesExistingData() {
        sut.cacheRootPage(title: "First Title", description: "First Description")
        XCTAssertEqual(sut.rootPageCache?.title, "First Title")
        
        sut.cacheRootPage(title: "Second Title", description: "Second Description")
        XCTAssertEqual(sut.rootPageCache?.title, "Second Title")
        XCTAssertEqual(sut.rootPageCache?.description, "Second Description")
    }
    
    // MARK: - Edge Cases Tests
    
    func test_cacheSections_withEmptyArray() {
        sut.cacheSections([])
        
        XCTAssertTrue(sut.cachedSections.isEmpty)
    }
    
    func test_cacheSections_withDuplicateIds() {
        let sections = [
            Section(id: "duplicate", title: "First", href: nil, description: nil),
            Section(id: "duplicate", title: "Second", href: nil, description: nil)
        ]
        
        sut.cacheSections(sections)
        
        // Should only have one entry with the last value
        XCTAssertEqual(sut.cachedSections.count, 1)
        XCTAssertEqual(sut.cachedSections["duplicate"]?.title, "Second")
    }
    
    func test_getSectionDescription_withEmptyString() {
        let result = sut.getSectionDescription(for: "")
        XCTAssertNil(result)
    }
    
    func test_isSectionCached_withEmptyString() {
        XCTAssertFalse(sut.isSectionCached(""))
    }
}
