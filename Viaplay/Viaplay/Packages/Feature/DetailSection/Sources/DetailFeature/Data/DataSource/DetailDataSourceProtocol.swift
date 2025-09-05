import Foundation
import Domain

public protocol DetailDataSourceProtocol {
    func fetchDetail(for section: ContentSection) async throws -> Domain.DetailPage
}
