import Foundation
import DomainKit

@MainActor
public final class SectionsViewModel: ObservableObject {
    @Published public private(set) var title: String = ""
    @Published public private(set) var descriptionText: String = ""
    @Published public private(set) var sections: [Section] = []

    private let getRootPage: GetRootPageUseCase

    public init(getRootPage: GetRootPageUseCase) {
        self.getRootPage = getRootPage
    }

    public func load() async {
        do {
            let page = try await getRootPage.execute()
            title = page.title
            descriptionText = page.description ?? ""
            sections = page.sections
        } catch {
            // Keep minimal; surface errors later
        }
    }
}


