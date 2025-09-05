import Foundation
import SwiftUI
import Domain

@MainActor
public final class DetailViewModel: ObservableObject {
    @Published public var detailPage: Domain.DetailPage?
    @Published public var isLoading = false
    @Published public var errorMessage: String?

    private let fetchDetailUseCase: Domain.FetchDetailUseCaseProtocol
    private let section: ContentSection

    public init(
        section: ContentSection,
        fetchDetailUseCase: Domain.FetchDetailUseCaseProtocol
    ) {
        self.section = section
        self.fetchDetailUseCase = fetchDetailUseCase
    }

    public func loadDetail() async {
        isLoading = true
        errorMessage = nil

        do {
            let detailPage = try await fetchDetailUseCase.execute(section: section)
            self.detailPage = detailPage
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
