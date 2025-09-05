import Foundation
import Domain

public final class SectionsRepositoryImpl: SectionsRepository {
    private let dataSource: SectionsDataSourceProtocol

    public init(dataSource: SectionsDataSourceProtocol) {
        self.dataSource = dataSource
    }

    public func fetchSections() async throws -> SectionsPage {
        try await dataSource.fetchSections()
    }
}
