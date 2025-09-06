import Foundation
import Domain

public final class DetailRepositoryImpl: Domain.DetailRepositoryProtocol {
    private let dataSource: DetailDataSourceProtocol

    public init(dataSource: DetailDataSourceProtocol) {
        self.dataSource = dataSource
    }

    public func fetchDetail(for section: ContentSection) async throws -> Domain.DetailPage {
        try await dataSource.fetchDetail(for: section)
    }
}
