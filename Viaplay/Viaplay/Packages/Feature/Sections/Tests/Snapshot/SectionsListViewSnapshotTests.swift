#if os(iOS)
import XCTest
import SnapshotTesting
import Domain
import SwiftUI
import UIKit
@testable import Sections

@MainActor
final class SectionsListViewSnapshotTests: XCTestCase {
    func test_sectionsListView_snapshot_vertical() {
        let viewModel = SectionsViewModel(
            fetchSectionsUseCase: DummyUseCase(),
            cacheService: SectionDescriptionCacheService()
        )
        viewModel.sections = [Domain.Section(id: "1", title: "Movies", description: "Popular"),
                              Domain.Section(id: "2", title: "Series")]
        let view = SectionsListView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .iPhone12(.portrait)))
    }

    func test_sectionsListView_snapshot_horizontal() {
        let viewModel = SectionsViewModel(
            fetchSectionsUseCase: DummyUseCase(),
            cacheService: SectionDescriptionCacheService()
        )
        viewModel.sections = [Domain.Section(id: "1", title: "Movies", description: "Popular"),
                              Domain.Section(id: "2", title: "Series")]
        let view = SectionsListView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .iPhone12(.landscape)))
    }
    
    func test_sectionsListView_snapshot_portrait() {
        let viewModel = SectionsViewModel(
            fetchSectionsUseCase: DummyUseCase(),
            cacheService: SectionDescriptionCacheService()
        )
        viewModel.sections = [Domain.Section(id: "1", title: "Movies", description: "Popular"),
                              Domain.Section(id: "2", title: "Series")]
        let view = SectionsListView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .iPhone12(.portrait)))
    }
}

struct DummyUseCase: Domain.FetchSectionsUseCaseProtocol {
    func execute() async throws -> Domain.SectionsPage { Domain.SectionsPage(title: "t", sections: []) }
}
#endif
