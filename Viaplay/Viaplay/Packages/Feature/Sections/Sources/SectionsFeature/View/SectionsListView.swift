import SwiftUI
import Domain
import DSKit

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
                print("🎬 [SectionsListView] Starting to load sections from UI...")
                await viewModel.loadSections()
                print("🎬 [SectionsListView] UI load completed. Sections count: \(viewModel.sections.count)")
            }
            .onAppear {
                print("👁️ [SectionsListView] View appeared. Current state - isLoading: \(viewModel.isLoading), sections: \(viewModel.sections.count), error: \(viewModel.errorMessage ?? "none")")
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
            DSKit.SectionRowView(model: DSKit.SectionRowView.Model(
                title: section.title,
                description: section.description
            ))
            .listRowInsets(EdgeInsets())
        }
        .listStyle(PlainListStyle())
    }
}
