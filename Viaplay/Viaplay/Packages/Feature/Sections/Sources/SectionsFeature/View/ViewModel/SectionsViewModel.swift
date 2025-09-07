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
            
            // Fetch descriptions for each section
            var sectionsWithDescriptions = sectionsPage.sections
            for i in 0..<sectionsWithDescriptions.count {
                if let href = sectionsWithDescriptions[i].href {
                    do {
                        let sectionDescription = try await fetchSectionDescription(from: href)
                        sectionsWithDescriptions[i] = Domain.Section(
                            id: sectionsWithDescriptions[i].id,
                            title: sectionsWithDescriptions[i].title,
                            href: sectionsWithDescriptions[i].href,
                            imageURL: sectionsWithDescriptions[i].imageURL,
                            description: sectionDescription
                        )
                        print("✅ [SectionsViewModel] Fetched description for section: \(sectionsWithDescriptions[i].title)")
                    } catch {
                        print("⚠️ [SectionsViewModel] Failed to fetch description for section \(sectionsWithDescriptions[i].title): \(error)")
                    }
                }
            }
            
            // Cache all section descriptions for offline navigation
            cacheService.cacheSections(sectionsWithDescriptions)
            
            // Update UI with animation
            withAnimation(.easeInOut(duration: 0.3)) {
                self.sections = sectionsWithDescriptions
                self.rootPageDescription = sectionsPage.rootDescription
            }
            
        } catch {
            print("❌ [SectionsViewModel] Failed to load sections: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }

        print("🏁 [SectionsViewModel] Loading completed. isLoading: \(isLoading)")
        isLoading = false
    }
    
    private func fetchSectionDescription(from href: URL) async throws -> String? {
        // Create a proper HTTP request to fetch the section description
        let urlRequest = URLRequest(url: href)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("⚠️ [SectionsViewModel] HTTP error: \(response)")
                return nil
            }
            
            // Parse the JSON response to extract description
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let description = json["description"] as? String {
                print("✅ [SectionsViewModel] Fetched real description for section")
                return description
            }
            
            print("⚠️ [SectionsViewModel] No description found in response")
            return nil
            
        } catch {
            print("❌ [SectionsViewModel] Failed to fetch section description: \(error)")
            return nil
        }
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
