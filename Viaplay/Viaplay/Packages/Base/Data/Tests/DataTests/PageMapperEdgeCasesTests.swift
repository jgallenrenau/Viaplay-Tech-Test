import XCTest
@testable import Data
import Domain

final class PageMapperEdgeCasesTests: XCTestCase {
    
    
    func test_map_withEmptySections() {
        let dto = makeDTO(sections: [])
        let page = PageMapper.map(dto)
        XCTAssertEqual(page.sections.count, 0)
    }
    
    func test_map_withNilSections() {
        let dto = makeDTO(sections: nil)
        let page = PageMapper.map(dto)
        XCTAssertEqual(page.sections.count, 0)
    }
    
    func test_map_withEmptyPrimaryAndSecondary() {
        let dto = makeDTO(primary: [], secondary: [])
        let page = PageMapper.map(dto)
        XCTAssertEqual(page.sections.count, 0)
    }
    
    func test_map_withNilPrimaryAndSecondary() {
        let dto = makeDTO(primary: nil, secondary: nil)
        let page = PageMapper.map(dto)
        XCTAssertEqual(page.sections.count, 0)
    }
    
    func test_map_withMixedValidAndInvalidURLs() {
        let sections = [
            makeSectionDTO(title: "Valid", href: "https://example.com/valid"),
            makeSectionDTO(title: "Invalid", href: ""),
            makeSectionDTO(title: "Another Valid", href: "https://test.com/another"),
            makeSectionDTO(title: "Another Invalid", href: "not-a-url")
        ]
        let dto = makeDTO(sections: sections)
        let page = PageMapper.map(dto)
        
        XCTAssertGreaterThanOrEqual(page.sections.count, 2)
        XCTAssertLessThanOrEqual(page.sections.count, 4)
        
        let validTitles = page.sections.map { $0.title }
        XCTAssertTrue(validTitles.contains("Valid"))
        XCTAssertTrue(validTitles.contains("Another Valid"))
    }
    
    func test_map_withSpecialCharactersInTitle() {
        let sections = [
            makeSectionDTO(title: "Title with émojis 🎉", href: "https://example.com/emoji"),
            makeSectionDTO(title: "Title with spéciál chârs", href: "https://example.com/special"),
            makeSectionDTO(title: "Title with numbers 123", href: "https://example.com/numbers")
        ]
        let dto = makeDTO(sections: sections)
        let page = PageMapper.map(dto)
        
        XCTAssertEqual(page.sections.count, 3)
        XCTAssertEqual(page.sections[0].title, "Title with émojis 🎉")
        XCTAssertEqual(page.sections[1].title, "Title with spéciál chârs")
        XCTAssertEqual(page.sections[2].title, "Title with numbers 123")
    }
    
    func test_map_withVeryLongTitle() {
        let longTitle = String(repeating: "A", count: 1000)
        let sections = [makeSectionDTO(title: longTitle, href: "https://example.com/long")]
        let dto = makeDTO(sections: sections)
        let page = PageMapper.map(dto)
        
        XCTAssertEqual(page.sections.count, 1)
        XCTAssertEqual(page.sections[0].title, longTitle)
    }
    
    func test_map_withEmptyTitle() {
        let sections = [
            makeSectionDTO(title: "", href: "https://example.com/empty"),
            makeSectionDTO(title: "Valid Title", href: "https://example.com/valid")
        ]
        let dto = makeDTO(sections: sections)
        let page = PageMapper.map(dto)
        
        XCTAssertEqual(page.sections.count, 2)
        XCTAssertEqual(page.sections[0].title, "")
        XCTAssertEqual(page.sections[1].title, "Valid Title")
    }
    
    func test_mapToSectionsPage_withEmptyTitle() {
        let dto = makeDTO(title: "", sections: [makeSectionDTO(title: "Section", href: "https://example.com")])
        let sectionsPage = PageMapper.mapToSectionsPage(dto)
        
        XCTAssertEqual(sectionsPage.title, "")
        XCTAssertEqual(sectionsPage.sections.count, 1)
    }
    
    func test_mapToSectionsPage_withNilDescription() {
        let dto = makeDTO(title: "Test", description: nil, sections: [makeSectionDTO(title: "Section", href: "https://example.com")])
        let sectionsPage = PageMapper.mapToSectionsPage(dto)
        
        XCTAssertEqual(sectionsPage.title, "Test")
        XCTAssertNil(sectionsPage.rootDescription)
        XCTAssertEqual(sectionsPage.sections.count, 1)
    }
    
    func test_mapToSectionsPage_withEmptyDescription() {
        let dto = makeDTO(title: "Test", description: "", sections: [makeSectionDTO(title: "Section", href: "https://example.com")])
        let sectionsPage = PageMapper.mapToSectionsPage(dto)
        
        XCTAssertEqual(sectionsPage.title, "Test")
        XCTAssertEqual(sectionsPage.rootDescription, "")
        XCTAssertEqual(sectionsPage.sections.count, 1)
    }
    
    func test_map_withComplexURLs() {
        let sections = [
            makeSectionDTO(title: "Query Params", href: "https://example.com/path?param=value&other=123"),
            makeSectionDTO(title: "Fragment", href: "https://example.com/path#fragment"),
            makeSectionDTO(title: "Port", href: "https://example.com:8080/path"),
            makeSectionDTO(title: "Subdomain", href: "https://api.example.com/v1/path")
        ]
        let dto = makeDTO(sections: sections)
        let page = PageMapper.map(dto)
        
        XCTAssertEqual(page.sections.count, 4)
        XCTAssertEqual(page.sections[0].href?.absoluteString, "https://example.com/path?param=value&other=123")
        XCTAssertEqual(page.sections[1].href?.absoluteString, "https://example.com/path#fragment")
        XCTAssertEqual(page.sections[2].href?.absoluteString, "https://example.com:8080/path")
        XCTAssertEqual(page.sections[3].href?.absoluteString, "https://api.example.com/v1/path")
    }
    
    func test_map_withDuplicateTitles() {
        let sections = [
            makeSectionDTO(title: "Duplicate", href: "https://example.com/1"),
            makeSectionDTO(title: "Duplicate", href: "https://example.com/2"),
            makeSectionDTO(title: "Unique", href: "https://example.com/3")
        ]
        let dto = makeDTO(sections: sections)
        let page = PageMapper.map(dto)
        
        XCTAssertEqual(page.sections.count, 3)
        XCTAssertEqual(page.sections[0].title, "Duplicate")
        XCTAssertEqual(page.sections[1].title, "Duplicate")
        XCTAssertEqual(page.sections[2].title, "Unique")
    }
    
    func test_map_withWhitespaceInTitle() {
        let sections = [
            makeSectionDTO(title: "  Leading and trailing spaces  ", href: "https://example.com/spaces"),
            makeSectionDTO(title: "\tTab\tseparated\t", href: "https://example.com/tabs"),
            makeSectionDTO(title: "\nNewline\nseparated\n", href: "https://example.com/newlines")
        ]
        let dto = makeDTO(sections: sections)
        let page = PageMapper.map(dto)
        
        XCTAssertEqual(page.sections.count, 3)
        XCTAssertEqual(page.sections[0].title, "  Leading and trailing spaces  ")
        XCTAssertEqual(page.sections[1].title, "\tTab\tseparated\t")
        XCTAssertEqual(page.sections[2].title, "\nNewline\nseparated\n")
    }
    
    func test_mapToSectionsPage_withWhitespaceInTitle() {
        let dto = makeDTO(title: "  Whitespace Title  ", sections: [makeSectionDTO(title: "Section", href: "https://example.com")])
        let sectionsPage = PageMapper.mapToSectionsPage(dto)
        
        XCTAssertEqual(sectionsPage.title, "  Whitespace Title  ")
    }
    
    func test_map_withMalformedURLs() {
        let sections = [
            makeSectionDTO(title: "Valid", href: "https://example.com"),
            makeSectionDTO(title: "No Protocol", href: "example.com"),
            makeSectionDTO(title: "Invalid Protocol", href: "ftp://example.com"),
            makeSectionDTO(title: "Just Text", href: "not-a-url-at-all"),
            makeSectionDTO(title: "Empty", href: ""),
            makeSectionDTO(title: "Spaces", href: "   ")
        ]
        let dto = makeDTO(sections: sections)
        let page = PageMapper.map(dto)
        
        XCTAssertGreaterThanOrEqual(page.sections.count, 1)
        let validTitles = page.sections.map { $0.title }
        XCTAssertTrue(validTitles.contains("Valid"))
        
        if let validSection = page.sections.first(where: { $0.title == "Valid" }) {
            XCTAssertEqual(validSection.href?.absoluteString, "https://example.com")
        }
    }
    
    func test_map_withVeryLongURL() {
        let longURL = "https://example.com/" + String(repeating: "a", count: 1000)
        let sections = [makeSectionDTO(title: "Long URL", href: longURL)]
        let dto = makeDTO(sections: sections)
        let page = PageMapper.map(dto)
        
        XCTAssertEqual(page.sections.count, 1)
        XCTAssertEqual(page.sections[0].href?.absoluteString, longURL)
    }
    
    
    private func makeSectionDTO(title: String, href: String) -> SectionDTO {
        SectionDTO(title: title, href: href)
    }
    
    private func makeDTO(
        title: String = "Root",
        description: String? = "Desc",
        sections: [SectionDTO]? = nil,
        primary: [SectionDTO]? = nil,
        secondary: [SectionDTO]? = nil
    ) -> PageDTO {
        PageDTO(title: title, description: description, links: LinksDTO(
            viaplaySections: sections,
            viaplayPrimaryNavigation: primary,
            viaplaySecondaryNavigation: secondary
        ))
    }
}
