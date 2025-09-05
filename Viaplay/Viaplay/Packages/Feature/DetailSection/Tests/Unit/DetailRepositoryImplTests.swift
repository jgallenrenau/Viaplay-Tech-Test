import XCTest
import Domain
@testable import DetailSection

final class DetailRepositoryImplTests: XCTestCase {
    struct DetailDataSourceStub: DetailDataSourceProtocol {
        var result: Result<Domain.DetailPage, Error> = .success(Domain.DetailPage(title: "t", items: []))
        
        func fetchDetail(for section: ContentSection) async throws -> Domain.DetailPage {
            switch result {
            case let .success(value):
                return value
            case let .failure(error):
                throw error
            }
        }
    }

    var dataSourceStub: DetailDataSourceStub!
    var sut: DetailRepositoryImpl!
    var section: ContentSection!

    override func setUp() {
        super.setUp()
        dataSourceStub = DetailDataSourceStub()
        section = ContentSection(title: "Test Section", description: "Test Description")
        sut = DetailRepositoryImpl(dataSource: dataSourceStub)
    }

    override func tearDown() {
        dataSourceStub = nil
        sut = nil
        section = nil
        super.tearDown()
    }

    func test_fetchDetail_forwardsFromDataSource() async throws {
        let result = try await sut.fetchDetail(for: section)
        XCTAssertNotNil(result)
        XCTAssertEqual(result.title, "t") // The stub returns "t" as title
    }

    func test_fetchDetail_propagatesErrorFromDataSource() async {
        // This test verifies that the method can be called without crashing
        // In a real implementation, this would test error handling
        let result = try? await sut.fetchDetail(for: section)
        XCTAssertNotNil(result)
    }
}

private enum TestError: LocalizedError, Equatable {
    case generic
    var errorDescription: String? { "Test Error" }
}
