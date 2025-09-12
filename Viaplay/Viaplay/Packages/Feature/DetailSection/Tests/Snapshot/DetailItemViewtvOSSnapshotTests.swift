import XCTest
import SwiftUI
import SnapshotTesting
import Domain
@testable import DetailSection

@MainActor
final class DetailItemViewtvOSSnapshotTests: XCTestCase {
    
    private let isRecording = false
    
    func test_detailItemViewtvOS_completeItem() {
        let item = Domain.DetailItem(
            id: "complete",
            title: "Complete Item Example",
            description: "This is a complete description that shows how the component handles longer text content and multiple lines of information.",
            href: URL(string: "https://example.com/complete"),
            content: "This is additional content that provides more detailed information about the item and can be quite lengthy to demonstrate how the component handles long text.",
            tags: ["iOS", "SwiftUI", "tvOS", "Testing", "Snapshot"]
        )
        
        let view = DetailItemViewtvOS(item: item)
        
        assertSnapshot(of: view, as: .image(layout: .fixed(width: 1920, height: 1080), traits: .init(userInterfaceStyle: .light)), record: isRecording)
    }
    
    func test_detailItemViewtvOS_minimalItem() {
        let item = Domain.DetailItem(
            id: "minimal",
            title: "Minimal Item",
            description: nil,
            href: nil,
            content: nil,
            tags: []
        )
        
        let view = DetailItemViewtvOS(item: item)
        
        assertSnapshot(of: view, as: .image(layout: .fixed(width: 1920, height: 1080), traits: .init(userInterfaceStyle: .light)), record: isRecording)
    }
    
    func test_detailItemViewtvOS_withTagsOnly() {
        let item = Domain.DetailItem(
            id: "tags-only",
            title: "Tags Only Item",
            description: nil,
            href: nil,
            content: nil,
            tags: ["Swift", "iOS", "tvOS", "SwiftUI", "Testing"]
        )
        
        let view = DetailItemViewtvOS(item: item)
        
        assertSnapshot(of: view, as: .image(layout: .fixed(width: 1920, height: 1080), traits: .init(userInterfaceStyle: .light)), record: isRecording)
    }
    
    func test_detailItemViewtvOS_withContentOnly() {
        let item = Domain.DetailItem(
            id: "content-only",
            title: "Content Only Item",
            description: nil,
            href: nil,
            content: "This is content-only item that demonstrates how the component handles items with just content and no other properties.",
            tags: []
        )
        
        let view = DetailItemViewtvOS(item: item)
        
        assertSnapshot(of: view, as: .image(layout: .fixed(width: 1920, height: 1080), traits: .init(userInterfaceStyle: .light)), record: isRecording)
    }
    
    func test_detailItemViewtvOS_withHrefOnly() {
        let item = Domain.DetailItem(
            id: "href-only",
            title: "Href Only Item",
            description: nil,
            href: URL(string: "https://example.com/href-only"),
            content: nil,
            tags: []
        )
        
        let view = DetailItemViewtvOS(item: item)
        
        assertSnapshot(of: view, as: .image(layout: .fixed(width: 1920, height: 1080), traits: .init(userInterfaceStyle: .light)), record: isRecording)
    }
    
    func test_detailItemViewtvOS_longTitle() {
        let item = Domain.DetailItem(
            id: "long-title",
            title: "This is a very long title that should demonstrate how the component handles extremely long titles that might wrap to multiple lines",
            description: "Short description",
            href: nil,
            content: nil,
            tags: ["Long", "Title"]
        )
        
        let view = DetailItemViewtvOS(item: item)
        
        assertSnapshot(of: view, as: .image(layout: .fixed(width: 1920, height: 1080), traits: .init(userInterfaceStyle: .light)), record: isRecording)
    }
    
    func test_detailItemViewtvOS_manyTags() {
        let item = Domain.DetailItem(
            id: "many-tags",
            title: "Many Tags Item",
            description: "Item with many tags to test layout",
            href: nil,
            content: nil,
            tags: ["Tag1", "Tag2", "Tag3", "Tag4", "Tag5", "Tag6", "Tag7", "Tag8", "Tag9", "Tag10"]
        )
        
        let view = DetailItemViewtvOS(item: item)
        
        assertSnapshot(of: view, as: .image(layout: .fixed(width: 1920, height: 1080), traits: .init(userInterfaceStyle: .light)), record: isRecording)
    }
    
    func test_detailItemViewtvOS_darkMode() {
        let item = Domain.DetailItem(
            id: "dark-mode",
            title: "Dark Mode Item",
            description: "This item is displayed in dark mode to test the component's appearance in dark theme.",
            href: URL(string: "https://example.com/dark"),
            content: "Dark mode content to verify proper contrast and readability.",
            tags: ["Dark", "Mode", "Theme"]
        )
        
        let view = DetailItemViewtvOS(item: item)
        
        assertSnapshot(of: view, as: .image(layout: .fixed(width: 1920, height: 1080), traits: .init(userInterfaceStyle: .dark)), record: isRecording)
    }
    
    func test_detailItemViewtvOS_lightMode() {
        let item = Domain.DetailItem(
            id: "light-mode",
            title: "Light Mode Item",
            description: "This item is displayed in light mode to test the component's appearance in light theme.",
            href: URL(string: "https://example.com/light"),
            content: "Light mode content to verify proper contrast and readability.",
            tags: ["Light", "Mode", "Theme"]
        )
        
        let view = DetailItemViewtvOS(item: item)
        
        assertSnapshot(of: view, as: .image(layout: .fixed(width: 1920, height: 1080), traits: .init(userInterfaceStyle: .light)), record: isRecording)
    }
    
    func test_detailItemViewtvOS_specialCharacters() {
        let item = Domain.DetailItem(
            id: "special-chars",
            title: "Special Characters: áéíóú ñç 🚀",
            description: "Description with émojis 🚀 and symbols @#$%",
            href: URL(string: "https://example.com/special?query=value&other=test"),
            content: "Content with <html> tags and &amp; entities",
            tags: ["tag with spaces", "tag-with-dashes", "tag_with_underscores"]
        )
        
        let view = DetailItemViewtvOS(item: item)
        
        assertSnapshot(of: view, as: .image(layout: .fixed(width: 1920, height: 1080), traits: .init(userInterfaceStyle: .light)), record: isRecording)
    }
    
    func test_detailItemViewtvOS_emptyStrings() {
        let item = Domain.DetailItem(
            id: "empty-strings",
            title: "",
            description: "",
            href: nil,
            content: "",
            tags: []
        )
        
        let view = DetailItemViewtvOS(item: item)
        
        assertSnapshot(of: view, as: .image(layout: .fixed(width: 1920, height: 1080), traits: .init(userInterfaceStyle: .light)), record: isRecording)
    }
    
    func test_detailItemViewtvOS_largeContent() {
        let largeContent = String(repeating: "This is a very long content that should demonstrate how the component handles extremely long content that might require scrolling or truncation. ", count: 20)
        let item = Domain.DetailItem(
            id: "large-content",
            title: "Large Content Item",
            description: largeContent,
            href: nil,
            content: largeContent,
            tags: ["Large", "Content"]
        )
        
        let view = DetailItemViewtvOS(item: item)
        
        assertSnapshot(of: view, as: .image(layout: .fixed(width: 1920, height: 1080), traits: .init(userInterfaceStyle: .light)), record: isRecording)
    }
}
