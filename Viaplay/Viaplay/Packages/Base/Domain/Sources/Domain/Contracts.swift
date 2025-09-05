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

// MARK: - Sections Feature Contracts

public protocol SectionsRepository {
    func fetchSections() async throws -> SectionsPage
}

public protocol FetchSectionsUseCaseProtocol {
    func execute() async throws -> SectionsPage
}

// MARK: - DetailSection Feature Contracts

public protocol DetailRepositoryProtocol {
    func fetchDetail(for section: ContentSection) async throws -> DetailPage
}

public protocol FetchDetailUseCaseProtocol {
    func execute(section: ContentSection) async throws -> DetailPage
}
