import XCTest
import SwiftUI
import SnapshotTesting
@testable import Sections
@testable import Domain

@MainActor
final class SectionsListViewtvOSSnapshotTests: XCTestCase {
    private let isRecording = false
    
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
        assertSnapshot(of: vc, as: .image(on: config1080p), record: isRecording)
    }
}
