import Foundation
import Domain
@testable import Sections

final class SectionsRepositorySpy: SectionsRepository {
    var fetchSectionsCalls = 0
    var result: Result<SectionsPage, Error> = .success(SectionsPage(title: "t", sections: []))
    func fetchSections() async throws -> SectionsPage {
        fetchSectionsCalls += 1
        switch result {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }
}
