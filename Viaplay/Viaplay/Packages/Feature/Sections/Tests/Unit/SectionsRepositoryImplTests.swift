import XCTest
import Domain
@testable import Sections

final class SectionsRepositoryImplTests: XCTestCase {
    struct SectionsDataSourceStub: SectionsDataSourceProtocol {
        func fetchSections() async throws -> SectionsPage {
            SectionsPage(title: "t", sections: [])
        }
    }
    private var sut: SectionsRepositoryImpl!

    override func setUp() {
        super.setUp()
        sut = SectionsRepositoryImpl(dataSource: SectionsDataSourceStub())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_fetchSections_forwardsFromDataSource() async throws {
        _ = try await sut.fetchSections()
    }
}
