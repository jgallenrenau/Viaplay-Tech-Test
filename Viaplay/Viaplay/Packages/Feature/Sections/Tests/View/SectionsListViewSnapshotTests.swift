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
        assertSnapshot(matching: makeVC(view), as: .image, record: isRecording)
    }
    
    func test_error_dark() {
        let vm = SectionsViewModel(fetchSectionsUseCase: DummyUseCase(), cacheService: SectionDescriptionCacheService())
        vm.errorMessage = "Oops"
        let view = SectionsListView(viewModel: vm).preferredColorScheme(.dark)
        assertSnapshot(matching: makeVC(view), as: .image, record: isRecording)
    }
    
    func test_empty_dynamicTypeXXL() {
        let vm = SectionsViewModel(fetchSectionsUseCase: DummyUseCase(), cacheService: SectionDescriptionCacheService())
        vm.sections = []
        let view = SectionsListView(viewModel: vm)
        let traits = UITraitCollection(preferredContentSizeCategory: .accessibilityExtraExtraExtraLarge)
        assertSnapshot(matching: makeVC(view, traits: traits), as: .image, record: isRecording)
    }
    
    func test_success_list_long() {
        let vm = SectionsViewModel(fetchSectionsUseCase: DummyUseCase(), cacheService: SectionDescriptionCacheService())
        vm.sections = (1...12).map { Section(id: String($0), title: "Section \($0)") }
        let view = SectionsListView(viewModel: vm)
        assertSnapshot(matching: makeVC(view, size: CGSize(width: 428, height: 926)), as: .image, record: isRecording)
    }
}

struct DummyUseCase: Domain.FetchSectionsUseCaseProtocol {
    func execute() async throws -> Domain.SectionsPage { Domain.SectionsPage(title: "t", sections: []) }
}
#endif
