import XCTest
import Data
import Domain
import NetworkingKit
import StorageKit
@testable import DetailSection

@MainActor
final class DetailFactoryTests: XCTestCase {
    
    private var testSection: ContentSection!
    
    override func setUp() async throws {
        try await super.setUp()
        testSection = ContentSection(
            title: "Test Section",
            description: "Test Description",
            href: URL(string: "https://example.com")!
        )
    }
    
    override func tearDown() async throws {
        testSection = nil
        try await super.tearDown()
    }
    
    func test_makeDetailViewModel_createsViewModelWithCorrectSection() {
        let viewModel = DetailFactory.makeDetailViewModel(for: testSection)
        
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.section.title, "Test Section")
        XCTAssertEqual(viewModel.section.description, "Test Description")
        XCTAssertEqual(viewModel.section.href?.absoluteString, "https://example.com")
    }
    
    func test_makeDetailViewModel_createsIndependentInstances() {
        let section1 = ContentSection(title: "Section 1", description: "Desc 1", href: nil)
        let section2 = ContentSection(title: "Section 2", description: "Desc 2", href: nil)
        
        let viewModel1 = DetailFactory.makeDetailViewModel(for: section1)
        let viewModel2 = DetailFactory.makeDetailViewModel(for: section2)
        
        XCTAssertNotNil(viewModel1)
        XCTAssertNotNil(viewModel2)
        
        XCTAssertEqual(viewModel1.section.title, "Section 1")
        XCTAssertEqual(viewModel2.section.title, "Section 2")
        
        XCTAssertNotIdentical(viewModel1, viewModel2)
    }
    
    func test_makeDetailViewModel_hasCorrectInitialState() {
        let viewModel = DetailFactory.makeDetailViewModel(for: testSection)
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.detailPage)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.section.title, testSection.title)
    }
    
    func test_makeDetailViewModel_canLoadDetail() async {
        let viewModel = DetailFactory.makeDetailViewModel(for: testSection)
        
        XCTAssertNil(viewModel.detailPage)
        
        await viewModel.loadDetail()
        
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func test_makeDetailViewModel_withNilHref() {
        let sectionWithoutHref = ContentSection(
            title: "No Href Section",
            description: "Description without href",
            href: nil
        )
        
        let viewModel = DetailFactory.makeDetailViewModel(for: sectionWithoutHref)
        
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.section.title, "No Href Section")
        XCTAssertEqual(viewModel.section.description, "Description without href")
        XCTAssertNil(viewModel.section.href)
    }
    
    func test_makeDetailViewModel_withEmptyStrings() {
        let emptySection = ContentSection(
            title: "",
            description: "",
            href: nil
        )
        
        let viewModel = DetailFactory.makeDetailViewModel(for: emptySection)
        
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.section.title, "")
        XCTAssertEqual(viewModel.section.description, "")
        XCTAssertNil(viewModel.section.href)
    }
    
    func test_makeDetailViewModel_withSpecialCharacters() {
        let specialSection = ContentSection(
            title: "Special: áéíóú ñç 🚀",
            description: "Description with émojis 🚀 and symbols @#$%",
            href: URL(string: "https://example.com/path?query=value&other=test")
        )
        
        let viewModel = DetailFactory.makeDetailViewModel(for: specialSection)
        
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.section.title, "Special: áéíóú ñç 🚀")
        XCTAssertEqual(viewModel.section.description, "Description with émojis 🚀 and symbols @#$%")
        XCTAssertEqual(viewModel.section.href?.absoluteString, "https://example.com/path?query=value&other=test")
    }
    
    func test_makeDetailViewModel_multipleCallsConsistency() {
        let sections = [
            ContentSection(title: "Section 1", description: "Desc 1", href: nil),
            ContentSection(title: "Section 2", description: "Desc 2", href: nil),
            ContentSection(title: "Section 3", description: "Desc 3", href: nil)
        ]
        
        let viewModels = sections.map { DetailFactory.makeDetailViewModel(for: $0) }
        
        for (index, viewModel) in viewModels.enumerated() {
            XCTAssertNotNil(viewModel)
            XCTAssertEqual(viewModel.section.title, "Section \(index + 1)")
            XCTAssertEqual(viewModel.section.description, "Desc \(index + 1)")
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertNil(viewModel.detailPage)
            XCTAssertNil(viewModel.errorMessage)
        }
        
        let uniqueViewModels = Set(viewModels.map { ObjectIdentifier($0) })
        XCTAssertEqual(uniqueViewModels.count, viewModels.count)
    }
}
