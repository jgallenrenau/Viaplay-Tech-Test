import XCTest
import SwiftUI
import SnapshotTesting
@testable import DetailSection
@testable import Domain

final class DetailViewtvOSSnapshotTests: XCTestCase {
    
    private var mockViewModel: MockDetailViewModel!
    
    override func setUp() {
        super.setUp()
        mockViewModel = MockDetailViewModel()
    }
    
    override func tearDown() {
        mockViewModel = nil
        super.tearDown()
    }
    
    func testDetailViewtvOSWithContent() {
        mockViewModel.detailPage = DetailPage(
            title: "Test Section",
            description: "This is a test description for the detail view",
            items: [
                DetailItem(title: "Item 1", description: "Description 1", href: URL(string: "https://example.com/1")),
                DetailItem(title: "Item 2", description: "Description 2", href: URL(string: "https://example.com/2")),
                DetailItem(title: "Item 3", description: "Description 3", href: URL(string: "https://example.com/3"))
            ],
            navigationTitle: "Test Section"
        )
        mockViewModel.isLoading = false
        mockViewModel.errorMessage = nil
        
        let section = ContentSection(title: "Test Section", description: "Test Description", href: URL(string: "https://example.com")!)
        let view = DetailView(section: section, viewModel: mockViewModel)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
    
    func testDetailViewtvOSLoading() {
        mockViewModel.isLoading = true
        mockViewModel.detailPage = nil
        mockViewModel.errorMessage = nil
        
        let section = ContentSection(title: "Test Section", description: "Test Description", href: URL(string: "https://example.com")!)
        let view = DetailView(section: section, viewModel: mockViewModel)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
    
    func testDetailViewtvOSError() {
        mockViewModel.isLoading = false
        mockViewModel.detailPage = nil
        mockViewModel.errorMessage = "Failed to load details"
        
        let section = ContentSection(title: "Test Section", description: "Test Description", href: URL(string: "https://example.com")!)
        let view = DetailView(section: section, viewModel: mockViewModel)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
    
    func testDetailViewtvOSEmpty() {
        mockViewModel.isLoading = false
        mockViewModel.detailPage = DetailPage(
            title: "Empty Section",
            description: nil,
            items: [],
            navigationTitle: "Empty Section"
        )
        mockViewModel.errorMessage = nil
        
        let section = ContentSection(title: "Empty Section", description: "Empty Description", href: URL(string: "https://example.com")!)
        let view = DetailView(section: section, viewModel: mockViewModel)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
    
    func testDetailViewtvOSWithLongContent() {
        mockViewModel.detailPage = DetailPage(
            title: "Very Long Section Title That Should Test Text Wrapping on Apple TV",
            description: "This is a very long description that should test text wrapping and layout behavior in the detail view on Apple TV. It should handle multiple lines properly and maintain good readability.",
            items: [
                DetailItem(title: "Very Long Item Title That Should Test Text Wrapping", description: "Very long item description that should test text wrapping and layout behavior", href: URL(string: "https://example.com/1")),
                DetailItem(title: "Another Long Item", description: "Another very long description for testing purposes", href: URL(string: "https://example.com/2"))
            ],
            navigationTitle: "Long Section"
        )
        mockViewModel.isLoading = false
        mockViewModel.errorMessage = nil
        
        let section = ContentSection(title: "Long Section", description: "Long Description", href: URL(string: "https://example.com")!)
        let view = DetailView(section: section, viewModel: mockViewModel)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
    
    func testDetailViewtvOSInDarkMode() {
        mockViewModel.detailPage = DetailPage(
            title: "Dark Mode Section",
            description: "Dark mode description",
            items: [
                DetailItem(title: "Dark Item", description: "Dark description", href: URL(string: "https://example.com")!)
            ],
            navigationTitle: "Dark Section"
        )
        mockViewModel.isLoading = false
        mockViewModel.errorMessage = nil
        
        let section = ContentSection(title: "Dark Section", description: "Dark Description", href: URL(string: "https://example.com")!)
        let view = DetailView(section: section, viewModel: mockViewModel)
            .preferredColorScheme(.dark)
        
        assertSnapshot(of: view, as: .image(layout: .device(config: .tvOS)))
    }
}

// MARK: - Mock ViewModel
private class MockDetailViewModel: ObservableObject {
    @Published var detailPage: DetailPage? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    func loadDetail() async {
        // Mock implementation
    }
}
