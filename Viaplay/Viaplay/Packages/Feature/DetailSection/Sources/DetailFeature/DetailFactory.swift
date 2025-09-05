import Data
import Domain
import Foundation
import NetworkingKit
import StorageKit

public final class DetailFactory {
    @MainActor public static func makeDetailViewModel(for section: ContentSection) -> DetailViewModel {
        let pageRepository = PageRepositoryImpl(
            http: URLSessionHTTPClient(),
            cache: FileJSONDiskCache(),
            etagStore: UserDefaultsStore()
        )

        let dataSource = DetailDataSource(pageRepository: pageRepository)
        let repository: Domain.DetailRepositoryProtocol = DetailRepositoryImpl(dataSource: dataSource)
        let useCase = Domain.FetchDetailUseCase(repository: repository)

        return DetailViewModel(section: section, fetchDetailUseCase: useCase)
    }
}
