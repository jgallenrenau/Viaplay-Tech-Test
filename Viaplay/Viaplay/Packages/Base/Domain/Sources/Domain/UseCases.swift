import Foundation

// MARK: - Sections Feature UseCase

public final class FetchSectionsUseCase: FetchSectionsUseCaseProtocol {
    private let repository: SectionsRepository

    public init(repository: SectionsRepository) {
        self.repository = repository
    }

    public func execute() async throws -> SectionsPage {
        print("🎯 [FetchSectionsUseCase] Executing use case...")
        let result = try await repository.fetchSections()
        print("✅ [FetchSectionsUseCase] Use case completed successfully with \(result.sections.count) sections")
        return result
    }
}

// MARK: - DetailSection Feature UseCase

public final class FetchDetailUseCase: FetchDetailUseCaseProtocol {
    private let repository: DetailRepositoryProtocol

    public init(repository: DetailRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(section: ContentSection) async throws -> DetailPage {
        print("🎯 [FetchDetailUseCase] Executing use case for section: \(section.title)")
        let result = try await repository.fetchDetail(for: section)
        print("✅ [FetchDetailUseCase] Use case completed successfully with \(result.items.count) items")
        return result
    }
}
