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
            let sectionsPage = try await fetchSectionsUseCase.execute()
            print("✅ [SectionsViewModel] Successfully loaded \(sectionsPage.sections.count) sections")
            sections = sectionsPage.sections
        } catch {
            print("❌ [SectionsViewModel] Failed to load sections: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }

        print("🏁 [SectionsViewModel] Loading completed. isLoading: \(isLoading)")
        isLoading = false
    }
}
