import XCTest
import SnapshotTesting
import Domain
@testable import DetailSection
import SwiftUI

@MainActor
final class DetailViewSnapshotTests: XCTestCase {
    private let record = false
    
    private func makeVC<T: View>(_ view: T, dark: Bool = false, size: CGSize = CGSize(width: 390, height: 844)) -> UIViewController {
        let v = dark ? AnyView(view.preferredColorScheme(.dark)) : AnyView(AnyView(view))
        let vc = UIHostingController(rootView: v)
        vc.view.frame = CGRect(origin: .zero, size: size)
        return vc
    }
    
    func test_loading_light() {
        let section = ContentSection(title: "S", description: "D")
        let vm = DetailViewModel(section: section, fetchDetailUseCase: DummyDetailUseCase())
        vm.isLoading = true
        let view = DetailView(section: section, viewModel: vm)
        assertSnapshot(of: makeVC(view), as: .image, record: isRecording)
    }
    
    func test_error_dark() {
        let section = ContentSection(title: "S", description: "D")
        let vm = DetailViewModel(section: section, fetchDetailUseCase: DummyDetailUseCase())
        vm.errorMessage = "Network error"
        let view = DetailView(section: section, viewModel: vm)
        assertSnapshot(of: makeVC(view, dark: true), as: .image, record: isRecording)
    }
    
    func test_empty_light() {
        let section = ContentSection(title: "S", description: "D")
        let vm = DetailViewModel(section: section, fetchDetailUseCase: DummyDetailUseCase())
        vm.detailPage = DetailPage(title: "S", items: [])
        let view = DetailView(section: section, viewModel: vm)
        assertSnapshot(of: makeVC(view), as: .image, record: isRecording)
    }
    
    func test_oneItem_dark_large() {
        let section = ContentSection(title: "S", description: "D")
        let vm = DetailViewModel(section: section, fetchDetailUseCase: DummyDetailUseCase())
        vm.detailPage = DetailPage(title: "S", items: [DetailItem(id: "1", title: "Item", description: "Desc")])
        let view = DetailView(section: section, viewModel: vm)
        assertSnapshot(of: makeVC(view, dark: true, size: CGSize(width: 428, height: 926)), as: .image, record: isRecording)
    }
    
    func test_manyItems_light() {
        let section = ContentSection(title: "S", description: "D")
        let vm = DetailViewModel(section: section, fetchDetailUseCase: DummyDetailUseCase())
        vm.detailPage = DetailPage(title: "S", items: (1...10).map { DetailItem(id: String($0), title: "Item \($0)") })
        let view = DetailView(section: section, viewModel: vm)
        assertSnapshot(of: makeVC(view, size: CGSize(width: 390, height: 844)), as: .image, record: isRecording)
    }
}

struct DummyDetailUseCase: Domain.FetchDetailUseCaseProtocol {
    func execute(section: ContentSection) async throws -> Domain.DetailPage {
        Domain.DetailPage(title: section.title, items: [])
    }
}
