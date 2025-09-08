import XCTest
import SwiftUI
@testable import Sections
@testable import Domain

@MainActor
final class SectionsListViewTests: XCTestCase {
    func testConstructsWithMockUseCase() {
        struct DummyUseCase: FetchSectionsUseCaseProtocol {
            func execute() async throws -> SectionsPage { SectionsPage(title: "Test", sections: []) }
        }

        let viewModel = SectionsViewModel(
            fetchSectionsUseCase: DummyUseCase(),
            cacheService: SectionDescriptionCacheService()
        )
        _ = SectionsListView(viewModel: viewModel)
        XCTAssertTrue(true)
    }
}
