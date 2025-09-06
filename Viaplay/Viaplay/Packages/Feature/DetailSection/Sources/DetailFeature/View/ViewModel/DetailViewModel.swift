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
            await withAnimation(.easeInOut(duration: 0.4)) {
                self.detailPage = detailPage
            }
            
            // Preload related content if available
            await preloadRelatedContent(detailPage)
            
        } catch {
            print("❌ [DetailViewModel] Failed to load detail for section '\(section.title)': \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }

        print("🏁 [DetailViewModel] Loading completed. isLoading: \(isLoading)")
        isLoading = false
    }
    
    /// Preload related content for better user experience
    private func preloadRelatedContent(_ detailPage: Domain.DetailPage) async {
        print("🚀 [DetailViewModel] Starting parallel preload for related content...")
        
        await withTaskGroup(of: Void.self) { group in
            // Preload images for items
            for item in detailPage.items.prefix(5) {
                group.addTask {
                    await self.preloadItemImage(item)
                }
            }
            
            // Preload additional metadata
            group.addTask {
                await self.preloadMetadata(detailPage)
            }
        }
        
        print("✅ [DetailViewModel] Preload completed")
    }
    
    /// Preload image for a detail item
    private func preloadItemImage(_ item: Domain.DetailItem) async {
        // Simulate image preloading
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds
        print("🖼️ [DetailViewModel] Preloaded image for: \(item.title)")
    }
    
    /// Preload additional metadata
    private func preloadMetadata(_ detailPage: Domain.DetailPage) async {
        // Simulate metadata preloading
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        print("📊 [DetailViewModel] Preloaded metadata for: \(detailPage.navigationTitle)")
    }
}
