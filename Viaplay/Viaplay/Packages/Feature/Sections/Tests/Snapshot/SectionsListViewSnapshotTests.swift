#if os(iOS)
import XCTest
import SnapshotTesting
import Domain
import SwiftUI
import UIKit
@testable import Sections

@MainActor
final class SectionsListViewSnapshotTests: XCTestCase {
    private let isRecording = false
    
    private func makeVC<T: View>(_ view: T, traits: UITraitCollection? = nil, size: CGSize = CGSize(width: 390, height: 844)) -> UIViewController {
        let vc = UIHostingController(rootView: view)
        vc.view.frame = CGRect(origin: .zero, size: size)
        if let traits { vc.setOverrideTraitCollection(traits, forChild: vc) }
        return vc
    }
    
    func test_loading_light() {
        let vm = SectionsViewModel(fetchSectionsUseCase: DummyUseCase(), cacheService: SectionDescriptionCacheService())
        vm.isLoading = true
        let view = SectionsListView(viewModel: vm)
        assertSnapshot(of: makeVC(view), as: .image, record: isRecording)
    }
}

struct DummyUseCase: Domain.FetchSectionsUseCaseProtocol {
    func execute() async throws -> Domain.SectionsPage { Domain.SectionsPage(title: "t", sections: []) }
}
#endif
