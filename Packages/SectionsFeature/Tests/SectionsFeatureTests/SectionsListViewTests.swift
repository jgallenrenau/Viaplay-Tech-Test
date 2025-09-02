import XCTest
import SwiftUI
@testable import SectionsFeature
@testable import DomainKit

final class SectionsListViewTests: XCTestCase {
    func testConstructsWithMockUseCase() {
        class MockGetRootPageUseCase: GetRootPageUseCase {
            func execute() async throws -> Page {
                return Page(
                    title: "Test Title",
                    description: "Test Description",
                    sections: []
                )
            }
        }
        
        let mockUseCase = MockGetRootPageUseCase()
        let viewModel = SectionsViewModel(getRootPage: mockUseCase)
        let _ = SectionsListView(viewModel: viewModel)
        XCTAssertTrue(true)
    }
}


