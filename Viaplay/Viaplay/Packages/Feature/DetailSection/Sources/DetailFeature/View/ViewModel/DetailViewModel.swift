import Foundation
import SwiftUI
import Domain

@MainActor
public final class DetailViewModel: ObservableObject {
    @Published public var detailPage: Domain.DetailPage?
    @Published public var isLoading = false
    @Published public var errorMessage: String?

    private let fetchDetailUseCase: Domain.FetchDetailUseCaseProtocol
    public let section: ContentSection

    public init(
        section: ContentSection,
        fetchDetailUseCase: Domain.FetchDetailUseCaseProtocol
    ) {
        self.section = section
        self.fetchDetailUseCase = fetchDetailUseCase
    }

    public func loadDetail() async {
        print("🔄 [DetailViewModel] Starting to load detail for section: \(section.title)")
        isLoading = true
        errorMessage = nil

        do {
            print("📡 [DetailViewModel] Calling fetchDetailUseCase for section: \(section.title)")
            let detailPage = try await fetchDetailUseCase.execute(section: section)
            print("✅ [DetailViewModel] Successfully loaded detail with \(detailPage.items.count) items")
            
            // Update UI with animation
            withAnimation(.easeInOut(duration: 0.4)) {
                self.detailPage = detailPage
            }
            
        } catch {
            print("❌ [DetailViewModel] Failed to load detail for section '\(section.title)': \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }

        print("🏁 [DetailViewModel] Loading completed. isLoading: \(isLoading)")
        isLoading = false
    }
}
