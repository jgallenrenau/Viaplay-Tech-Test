import SwiftUI
import DomainKit
import DSKit

public struct SectionsListView: View {
    @StateObject private var viewModel: SectionsViewModel

    public init(viewModel: SectionsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        List(viewModel.sections, id: \.title) { section in
            SectionRowView(section: .init(title: section.title, description: section.description, href: section.href))
        }
        .navigationTitle(viewModel.title.isEmpty ? "Sections" : viewModel.title)
        .task { await viewModel.load() }
    }
}


