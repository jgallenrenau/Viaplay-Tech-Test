import XCTest
import SwiftUI
import SnapshotTesting
@testable import Sections
@testable import Domain

final class SectionsListViewtvOSSnapshotTests: XCTestCase {
    
    private var mockViewModel: MockSectionsViewModel!
    
    override func setUp() {
        super.setUp()
        mockViewModel = MockSectionsViewModel()
    }
    
    override func tearDown() {
        mockViewModel = nil
        super.tearDown()
    }
    
    func testSectionsListViewtvOSWithSections() {
        mockViewModel.sections = [
            Section(title: "Series", description: "Drama series", href: URL(string: "https://example.com/series")!),
            Section(title: "Movies", description: "Action movies", href: URL(string: "https://example.com/movies")!),
            Section(title: "Sports", description: "Live sports", href: URL(string: "https://example.com/sports")!)
        ]
        mockViewModel.isLoading = false
        mockViewModel.errorMessage = nil
        
        let view = SectionsListView(viewModel: mockViewModel)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
    
    func testSectionsListViewtvOSLoading() {
        mockViewModel.isLoading = true
        mockViewModel.sections = []
        mockViewModel.errorMessage = nil
        
        let view = SectionsListView(viewModel: mockViewModel)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
    
    func testSectionsListViewtvOSError() {
        mockViewModel.isLoading = false
        mockViewModel.sections = []
        mockViewModel.errorMessage = "Network error occurred"
        
        let view = SectionsListView(viewModel: mockViewModel)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
    
    func testSectionsListViewtvOSEmpty() {
        mockViewModel.isLoading = false
        mockViewModel.sections = []
        mockViewModel.errorMessage = nil
        
        let view = SectionsListView(viewModel: mockViewModel)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
    
    func testSectionsListViewtvOSWithLongTitles() {
        mockViewModel.sections = [
            Section(title: "Very Long Section Title That Should Test Text Wrapping", description: "Description", href: URL(string: "https://example.com")!),
            Section(title: "Another Long Title", description: "Very long description that should test text wrapping and layout behavior on Apple TV", href: URL(string: "https://example.com")!)
        ]
        mockViewModel.isLoading = false
        mockViewModel.errorMessage = nil
        
        let view = SectionsListView(viewModel: mockViewModel)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
    
    func testSectionsListViewtvOSInDarkMode() {
        mockViewModel.sections = [
            Section(title: "Dark Mode Series", description: "Dark mode description", href: URL(string: "https://example.com")!)
        ]
        mockViewModel.isLoading = false
        mockViewModel.errorMessage = nil
        
        let view = SectionsListView(viewModel: mockViewModel)
            .preferredColorScheme(.dark)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
}

// MARK: - Mock ViewModel
private class MockSectionsViewModel: ObservableObject {
    @Published var sections: [Section] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    func loadSections() async {
        // Mock implementation
    }
}
