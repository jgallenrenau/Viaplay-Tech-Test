import XCTest
import Domain
@testable import Sections

@MainActor
final class SectionsViewModelTests: XCTestCase {
    private var repo: SectionsRepositorySpy!
    private var useCase: FetchSectionsUseCase!
    private var cacheService: SectionDescriptionCacheService!
    private var sut: SectionsViewModel!

    override func setUp() async throws {
        try await super.setUp()
        repo = SectionsRepositorySpy()
        useCase = FetchSectionsUseCase(repository: repo)
        cacheService = SectionDescriptionCacheService()
        sut = SectionsViewModel(fetchSectionsUseCase: useCase, cacheService: cacheService)
    }

    override func tearDown() async throws {
        repo = nil
        useCase = nil
        cacheService = nil
        sut = nil
        try await super.tearDown()
    }

    func test_loadSections_success_setsSections() async {
        repo.result = .success(SectionsPage(title: "Home", sections: [
            Section(id: "id", title: "Title")
        ]))

        await sut.loadSections()

        XCTAssertEqual(sut.sections.count, 1)
        XCTAssertEqual(sut.sections.first?.title, "Title")
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }

    func test_loadSections_failure_setsError() async {
        enum FetchError: Error { case generic }
        repo.result = .failure(FetchError.generic)

        await sut.loadSections()

        XCTAssertNotNil(sut.errorMessage)
        XCTAssertTrue(sut.sections.isEmpty)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_initialState() {
        XCTAssertTrue(sut.sections.isEmpty)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_loadSections_multipleCalls() async {
        repo.result = .success(SectionsPage(title: "Home", sections: [
            Section(id: "id", title: "Title")
        ]))

        await sut.loadSections()
        await sut.loadSections()

        XCTAssertEqual(repo.fetchSectionsCalls, 2)
        XCTAssertEqual(sut.sections.count, 1)
    }
    
    func test_loadSections_loadingState() async {
        repo.result = .success(SectionsPage(title: "Home", sections: []))
        
        XCTAssertFalse(sut.isLoading)
        
        await sut.loadSections()
        
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_errorMessage_clearedOnSuccessfulLoad() async {
        enum FetchError: Error { case generic }
        repo.result = .failure(FetchError.generic)
        await sut.loadSections()
        
        XCTAssertNotNil(sut.errorMessage)
        
        repo.result = .success(SectionsPage(title: "Home", sections: []))
        await sut.loadSections()
        
        XCTAssertNil(sut.errorMessage)
        XCTAssertTrue(sut.sections.isEmpty)
    }
    
    func test_loadSections_withEmptySections() async {
        repo.result = .success(SectionsPage(title: "Home", sections: []))

        await sut.loadSections()

        XCTAssertTrue(sut.sections.isEmpty)
        XCTAssertNil(sut.errorMessage)
        XCTAssertFalse(sut.isLoading)
    }
    
    func test_loadSections_withMultipleSections() async {
        repo.result = .success(SectionsPage(title: "Home", sections: [
            Section(id: "1", title: "Section 1"),
            Section(id: "2", title: "Section 2"),
            Section(id: "3", title: "Section 3")
        ]))

        await sut.loadSections()

        XCTAssertEqual(sut.sections.count, 3)
        XCTAssertEqual(sut.sections[0].title, "Section 1")
        XCTAssertEqual(sut.sections[1].title, "Section 2")
        XCTAssertEqual(sut.sections[2].title, "Section 3")
    }
    
    func test_loadSections_cachesRootPageAndSections() async {
        let section1 = Section(id: "1", title: "One", href: nil, imageURL: nil, description: "Desc 1")
        let section2 = Section(id: "2", title: "Two", href: nil, imageURL: nil, description: "Desc 2")
        let sectionsPage = SectionsPage(title: "Home", description: "Root Desc", sections: [section1, section2], rootDescription: "Root Desc")
        repo.result = .success(sectionsPage)
        
        await sut.loadSections()
        
        XCTAssertEqual(sut.rootPageDescription, "Root Desc")
        XCTAssertTrue(cacheService.isSectionCached("1"))
        XCTAssertTrue(cacheService.isSectionCached("2"))
        XCTAssertEqual(cacheService.getSectionDescription(for: "1")?.description, "Desc 1")
        XCTAssertEqual(cacheService.getSectionDescription(for: "2")?.description, "Desc 2")
    }
    
    func test_getSectionDescription_and_isSectionCached_afterLoad() async {
        let section = Section(id: "abc", title: "S", href: nil, imageURL: nil, description: "D")
        repo.result = .success(SectionsPage(title: "T", description: nil, sections: [section], rootDescription: nil))
        
        await sut.loadSections()
        
        XCTAssertTrue(sut.isSectionCached("abc"))
        XCTAssertEqual(sut.getSectionDescription(for: "abc"), "D")
    }
    
    func test_parallelRefresh_doesNotLeaveIsLoadingStuck() async {
        repo.result = .success(SectionsPage(title: "Home", sections: [
            Section(id: "id", title: "Title", href: URL(string: "https://example.com/1"))
        ]))
        
        async let load1: Void = sut.loadSections()
        async let load2: Void = sut.loadSections()
        _ = await (load1, load2)
        
        XCTAssertFalse(sut.isLoading)
    }
    
    
    func test_fetchSectionDescription_200WithoutField_returnsNil() async {
        URLProtocolStub.startInterceptingRequests()
        URLProtocolStub.stub(statusCode: 200, body: Data("{}".utf8))
        
        repo.result = .success(SectionsPage(title: "Home", sections: [
            Section(id: "s1", title: "T", href: URL(string: "https://example.com/desc"))
        ]))
        
        await sut.loadSections()
        
        XCTAssertNil(sut.sections.first?.description)
        URLProtocolStub.stopInterceptingRequests()
    }
    
    func test_fetchSectionDescription_200InvalidJSON_returnsNil() async {
        URLProtocolStub.startInterceptingRequests()
        URLProtocolStub.stub(statusCode: 200, body: Data("not-json".utf8))
        
        repo.result = .success(SectionsPage(title: "Home", sections: [
            Section(id: "s1", title: "T", href: URL(string: "https://example.com/desc"))
        ]))
        
        await sut.loadSections()
        
        XCTAssertNil(sut.sections.first?.description)
        URLProtocolStub.stopInterceptingRequests()
    }
    
    func test_fetchSectionDescription_404_returnsNil() async {
        URLProtocolStub.startInterceptingRequests()
        URLProtocolStub.stub(statusCode: 404, body: Data())
        
        repo.result = .success(SectionsPage(title: "Home", sections: [
            Section(id: "s1", title: "T", href: URL(string: "https://example.com/desc"))
        ]))
        
        await sut.loadSections()
        XCTAssertNil(sut.sections.first?.description)
        URLProtocolStub.stopInterceptingRequests()
    }
    
    func test_fetchSectionDescription_timeout_returnsNil() async {
        URLProtocolStub.startInterceptingRequests()
        URLProtocolStub.stubWithError(URLError(.timedOut))
        
        repo.result = .success(SectionsPage(title: "Home", sections: [
            Section(id: "s1", title: "T", href: URL(string: "https://example.com/desc"))
        ]))
        
        await sut.loadSections()
        XCTAssertNil(sut.sections.first?.description)
        URLProtocolStub.stopInterceptingRequests()
    }
}

private final class URLProtocolStub: URLProtocol {
    private struct Stub {
        let response: HTTPURLResponse?
        let body: Data?
        let error: Error?
    }
    private static var stub: Stub?
    
    static func stub(statusCode: Int, body: Data) {
        let response = HTTPURLResponse(url: URL(string: "https://stub.local")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        stub = Stub(response: response, body: body, error: nil)
    }
    static func stubWithError(_ error: Error) {
        stub = Stub(response: nil, body: nil, error: error)
    }
    
    static func startInterceptingRequests() {
        URLProtocol.registerClass(URLProtocolStub.self)
    }
    static func stopInterceptingRequests() {
        URLProtocol.unregisterClass(URLProtocolStub.self)
        stub = nil
    }
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        if let error = URLProtocolStub.stub?.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        if let response = URLProtocolStub.stub?.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        if let body = URLProtocolStub.stub?.body {
            client?.urlProtocol(self, didLoad: body)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() { }
}
