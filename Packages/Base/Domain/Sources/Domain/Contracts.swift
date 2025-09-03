import Foundation

public protocol PageRepository {
    func getRootPage() async throws -> Page
    func getPage(by url: URL) async throws -> Page
}

public protocol GetRootPageUseCase {
    func execute() async throws -> Page
}

public protocol GetPageUseCase {
    func execute(url: URL) async throws -> Page
}
