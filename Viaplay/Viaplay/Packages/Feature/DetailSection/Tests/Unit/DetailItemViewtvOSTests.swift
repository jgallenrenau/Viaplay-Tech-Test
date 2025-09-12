import XCTest
import SwiftUI
import Domain
@testable import DetailSection

@MainActor
final class DetailItemViewtvOSTests: XCTestCase {
    
    private var sut: DetailItemViewtvOS!
    private var testItem: Domain.DetailItem!
    
    override func setUp() async throws {
        try await super.setUp()
        testItem = Domain.DetailItem(
            id: "test-1",
            title: "Test Item",
            description: "Test description",
            href: URL(string: "https://example.com"),
            content: "Test content",
            tags: ["iOS", "SwiftUI"]
        )
        sut = DetailItemViewtvOS(item: testItem)
    }
    
    override func tearDown() async throws {
        sut = nil
        testItem = nil
        try await super.tearDown()
    }
    
    func test_initialization() {
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.item.id, "test-1")
        XCTAssertEqual(sut.item.title, "Test Item")
    }
    
    func test_initialization_withMinimalItem() {
        let minimalItem = Domain.DetailItem(
            id: "minimal",
            title: "Minimal Item",
            description: nil,
            href: nil,
            content: nil,
            tags: []
        )
        
        let view = DetailItemViewtvOS(item: minimalItem)
        XCTAssertNotNil(view)
        XCTAssertEqual(view.item.id, "minimal")
        XCTAssertEqual(view.item.title, "Minimal Item")
    }
    
    func test_body_returnsView() {
        let body = sut.body
        XCTAssertNotNil(body)
    }
    
    func test_item_property_access() {
        XCTAssertEqual(sut.item.id, testItem.id)
        XCTAssertEqual(sut.item.title, testItem.title)
        XCTAssertEqual(sut.item.description, testItem.description)
        XCTAssertEqual(sut.item.href, testItem.href)
        XCTAssertEqual(sut.item.content, testItem.content)
        XCTAssertEqual(sut.item.tags, testItem.tags)
    }
    
    func test_multipleInstances() {
        let item1 = Domain.DetailItem(id: "1", title: "Item 1", description: nil, href: nil, content: nil, tags: [])
        let item2 = Domain.DetailItem(id: "2", title: "Item 2", description: nil, href: nil, content: nil, tags: [])
        
        let view1 = DetailItemViewtvOS(item: item1)
        let view2 = DetailItemViewtvOS(item: item2)
        
        XCTAssertNotNil(view1)
        XCTAssertNotNil(view2)
        XCTAssertEqual(view1.item.id, "1")
        XCTAssertEqual(view2.item.id, "2")
    }
    
    func test_view_lifecycle() {
        var view: DetailItemViewtvOS? = DetailItemViewtvOS(item: testItem)
        XCTAssertNotNil(view)
        
        let _ = view?.body
        
        view = nil
    }
    
    func test_item_withAllProperties() {
        let fullItem = Domain.DetailItem(
            id: "full",
            title: "Full Item",
            description: "Full description with lots of text",
            href: URL(string: "https://full.example.com"),
            content: "Full content with lots of information",
            tags: ["tag1", "tag2", "tag3", "tag4"]
        )
        
        let view = DetailItemViewtvOS(item: fullItem)
        XCTAssertNotNil(view)
        XCTAssertEqual(view.item.id, "full")
        XCTAssertEqual(view.item.title, "Full Item")
        XCTAssertEqual(view.item.description, "Full description with lots of text")
        XCTAssertEqual(view.item.href?.absoluteString, "https://full.example.com")
        XCTAssertEqual(view.item.content, "Full content with lots of information")
        XCTAssertEqual(view.item.tags.count, 4)
    }
    
    func test_item_withEmptyStrings() {
        let emptyItem = Domain.DetailItem(
            id: "empty",
            title: "",
            description: "",
            href: nil,
            content: "",
            tags: []
        )
        
        let view = DetailItemViewtvOS(item: emptyItem)
        XCTAssertNotNil(view)
        XCTAssertEqual(view.item.id, "empty")
        XCTAssertEqual(view.item.title, "")
        XCTAssertEqual(view.item.description, "")
        XCTAssertEqual(view.item.content, "")
        XCTAssertTrue(view.item.tags.isEmpty)
    }
    
    func test_item_withLongContent() {
        let longContent = String(repeating: "This is a very long content. ", count: 100)
        let longItem = Domain.DetailItem(
            id: "long",
            title: "Long Content Item",
            description: longContent,
            href: nil,
            content: longContent,
            tags: []
        )
        
        let view = DetailItemViewtvOS(item: longItem)
        XCTAssertNotNil(view)
        XCTAssertEqual(view.item.description, longContent)
        XCTAssertEqual(view.item.content, longContent)
    }
    
    func test_item_withManyTags() {
        let manyTags = (1...20).map { "tag\($0)" }
        let manyTagsItem = Domain.DetailItem(
            id: "many-tags",
            title: "Many Tags Item",
            description: nil,
            href: nil,
            content: nil,
            tags: manyTags
        )
        
        let view = DetailItemViewtvOS(item: manyTagsItem)
        XCTAssertNotNil(view)
        XCTAssertEqual(view.item.tags.count, 20)
        XCTAssertEqual(view.item.tags.first, "tag1")
        XCTAssertEqual(view.item.tags.last, "tag20")
    }
    
    func test_item_withSpecialCharacters() {
        let specialItem = Domain.DetailItem(
            id: "special",
            title: "Special Characters: áéíóú ñç",
            description: "Description with émojis 🚀 and symbols @#$%",
            href: URL(string: "https://example.com/path?query=value&other=test"),
            content: "Content with <html> tags and &amp; entities",
            tags: ["tag with spaces", "tag-with-dashes", "tag_with_underscores"]
        )
        
        let view = DetailItemViewtvOS(item: specialItem)
        XCTAssertNotNil(view)
        XCTAssertEqual(view.item.title, "Special Characters: áéíóú ñç")
        XCTAssertEqual(view.item.description, "Description with émojis 🚀 and symbols @#$%")
        XCTAssertEqual(view.item.content, "Content with <html> tags and &amp; entities")
        XCTAssertEqual(view.item.tags.count, 3)
    }
}
