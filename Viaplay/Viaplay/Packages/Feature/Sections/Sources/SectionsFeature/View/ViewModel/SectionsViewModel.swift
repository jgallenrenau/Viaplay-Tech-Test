import Foundation
import Domain
import SwiftUI

@MainActor
public final class SectionsViewModel: ObservableObject {
    @Published public var sections: [Domain.Section] = []
    @Published public var isLoading = false
    @Published public var errorMessage: String?
    @Published public var rootPageDescription: String?

    private let fetchSectionsUseCase: FetchSectionsUseCaseProtocol
    private let cacheService: SectionDescriptionCacheService

    public init(fetchSectionsUseCase: FetchSectionsUseCaseProtocol, cacheService: SectionDescriptionCacheService) {
        self.fetchSectionsUseCase = fetchSectionsUseCase
        self.cacheService = cacheService
        self.rootPageDescription = cacheService.getRootPageDescription()?.description
    }

    public func loadSections() async {
        print("🔄 [SectionsViewModel] Starting to load sections...")
        isLoading = true
        errorMessage = nil

        do {
            print("📡 [SectionsViewModel] Calling fetchSectionsUseCase...")
            
            let sectionsPage = try await fetchSectionsUseCase.execute()
            
            print("✅ [SectionsViewModel] Successfully loaded \(sectionsPage.sections.count) sections")
            
            // Cache the root page description
            cacheService.cacheRootPage(
                title: sectionsPage.title,
                description: sectionsPage.rootDescription
            )
            
            // Cache all section descriptions for offline navigation
            cacheService.cacheSections(sectionsPage.sections)
            
            // Update UI with animation
            withAnimation(.easeInOut(duration: 0.3)) {
                self.sections = sectionsPage.sections
                self.rootPageDescription = sectionsPage.rootDescription
            }
            
        } catch {
            print("❌ [SectionsViewModel] Failed to load sections: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }

        print("🏁 [SectionsViewModel] Loading completed. isLoading: \(isLoading)")
        isLoading = false
    }
    
    /// Gets the description of a specific section from cache
    public func getSectionDescription(for sectionId: String) -> String? {
        return cacheService.getSectionDescription(for: sectionId)?.description
    }
    
    /// Checks if a section is cached
    public func isSectionCached(_ sectionId: String) -> Bool {
        return cacheService.isSectionCached(sectionId)
    }
}
