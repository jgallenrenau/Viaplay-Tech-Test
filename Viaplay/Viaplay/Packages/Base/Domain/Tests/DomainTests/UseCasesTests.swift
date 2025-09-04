import XCTest
@testable import Domain

// Fake repository for testing use cases
private final class FakePageRepository: PageRepository {
    var root: Page
    var pages: [URL: Page]
    init(root: Page, pages: [URL: Page] = [:]) { self.root = root; self.pages = pages }
    func getRootPage() async throws -> Page { root }
    func getPage(by url: URL) async throws -> Page { pages[url] ?? root }
}

final class UseCasesTests: XCTestCase {
    func testGetRootPageReturnsPage() async throws {
        let repo = FakePageRepository(root: Page(title: "Home", sections: []))
        let useCase = GetRootPage(repository: repo)
        let page = try await useCase.execute()
        XCTAssertEqual(page.title, "Home")
    }

    func testGetPageReturnsSpecificPage() async throws {
        let url = URL(string: "https://example.com/page")!
        let repo = FakePageRepository(
            root: Page(title: "Home", sections: []),
            pages: [url: Page(title: "P", sections: [ContentSection(title: "A")])]
        )
        let useCase = GetPage(repository: repo)
        let page = try await useCase.execute(url: url)
        XCTAssertEqual(page.sections.first?.title, "A")
    }
}
