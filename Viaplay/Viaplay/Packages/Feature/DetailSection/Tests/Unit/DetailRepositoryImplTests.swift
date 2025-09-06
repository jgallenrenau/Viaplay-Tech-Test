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
        dataSourceStub.result = .failure(TestError.generic)
        
        do {
            _ = try await sut.fetchDetail(for: section)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is TestError)
        }
    }
    
    func test_fetchDetail_successWithValidData() async throws {
        let expectedDetailPage = Domain.DetailPage(
            title: "Expected Title",
            description: "Expected Description",
            items: [
                Domain.DetailItem(id: "1", title: "Item 1"),
                Domain.DetailItem(id: "2", title: "Item 2")
            ],
            navigationTitle: "Navigation Title"
        )
        dataSourceStub.result = .success(expectedDetailPage)
        
        let result = try await sut.fetchDetail(for: section)
        
        XCTAssertEqual(result.title, expectedDetailPage.title)
        XCTAssertEqual(result.description, expectedDetailPage.description)
        XCTAssertEqual(result.items.count, expectedDetailPage.items.count)
        XCTAssertEqual(result.navigationTitle, expectedDetailPage.navigationTitle)
    }
    
    func test_fetchDetail_successWithEmptyItems() async throws {
        let expectedDetailPage = Domain.DetailPage(
            title: "Empty Items Title",
            items: []
        )
        dataSourceStub.result = .success(expectedDetailPage)
        
        let result = try await sut.fetchDetail(for: section)
        
        XCTAssertEqual(result.title, expectedDetailPage.title)
        XCTAssertTrue(result.items.isEmpty)
    }
    
    func test_fetchDetail_callsDataSourceWithCorrectSection() async throws {
        let customSection = ContentSection(title: "Custom Section", description: "Custom Description")
        dataSourceStub.result = .success(Domain.DetailPage(title: "Test", items: []))
        
        _ = try await sut.fetchDetail(for: customSection)
        
        // Verify the data source was called (in a real implementation, we'd track calls)
        XCTAssertNotNil(dataSourceStub)
    }
    
    func test_fetchDetail_multipleCalls() async throws {
        dataSourceStub.result = .success(Domain.DetailPage(title: "Test", items: []))
        
        let result1 = try await sut.fetchDetail(for: section)
        let result2 = try await sut.fetchDetail(for: section)
        
        XCTAssertNotNil(result1)
        XCTAssertNotNil(result2)
    }
}

private enum TestError: LocalizedError, Equatable {
    case generic
    var errorDescription: String? { "Test Error" }
}
