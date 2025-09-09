#if os(iOS)
import XCTest
import SnapshotTesting
import Domain
import SwiftUI
import UIKit
@testable import Sections

@MainActor
final class SectionsListViewSnapshotTests: XCTestCase {
    private let isRecording = true
    
    // MARK: - 1080p Fixed Resolution Configuration
    private let config1080pPortrait = ViewImageConfig(
        safeArea: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 1080, height: 1920),
        traits: UITraitCollection(traitsFrom: [
            .init(displayScale: 1.0),
            .init(userInterfaceStyle: .light)
        ])
    )
    
    private let config1080pLandscape = ViewImageConfig(
        safeArea: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0), size: CGSize(width: 1920, height: 1080),
        traits: UITraitCollection(traitsFrom: [
            .init(displayScale: 1.0),
            .init(userInterfaceStyle: .light)
        ])
    )
    func test_sectionsListView_snapshot_vertical() {
        let viewModel = SectionsViewModel(
            fetchSectionsUseCase: DummyUseCase(),
            cacheService: SectionDescriptionCacheService()
        )
        viewModel.sections = [Domain.Section(id: "1", title: "Movies", description: "Popular"),
                              Domain.Section(id: "2", title: "Series")]
        let view = SectionsListView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080pPortrait))
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
        assertSnapshot(of: vc, as: .image(on: config1080pPortrait))
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
        assertSnapshot(of: vc, as: .image(on: config1080pPortrait))
    }
    
    // MARK: - Landscape Tests
    func test_sectionsListView_snapshot_landscape() {
        let viewModel = SectionsViewModel(
            fetchSectionsUseCase: DummyUseCase(),
            cacheService: SectionDescriptionCacheService()
        )
        viewModel.sections = [Domain.Section(id: "1", title: "Movies", description: "Popular"),
                              Domain.Section(id: "2", title: "Series")]
        let view = SectionsListView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080pLandscape))
    }
    
    func test_sectionsListView_snapshot_landscape_with_many_sections() {
        let viewModel = SectionsViewModel(
            fetchSectionsUseCase: DummyUseCase(),
            cacheService: SectionDescriptionCacheService()
        )
        viewModel.sections = [
            Domain.Section(id: "1", title: "Movies", description: "Popular movies"),
            Domain.Section(id: "2", title: "Series", description: "TV series"),
            Domain.Section(id: "3", title: "Sports", description: "Live sports"),
            Domain.Section(id: "4", title: "Kids", description: "Children content"),
            Domain.Section(id: "5", title: "Documentaries", description: "Educational content")
        ]
        let view = SectionsListView(viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080pLandscape))
    }
    
    func test_sectionsListView_snapshot_landscape_dark_mode() {
        let viewModel = SectionsViewModel(
            fetchSectionsUseCase: DummyUseCase(),
            cacheService: SectionDescriptionCacheService()
        )
        viewModel.sections = [Domain.Section(id: "1", title: "Movies", description: "Popular"),
                              Domain.Section(id: "2", title: "Series")]
        let view = SectionsListView(viewModel: viewModel)
            .preferredColorScheme(.dark)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: config1080pLandscape))
    }
}

struct DummyUseCase: Domain.FetchSectionsUseCaseProtocol {
    func execute() async throws -> Domain.SectionsPage { Domain.SectionsPage(title: "t", sections: []) }
}
#endif
