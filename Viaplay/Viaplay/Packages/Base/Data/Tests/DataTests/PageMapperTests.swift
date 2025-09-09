import XCTest
@testable import Data
import Domain

final class PageMapperTests: XCTestCase {

    private func makeSectionDTO(title: String, href: String) -> SectionDTO {
        SectionDTO(title: title, href: href)
    }

    private func makeDTO(
        title: String = "Root",
        description: String = "Desc",
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

    func test_map_prefersViaplaySections() {
        let dto = makeDTO(sections: [makeSectionDTO(title: "S1", href: "https://a")])
        let page = PageMapper.map(dto)
        XCTAssertEqual(page.sections.count, 1)
        XCTAssertEqual(page.sections.first?.title, "S1")
    }

    func test_map_fallbacksToPrimaryThenSecondary() {
        let dtoPrimary = makeDTO(primary: [makeSectionDTO(title: "P1", href: "https://p")])
        XCTAssertEqual(PageMapper.map(dtoPrimary).sections.first?.title, "P1")

        let dtoSecondary = makeDTO(secondary: [makeSectionDTO(title: "S2", href: "https://s")])
        XCTAssertEqual(PageMapper.map(dtoSecondary).sections.first?.title, "S2")
    }

    func test_mapToSectionsPage_buildsDomainSectionsAndKeepsRootDescription() {
        let dto = makeDTO(sections: [makeSectionDTO(title: "Movies", href: "https://m")])
        let sectionsPage = PageMapper.mapToSectionsPage(dto)
        XCTAssertEqual(sectionsPage.title, "Root")
        XCTAssertEqual(sectionsPage.rootDescription, "Desc")
        XCTAssertEqual(sectionsPage.sections.first?.id, "movies")
        XCTAssertEqual(sectionsPage.sections.first?.title, "Movies")
    }

    func test_map_ignoresInvalidURLs() {
        let bad = makeSectionDTO(title: "Bad", href: "not a url")
        let dto = makeDTO(sections: [bad])
        let page = PageMapper.map(dto)
        XCTAssertTrue(page.sections.isEmpty)
    }
}


