import SwiftUI
import Domain

public struct SectionsListView: View {
    @StateObject private var viewModel: SectionsViewModel

    public init(viewModel: SectionsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    loadingView
                } else if let errorMessage = viewModel.errorMessage {
                    errorView(message: errorMessage)
                } else {
                    sectionsList
                }
            }
            .navigationTitle("Sections")
            .task {
                await viewModel.loadSections()
            }
        }
    }

    private var loadingView: some View {
        ProgressView("Loading sections...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.orange)

            Text("Error")
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button("Retry") {
                Task {
                    await viewModel.loadSections()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    private var sectionsList: some View {
        List(viewModel.sections, id: \.id) { section in
            SectionRowView(section: section)
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
        }
        .listStyle(PlainListStyle())
    }
}
