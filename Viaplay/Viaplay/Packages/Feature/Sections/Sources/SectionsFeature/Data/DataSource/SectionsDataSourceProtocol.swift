import Foundation
import Domain

public protocol SectionsDataSourceProtocol {
    func fetchSections() async throws -> SectionsPage
}
