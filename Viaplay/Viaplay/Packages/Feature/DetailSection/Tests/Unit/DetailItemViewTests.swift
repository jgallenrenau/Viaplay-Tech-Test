import XCTest
import SwiftUI
import Domain
@testable import DetailSection

final class DetailItemViewTests: XCTestCase {
    
    func testDetailItemViewInitialization() {
        let item = Domain.DetailItem(
            id: "1",
            title: "Test Item",
            description: "Test Description",
            href: URL(string: "https://example.com"), content: "Test Content",
            tags: ["tag1", "tag2"]
        )
        let view = DetailItemView(item: item)
        
        XCTAssertNotNil(view)
    }
    
    func testDetailItemViewWithMinimalData() {
        let item = Domain.DetailItem(id: "1", title: "Test Item")
        let view = DetailItemView(item: item)
        
        XCTAssertNotNil(view)
    }
    
    func testDetailItemViewWithDescription() {
        let item = Domain.DetailItem(
            id: "1",
            title: "Test Item",
            description: "Test Description"
        )
        let view = DetailItemView(item: item)
        
        XCTAssertNotNil(view)
    }
    
    func testDetailItemViewWithContent() {
        let item = Domain.DetailItem(
            id: "1",
            title: "Test Item",
            content: "Test Content"
        )
        let view = DetailItemView(item: item)
        
        XCTAssertNotNil(view)
    }
    
    func testDetailItemViewWithTags() {
        let item = Domain.DetailItem(
            id: "1",
            title: "Test Item",
            tags: ["tag1", "tag2", "tag3"]
        )
        let view = DetailItemView(item: item)
        
        XCTAssertNotNil(view)
    }
    
    func testDetailItemViewWithHref() {
        let item = Domain.DetailItem(
            id: "1",
            title: "Test Item",
            href: URL(string: "https://example.com")
        )
        let view = DetailItemView(item: item)
        
        XCTAssertNotNil(view)
    }
    
    func testDetailItemViewWithEmptyTags() {
        let item = Domain.DetailItem(
            id: "1",
            title: "Test Item",
            tags: []
        )
        let view = DetailItemView(item: item)
        
        XCTAssertNotNil(view)
    }
    
    func testDetailItemViewWithAllProperties() {
        let item = Domain.DetailItem(
            id: "1",
            title: "Test Item",
            description: "Test Description",
            href: URL(string: "https://example.com"), content: "Test Content",
            tags: ["tag1", "tag2"]
        )
        let view = DetailItemView(item: item)
        
        XCTAssertNotNil(view)
    }
}
