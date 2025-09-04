import Foundation

public struct GetRootPage: GetRootPageUseCase {
    private let repository: PageRepository
    public init(repository: PageRepository) { self.repository = repository }
    public func execute() async throws -> Page { try await repository.getRootPage() }
}

public struct GetPage: GetPageUseCase {
    private let repository: PageRepository
    
    public init(repository: PageRepository) {
        self.repository = repository
    }
    
    public func execute(url: URL) async throws -> Page {
        try await repository.getPage(by: url)
    }
}
