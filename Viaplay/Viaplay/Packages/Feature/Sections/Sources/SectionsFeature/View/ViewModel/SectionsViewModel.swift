import Foundation
import Domain
import SwiftUI

@MainActor
public final class SectionsViewModel: ObservableObject {
    @Published public var sections: [Domain.Section] = []
    @Published public var isLoading = false
    @Published public var errorMessage: String?

    private let fetchSectionsUseCase: FetchSectionsUseCaseProtocol

    public init(fetchSectionsUseCase: FetchSectionsUseCaseProtocol) {
        self.fetchSectionsUseCase = fetchSectionsUseCase
    }

    public func loadSections() async {
        print("🔄 [SectionsViewModel] Starting to load sections...")
        isLoading = true
        errorMessage = nil

        do {
            print("📡 [SectionsViewModel] Calling fetchSectionsUseCase...")
            
            // Use concurrency manager for controlled execution
            let sectionsPage = try await ConcurrencyManager.shared.execute {
                try await self.fetchSectionsUseCase.execute()
            }
            
            print("✅ [SectionsViewModel] Successfully loaded \(sectionsPage.sections.count) sections")
            
            // Update UI on main thread with animation (thread-safe)
            await withAnimation(.easeInOut(duration: 0.3)) {
                self.sections = sectionsPage.sections
            }
            
            // Prefetch detail data for better UX (non-blocking)
            Task.detached { [weak self] in
                await self?.prefetchDetailData(for: sectionsPage.sections)
            }
            
        } catch {
            print("❌ [SectionsViewModel] Failed to load sections: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }

        print("🏁 [SectionsViewModel] Loading completed. isLoading: \(isLoading)")
        isLoading = false
    }
    
    /// Prefetch detail data for sections to improve navigation performance
    private func prefetchDetailData(for sections: [Domain.Section]) async {
        print("🚀 [SectionsViewModel] Starting parallel prefetch for \(sections.count) sections...")
        
        await withTaskGroup(of: Void.self) { group in
            for section in sections.prefix(3) { // Prefetch first 3 sections
                group.addTask {
                    await self.prefetchSectionDetail(section)
                }
            }
        }
        
        print("✅ [SectionsViewModel] Prefetch completed")
    }
    
    /// Prefetch individual section detail data
    private func prefetchSectionDetail(_ section: Domain.Section) async {
        guard let href = section.href else { return }
        
        do {
            print("🔍 [SectionsViewModel] Prefetching detail for: \(section.title)")
            // Here we could prefetch detail data or cache it
            // For now, we'll just simulate the prefetch
            try await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
            print("✅ [SectionsViewModel] Prefetched detail for: \(section.title)")
        } catch {
            print("⚠️ [SectionsViewModel] Failed to prefetch detail for \(section.title): \(error)")
        }
    }
}
