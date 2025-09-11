import XCTest
import Domain
@testable import Sections

final class SectionsRepositoryImplTests: XCTestCase {
    final class SectionsDataSourceStub: SectionsDataSourceProtocol {
        var result: Result<SectionsPage, Error> = .success(SectionsPage(title: "t", sections: []))
        var calls = 0
        func fetchSections() async throws -> SectionsPage {
            calls += 1
            switch result {
            case .success(let page): return page
            case .failure(let error): throw error
            }
        }
    }
    private var dataSource: SectionsDataSourceStub!
    private var sut: SectionsRepositoryImpl!

    override func setUp() {
        super.setUp()
        dataSource = SectionsDataSourceStub()
        sut = SectionsRepositoryImpl(dataSource: dataSource)
    }

    override func tearDown() {
        sut = nil
        dataSource = nil
        super.tearDown()
    }

    func test_fetchSections_forwardsFromDataSource() async throws {
        dataSource.result = .success(SectionsPage(title: "Home", sections: [Section(id: "1", title: "A")]))
        let page = try await sut.fetchSections()
        XCTAssertEqual(page.title, "Home")
        XCTAssertEqual(page.sections.count, 1)
        XCTAssertEqual(dataSource.calls, 1)
    }

    func test_fetchSections_propagatesError() async {
        enum TestError: Error { case generic }
        dataSource.result = .failure(TestError.generic)

        do {
            _ = try await sut.fetchSections()
            XCTFail("Expected error")
        } catch {
            XCTAssertTrue(error is TestError)
        }
        XCTAssertEqual(dataSource.calls, 1)
    }

    func test_fetchSections_multipleCalls() async throws {
        dataSource.result = .success(SectionsPage(title: "Home", sections: []))
        _ = try await sut.fetchSections()
        _ = try await sut.fetchSections()
        XCTAssertEqual(dataSource.calls, 2)
    }
}
