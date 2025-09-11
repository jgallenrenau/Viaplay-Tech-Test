import XCTest
import Domain
@testable import DetailSection

final class DetailFactoryTests: XCTestCase {
    @MainActor
    func test_makeDetailViewModel_buildsViewModel() {
        let section = ContentSection(title: "S", description: "D")
        let vm = DetailFactory.makeDetailViewModel(for: section)
        XCTAssertEqual(vm.section.title, "S")
    }
}
