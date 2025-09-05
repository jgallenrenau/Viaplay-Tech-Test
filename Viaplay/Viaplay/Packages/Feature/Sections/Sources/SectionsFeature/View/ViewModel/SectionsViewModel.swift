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
        isLoading = true
        errorMessage = nil

        do {
            let sectionsPage = try await fetchSectionsUseCase.execute()
            sections = sectionsPage.sections
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
}
