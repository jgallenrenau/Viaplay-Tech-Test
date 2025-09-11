import XCTest
import SwiftUI
import SnapshotTesting
@testable import Sections
@testable import Domain

@MainActor
final class SectionsListViewtvOSSnapshotTests: XCTestCase {
    private let isRecording = false
    
    // MARK: - 1080p Fixed Resolution Configuration for tvOS
    private let config1080p = ViewImageConfig(
        safeArea: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 1920, height: 1080),
        traits: UITraitCollection(traitsFrom: [
            .init(displayScale: 1.0),
            .init(userInterfaceStyle: .light)
        ])
    )
    
    private var viewModel: SectionsViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = SectionsViewModel(fetchSectionsUseCase: DummyUseCase(), cacheService: SectionDescriptionCacheService())
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testSectionsListViewtvOSWithSections() {
        viewModel.sections = [
            Domain.Section(id: "sec-series", title: "Series", href: URL(string: "https://example.com/series")!, description: "Drama series"),
            Domain.Section(id: "sec-movies", title: "Movies", href: URL(string: "https://example.com/movies")!, description: "Action movies"),
            Domain.Section(id: "sec-sports", title: "Sports", href: URL(string: "https://example.com/sports")!, description: "Live sports")
        ]
        viewModel.isLoading = false
        viewModel.errorMessage = nil
        
        let view = SectionsListView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p))
    }
    
    func testSectionsListViewtvOSLoading() {
        viewModel.isLoading = true
        viewModel.sections = []
        viewModel.errorMessage = nil
        
        let view = SectionsListView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p))
    }
    
    func testSectionsListViewtvOSError() {
        viewModel.isLoading = false
        viewModel.sections = []
        viewModel.errorMessage = "Network error occurred"
        
        let view = SectionsListView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p))
    }
    
    func testSectionsListViewtvOSEmpty() {
        viewModel.isLoading = false
        viewModel.sections = []
        viewModel.errorMessage = nil
        
        let view = SectionsListView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p))
    }
    
    func testSectionsListViewtvOSWithLongTitles() {
        viewModel.sections = [
            Domain.Section(id: "sec-long-1", title: "Very Long Section Title That Should Test Text Wrapping", href: URL(string: "https://example.com")!, description: "Description"),
            Domain.Section(id: "sec-long-2", title: "Another Long Title", href: URL(string: "https://example.com")!, description: "Very long description that should test text wrapping and layout behavior on Apple TV")
        ]
        viewModel.isLoading = false
        viewModel.errorMessage = nil
        
        let view = SectionsListView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p))
    }
    
    func testSectionsListViewtvOSInDarkMode() {
        viewModel.sections = [
            Domain.Section(id: "sec-dark", title: "Dark Mode Series", href: URL(string: "https://example.com")!, description: "Dark mode description")
        ]
        viewModel.isLoading = false
        viewModel.errorMessage = nil
        
        let view = SectionsListView(viewModel: viewModel)
            .preferredColorScheme(.dark)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080p))
    }
}
