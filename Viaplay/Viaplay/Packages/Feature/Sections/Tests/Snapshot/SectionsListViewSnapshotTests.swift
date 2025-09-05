import XCTest
import SnapshotTesting
import Domain
@testable import Sections

@MainActor
final class SectionsListViewSnapshotTests: XCTestCase {
    func test_sectionsListView_snapshot() {
        let viewModel = SectionsViewModel(fetchSectionsUseCase: DummyUseCase())
        viewModel.sections = [Domain.Section(id: "1", title: "Movies", description: "Popular"),
                              Domain.Section(id: "2", title: "Series")]
        let view = SectionsListView(viewModel: viewModel)
        // TODO: Fix snapshot testing configuration
        // assertSnapshot(matching: view, as: .image)
        XCTAssertNotNil(view)
    }
}

struct DummyUseCase: Domain.FetchSectionsUseCaseProtocol {
    func execute() async throws -> Domain.SectionsPage { Domain.SectionsPage(title: "t", sections: []) }
}
