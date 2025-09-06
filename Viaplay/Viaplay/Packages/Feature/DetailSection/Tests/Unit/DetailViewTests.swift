import XCTest
import SwiftUI
import Domain
@testable import DetailSection

final class DetailViewTests: XCTestCase {
    
    @MainActor func testDetailViewInitializationWithViewModel() {
        let section = ContentSection(title: "Test Section", description: "Test Description")
        let viewModel = DetailViewModel(section: section, fetchDetailUseCase: MockFetchDetailUseCase())
        let view = DetailView(section: section, viewModel: viewModel)
        
        XCTAssertNotNil(view)
    }
    
    func testDetailViewInitializationWithoutViewModel() {
        let section = ContentSection(title: "Test Section", description: "Test Description")
        let view = DetailView(section: section)
        
        XCTAssertNotNil(view)
    }
    
    func testDetailViewWithDummyUseCase() {
        let section = ContentSection(title: "Test Section", description: "Test Description")
        let view = DetailView(section: section)
        
        // Verify view can be created with dummy use case
        XCTAssertNotNil(view)
    }
}

// MARK: - Mock UseCase

private class MockFetchDetailUseCase: Domain.FetchDetailUseCaseProtocol {
    func execute(section: ContentSection) async throws -> Domain.DetailPage {
        return Domain.DetailPage(
            title: section.title,
            description: section.description,
            items: [],
            navigationTitle: section.title
        )
    }
}
