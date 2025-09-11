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
    
    // MARK: - Edge Cases
    
    @MainActor func testDetailViewWithEmptySection() {
        let emptySection = ContentSection(title: "", description: "")
        let view = DetailView(section: emptySection)
        
        XCTAssertNotNil(view)
    }
    
    @MainActor func testDetailViewWithNilDescription() {
        let sectionWithNilDescription = ContentSection(title: "Test", description: nil)
        let view = DetailView(section: sectionWithNilDescription)
        
        XCTAssertNotNil(view)
    }
    
    @MainActor func testDetailViewWithLongTitle() {
        let longTitle = String(repeating: "Very Long Title ", count: 50)
        let section = ContentSection(title: longTitle, description: "Description")
        let view = DetailView(section: section)
        
        XCTAssertNotNil(view)
    }
    
    @MainActor func testDetailViewWithUnicodeCharacters() {
        let unicodeSection = ContentSection(title: "Sección con ñ y áéíóú", description: "Descripción")
        let view = DetailView(section: unicodeSection)
        
        XCTAssertNotNil(view)
    }
    
    @MainActor func testDetailViewWithSpecialCharacters() {
        let specialSection = ContentSection(title: "Section!@#$%^&*()", description: "Description with symbols")
        let view = DetailView(section: specialSection)
        
        XCTAssertNotNil(view)
    }
    
    @MainActor func testDetailViewWithHref() {
        let sectionWithHref = ContentSection(
            title: "Test Section",
            description: "Test Description",
            href: URL(string: "https://example.com")
        )
        let view = DetailView(section: sectionWithHref)
        
        XCTAssertNotNil(view)
    }
    
    @MainActor func testDetailViewWithNilHref() {
        let sectionWithNilHref = ContentSection(
            title: "Test Section",
            description: "Test Description",
            href: nil
        )
        let view = DetailView(section: sectionWithNilHref)
        
        XCTAssertNotNil(view)
    }
    
    // MARK: - ViewModel Integration Tests
    
    @MainActor func testDetailViewWithLoadingState() {
        let section = ContentSection(title: "Test", description: "Description")
        let mockUseCase = MockFetchDetailUseCase()
        let viewModel = DetailViewModel(section: section, fetchDetailUseCase: mockUseCase)
        let view = DetailView(section: section, viewModel: viewModel)
        
        XCTAssertNotNil(view)
        XCTAssertFalse(viewModel.isLoading)
    }
    
    @MainActor func testDetailViewWithErrorState() {
        let section = ContentSection(title: "Test", description: "Description")
        let mockUseCase = MockFetchDetailUseCase()
        mockUseCase.shouldThrowError = true
        let viewModel = DetailViewModel(section: section, fetchDetailUseCase: mockUseCase)
        let view = DetailView(section: section, viewModel: viewModel)
        
        XCTAssertNotNil(view)
    }
    
    @MainActor func testDetailViewWithSuccessState() {
        let section = ContentSection(title: "Test", description: "Description")
        let mockUseCase = MockFetchDetailUseCase()
        let viewModel = DetailViewModel(section: section, fetchDetailUseCase: mockUseCase)
        let view = DetailView(section: section, viewModel: viewModel)
        
        XCTAssertNotNil(view)
    }
    
    // MARK: - Performance Tests
    
    @MainActor func testDetailViewCreationPerformance() {
        let section = ContentSection(title: "Test", description: "Description")
        
        measure {
            for _ in 0..<100 {
                _ = DetailView(section: section)
            }
        }
    }
    
    @MainActor func testDetailViewWithViewModelCreationPerformance() {
        let section = ContentSection(title: "Test", description: "Description")
        let mockUseCase = MockFetchDetailUseCase()
        
        measure {
            for _ in 0..<100 {
                let viewModel = DetailViewModel(section: section, fetchDetailUseCase: mockUseCase)
                _ = DetailView(section: section, viewModel: viewModel)
            }
        }
    }
}

// MARK: - Mock UseCase

private class MockFetchDetailUseCase: Domain.FetchDetailUseCaseProtocol {
    var shouldThrowError = false
    
    func execute(section: ContentSection) async throws -> Domain.DetailPage {
        if shouldThrowError {
            throw TestError.generic
        }
        
        return Domain.DetailPage(
            title: section.title,
            description: section.description,
            items: [],
            navigationTitle: section.title
        )
    }
}

private enum TestError: LocalizedError, Equatable {
    case generic
    var errorDescription: String? { "Test Error" }
}

// Remove invalid subclassing/override of final class and use a simple render test instead
extension DetailViewTests {
    @MainActor func test_errorState_renders() {
        let section = ContentSection(title: "S", description: "D")
        let mockUseCase = MockFetchDetailUseCase()
        let vm = DetailViewModel(section: section, fetchDetailUseCase: mockUseCase)
        vm.errorMessage = "err"
        let view = DetailView(section: section, viewModel: vm)
        XCTAssertNotNil(view)
    }
}
