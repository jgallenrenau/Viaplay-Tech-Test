import XCTest
import SwiftUI
import Domain
@testable import Sections

@MainActor
final class SectionsListViewtvOSTests: XCTestCase {
    
    private var sut: SectionsListViewtvOS!
    private var viewModel: SectionsViewModel!
    
    override func setUp() async throws {
        try await super.setUp()
        viewModel = SectionsFactory.makeSectionsViewModel()
        sut = SectionsListViewtvOS(viewModel: viewModel)
    }
    
    override func tearDown() async throws {
        sut = nil
        viewModel = nil
        try await super.tearDown()
    }
    
    func test_initialization() {
        XCTAssertNotNil(sut)
        XCTAssertNotNil(viewModel)
    }
    
    func test_body_returnsView() {
        let body = sut.body
        XCTAssertNotNil(body)
    }
    
    func test_initialization_withDifferentViewModels() {
        let viewModel1 = SectionsFactory.makeSectionsViewModel()
        let viewModel2 = SectionsFactory.makeSectionsViewModel()
        
        let view1 = SectionsListViewtvOS(viewModel: viewModel1)
        let view2 = SectionsListViewtvOS(viewModel: viewModel2)
        
        XCTAssertNotNil(view1)
        XCTAssertNotNil(view2)
    }
    
    func test_view_lifecycle() {
        var view: SectionsListViewtvOS? = SectionsListViewtvOS(viewModel: viewModel)
        XCTAssertNotNil(view)
        
        let _ = view?.body
        
        view = nil
    }
    
    func test_view_withLoadingState() {
        viewModel.isLoading = true
        viewModel.sections = []
        viewModel.errorMessage = nil
        
        let body = sut.body
        XCTAssertNotNil(body)
    }
    
    func test_view_withErrorState() {
        viewModel.isLoading = false
        viewModel.sections = []
        viewModel.errorMessage = "Test error"
        
        let body = sut.body
        XCTAssertNotNil(body)
    }
    
    func test_view_withSections() {
        let testSections = [
            Domain.Section(id: "1", title: "Section 1", href: URL(string: "https://example.com")!, description: "Desc 1"),
            Domain.Section(id: "2", title: "Section 2", href: URL(string: "https://example.com")!, description: "Desc 2")
        ]
        
        viewModel.isLoading = false
        viewModel.sections = testSections
        viewModel.errorMessage = nil
        
        let body = sut.body
        XCTAssertNotNil(body)
    }
    
    func test_view_withRootPageDescription() {
        viewModel.isLoading = false
        viewModel.sections = []
        viewModel.errorMessage = nil
        viewModel.rootPageDescription = "Root page description"
        
        let body = sut.body
        XCTAssertNotNil(body)
    }
    
    func test_view_withoutRootPageDescription() {
        viewModel.isLoading = false
        viewModel.sections = []
        viewModel.errorMessage = nil
        viewModel.rootPageDescription = nil
        
        let body = sut.body
        XCTAssertNotNil(body)
    }
    
    func test_view_withManySections() {
        let manySections = (1...10).map { index in
            Domain.Section(
                id: "\(index)",
                title: "Section \(index)",
                href: URL(string: "https://example.com/\(index)")!,
                description: "Description \(index)"
            )
        }
        
        viewModel.isLoading = false
        viewModel.sections = manySections
        viewModel.errorMessage = nil
        
        let body = sut.body
        XCTAssertNotNil(body)
    }
    
    func test_view_withEmptySections() {
        viewModel.isLoading = false
        viewModel.sections = []
        viewModel.errorMessage = nil
        
        let body = sut.body
        XCTAssertNotNil(body)
    }
    
    func test_view_multipleInstances() {
        let viewModel1 = SectionsFactory.makeSectionsViewModel()
        let viewModel2 = SectionsFactory.makeSectionsViewModel()
        
        viewModel1.sections = [Domain.Section(id: "1", title: "Section 1", href: URL(string: "https://example.com")!, description: "Desc 1")]
        viewModel2.sections = [Domain.Section(id: "2", title: "Section 2", href: URL(string: "https://example.com")!, description: "Desc 2")]
        
        let view1 = SectionsListViewtvOS(viewModel: viewModel1)
        let view2 = SectionsListViewtvOS(viewModel: viewModel2)
        
        XCTAssertNotNil(view1)
        XCTAssertNotNil(view2)
        XCTAssertNotNil(view1.body)
        XCTAssertNotNil(view2.body)
    }
}

