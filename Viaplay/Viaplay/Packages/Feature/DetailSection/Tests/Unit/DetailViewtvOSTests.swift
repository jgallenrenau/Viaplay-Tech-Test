import XCTest
import SwiftUI
import Domain
@testable import DetailSection

@MainActor
final class DetailViewtvOSTests: XCTestCase {
    
    private var testSection: ContentSection!
    private var sut: DetailViewtvOS!
    
    override func setUp() async throws {
        try await super.setUp()
        testSection = ContentSection(
            title: "Test Section",
            description: "Test Description",
            href: URL(string: "https://example.com")!
        )
        sut = DetailViewtvOS(section: testSection)
    }
    
    override func tearDown() async throws {
        sut = nil
        testSection = nil
        try await super.tearDown()
    }
    
    func test_initialization_withSection() {
        XCTAssertNotNil(sut)
    }
    
    func test_initialization_withDomainSection() {
        let domainSection = Domain.Section(
            id: "domain-test",
            title: "Domain Section",
            href: URL(string: "https://domain.example.com")!,
            description: "Domain Description"
        )
        
        let view = DetailViewtvOS(domainSection: domainSection)
        XCTAssertNotNil(view)
    }
    
    func test_body_returnsView() {
        let body = sut.body
        XCTAssertNotNil(body)
    }
    
    func test_initialization_withCustomViewModel() {
        let viewModel = DetailFactory.makeDetailViewModel(for: testSection)
        let view = DetailViewtvOS(section: testSection, viewModel: viewModel)
        
        XCTAssertNotNil(view)
    }
    
    func test_initialization_withDomainSectionAndCustomViewModel() {
        let domainSection = Domain.Section(
            id: "test",
            title: "Test Section",
            href: URL(string: "https://example.com")!,
            description: "Test Description"
        )
        let viewModel = DetailFactory.makeDetailViewModel(for: testSection)
        
        let view = DetailViewtvOS(domainSection: domainSection, viewModel: viewModel)
        XCTAssertNotNil(view)
    }
    
    func test_view_lifecycle() {
        var view: DetailViewtvOS? = DetailViewtvOS(section: testSection)
        XCTAssertNotNil(view)
        
        let _ = view?.body
        
        view = nil
    }
    
    func test_view_withDifferentSections() {
        let section1 = ContentSection(title: "Section 1", description: "Desc 1", href: nil)
        let section2 = ContentSection(title: "Section 2", description: "Desc 2", href: nil)
        
        let view1 = DetailViewtvOS(section: section1)
        let view2 = DetailViewtvOS(section: section2)
        
        XCTAssertNotNil(view1)
        XCTAssertNotNil(view2)
    }
    
    func test_view_withNilHref() {
        let sectionWithoutHref = ContentSection(
            title: "No Href Section",
            description: "Description without href",
            href: nil
        )
        
        let view = DetailViewtvOS(section: sectionWithoutHref)
        XCTAssertNotNil(view)
        XCTAssertNotNil(view.body)
    }
    
    func test_view_withEmptyStrings() {
        let emptySection = ContentSection(
            title: "",
            description: "",
            href: nil
        )
        
        let view = DetailViewtvOS(section: emptySection)
        XCTAssertNotNil(view)
        XCTAssertNotNil(view.body)
    }
    
    func test_view_withSpecialCharacters() {
        let specialSection = ContentSection(
            title: "Special: áéíóú ñç 🚀",
            description: "Description with émojis 🚀 and symbols @#$%",
            href: URL(string: "https://example.com/path?query=value&other=test")
        )
        
        let view = DetailViewtvOS(section: specialSection)
        XCTAssertNotNil(view)
        XCTAssertNotNil(view.body)
    }
    
    func test_view_multipleInstances() {
        let sections = [
            ContentSection(title: "Section 1", description: "Desc 1", href: nil),
            ContentSection(title: "Section 2", description: "Desc 2", href: nil),
            ContentSection(title: "Section 3", description: "Desc 3", href: nil)
        ]
        
        let views = sections.map { DetailViewtvOS(section: $0) }
        
        for view in views {
            XCTAssertNotNil(view)
            XCTAssertNotNil(view.body)
        }
        
    }
    
    func test_view_withDomainSections() {
        let domainSections = [
            Domain.Section(id: "1", title: "Domain Section 1", href: URL(string: "https://example.com")!, description: "Desc 1"),
            Domain.Section(id: "2", title: "Domain Section 2", href: URL(string: "https://example.com")!, description: "Desc 2"),
            Domain.Section(id: "3", title: "Domain Section 3", href: URL(string: "https://example.com")!, description: "Desc 3")
        ]
        
        let views = domainSections.map { DetailViewtvOS(domainSection: $0) }
        
        for view in views {
            XCTAssertNotNil(view)
            XCTAssertNotNil(view.body)
        }
        
    }
}

