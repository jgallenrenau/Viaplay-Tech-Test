import Foundation
import Domain
@testable import DetailSection

final class DetailRepositorySpy: Domain.DetailRepositoryProtocol {
    var fetchDetailCalls = 0
    var result: Result<Domain.DetailPage, Error> = .success(Domain.DetailPage(title: "t", items: []))
    
    func fetchDetail(for section: ContentSection) async throws -> Domain.DetailPage {
        fetchDetailCalls += 1
        switch result {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }
}

final class FetchDetailUseCaseSpy: Domain.FetchDetailUseCaseProtocol {
    var executeCalls = 0
    var result: Result<Domain.DetailPage, Error> = .success(Domain.DetailPage(title: "t", items: []))
    
    func execute(section: ContentSection) async throws -> Domain.DetailPage {
        executeCalls += 1
        switch result {
        case let .success(value):
            return value
        case let .failure(error):
            throw error
        }
    }
}
