import SwiftUI
import Domain

public struct DetailView: View {
    @StateObject private var viewModel: DetailViewModel

    public init(section: ContentSection, viewModel: DetailViewModel? = nil) {
        if let viewModel = viewModel {
            self._viewModel = StateObject(wrappedValue: viewModel)
        } else {
            // This will be used for previews or when no specific ViewModel is provided
            self._viewModel = StateObject(wrappedValue: DetailViewModel(
                section: section,
                fetchDetailUseCase: DummyDetailUseCase()
            ))
        }
    }

    public var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    loadingView
                } else if let errorMessage = viewModel.errorMessage {
                    errorView(message: errorMessage)
                } else if let detailPage = viewModel.detailPage {
                    detailContentView(detailPage: detailPage)
                } else {
                    emptyView
                }
            }
            .navigationTitle(viewModel.detailPage?.navigationTitle ?? "Detail")
            .task {
                await viewModel.loadDetail()
            }
        }
    }

    private var loadingView: some View {
        ProgressView("Loading details...")
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
                    await viewModel.loadDetail()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }

    private func detailContentView(detailPage: Domain.DetailPage) -> some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(detailPage.items, id: \.id) { item in
                    DetailItemView(item: item)
                }
            }
            .padding()
        }
    }

    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text")
                .font(.largeTitle)
                .foregroundColor(.gray)

            Text("No details available")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Dummy UseCase for Previews

private struct DummyDetailUseCase: Domain.FetchDetailUseCaseProtocol {
    func execute(section: ContentSection) async throws -> Domain.DetailPage {
        Domain.DetailPage(
            title: section.title,
            description: section.description,
            items: [],
            navigationTitle: section.title
        )
    }
}
