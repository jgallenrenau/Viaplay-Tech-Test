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
            SectionRowView(model: .init(title: section.title, description: section.description))
        }
        .navigationTitle(viewModel.title.isEmpty ? "Sections" : viewModel.title)
        .task { await viewModel.load() }
    }
}


