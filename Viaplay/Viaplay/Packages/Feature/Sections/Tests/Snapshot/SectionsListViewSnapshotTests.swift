import XCTest
import SnapshotTesting
import Domain
@testable import Sections

@MainActor
final class SectionsListViewSnapshotTests: XCTestCase {
    func test_sectionsListView_snapshot() {
        let viewModel = SectionsViewModel(fetchSectionsUseCase: DummyUseCase())
        viewModel.sections = [Section(id: "1", title: "Movies", description: "Popular"),
                              Section(id: "2", title: "Series")]
        let view = SectionsListView(viewModel: viewModel)
        assertSnapshot(of: view, as: .image(layout: .device(config: .iPhone13)))
    }
}

struct DummyUseCase: FetchSectionsUseCaseProtocol {
    func execute() async throws -> SectionsPage { SectionsPage(title: "t", sections: []) }
}
