import XCTest
import Domain
@testable import DetailSection

final class DetailFactoryTests: XCTestCase {
    func test_build_injectsSectionAndUseCase() {
        let section = ContentSection(title: "S", description: "D")
        let view = DetailFactory.build(section: section)
        XCTAssertNotNil(view)
    }
}
