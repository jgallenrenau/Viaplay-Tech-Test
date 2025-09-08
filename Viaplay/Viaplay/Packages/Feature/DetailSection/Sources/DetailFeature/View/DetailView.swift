import SwiftUI
import Domain
import DSKit

public struct DetailView: View {
    @StateObject private var viewModel: DetailViewModel
    private let autoLoad: Bool

    public init(section: ContentSection, viewModel: DetailViewModel? = nil) {
        if let viewModel = viewModel {
            self._viewModel = StateObject(wrappedValue: viewModel)
            self.autoLoad = false
        } else {
            // This will be used for previews or when no specific ViewModel is provided
            self._viewModel = StateObject(wrappedValue: DetailViewModel(
                section: section,
                fetchDetailUseCase: DummyDetailUseCase()
            ))
            self.autoLoad = true
        }
    }
    
    public init(domainSection: Domain.Section, viewModel: DetailViewModel? = nil) {
        let contentSection = ContentSection(
            title: domainSection.title,
            description: domainSection.description,
            href: domainSection.href
        )
        if let viewModel = viewModel {
            self._viewModel = StateObject(wrappedValue: viewModel)
            self.autoLoad = false
        } else {
            self._viewModel = StateObject(wrappedValue: DetailFactory.makeDetailViewModel(for: contentSection))
            self.autoLoad = true
        }
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.extraLarge(for: .iOS)) {
                // Content based on state
                Group {
                    if viewModel.isLoading {
                        LoadingView()
                    } else if let errorMessage = viewModel.errorMessage {
                        DesignSystem.Components.errorView(
                            title: "Oops! Something went wrong",
                            message: errorMessage,
                            retryAction: {
                                Task {
                                    await viewModel.loadDetail()
                                }
                            }
                        )
                    } else if let detailPage = viewModel.detailPage {
                        detailContentView(detailPage: detailPage)
                    } else {
                        emptyView
                    }
                }
            }
            .padding(.horizontal, DSSpacing.extraLarge(for: .iOS))
            .padding(.vertical, DSSpacing.extraLarge(for: .iOS))
        }
        #if !os(tvOS)
        .navigationTitle("")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        #endif
        .task {
            if autoLoad {
                await viewModel.loadDetail()
            }
        }
    }

    private func detailContentView(detailPage: Domain.DetailPage) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.extraLarge(for: .iOS)) {
            // Title
            Text(detailPage.title)
                .font(DSTypography.title(for: .iOS))
                .foregroundColor(DSPalette.textPrimary)
                .multilineTextAlignment(.leading)

            // Description - Show section description from cache if available
            if let sectionDescription = viewModel.section.description, !sectionDescription.isEmpty {
                Text(sectionDescription)
                    .font(DSTypography.body(for: .iOS))
                    .foregroundColor(DSPalette.textSecondary)
                    .multilineTextAlignment(.leading)
            } else if let detailDescription = detailPage.description, !detailDescription.isEmpty {
                Text(detailDescription)
                    .font(DSTypography.body(for: .iOS))
                    .foregroundColor(DSPalette.textSecondary)
                    .multilineTextAlignment(.leading)
            }

            // Section icon chip under description
            HStack(spacing: 8) {
                Image(systemName: iconForSection(viewModel.section.title))
                    .font(.subheadline)
                    .foregroundColor(colorForSection(viewModel.section.title))
                Text(viewModel.section.title)
                    .font(.subheadline)
                    .foregroundColor(DSPalette.textPrimary)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule().fill(colorForSection(viewModel.section.title).opacity(0.12))
            )
            .frame(maxWidth: .infinity, alignment: .leading)

            // Lightweight metadata row
            HStack(spacing: DSSpacing.medium(for: .iOS)) {
                // Items count chip
                if !detailPage.items.isEmpty {
                    HStack(spacing: DSSpacing.extraSmall(for: .iOS)) {
                        Image(systemName: "list.bullet")
                            .font(.subheadline)
                        Text("\(detailPage.items.count)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, DSSpacing.small(for: .iOS))
                    .padding(.vertical, DSSpacing.extraSmall(for: .iOS))
                    .background(
                        Capsule().fill(DSPalette.brand.opacity(0.12))
                    )
                    .foregroundColor(DSPalette.brand)
                }

                // Category chip (if provided)
                if let navTitle = detailPage.navigationTitle, !navTitle.isEmpty {
                    HStack(spacing: 6) {
                        Image(systemName: "folder")
                            .font(.subheadline)
                        Text(navTitle)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule().fill(Color.purple.opacity(0.12))
                    )
                    .foregroundColor(.purple)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(DSPalette.cardBackground(for: .iOS))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }

    // MARK: - Helpers for section icon/color (match list style)
    private func iconForSection(_ title: String) -> String {
        switch title.lowercased() {
        case "serier", "series": return "tv.fill"
        case "filmer", "movies", "film": return "film.fill"
        case "sport": return "sportscourt.fill"
        case "barn", "kids", "children": return "figure.and.child.holdinghands"
        case "kanaler", "channels": return "tv.and.hifispeaker.fill"
        default: return "play.rectangle.fill"
        }
    }

    private func colorForSection(_ title: String) -> Color {
        switch title.lowercased() {
        case "serier", "series": return DSPalette.sectionSeries
        case "filmer", "movies", "film": return DSPalette.sectionMovies
        case "sport": return DSPalette.sectionSport
        case "barn", "kids", "children": return DSPalette.sectionKids
        case "kanaler", "channels": return DSPalette.sectionChannels
        default: return DSPalette.brand
        }
    }


    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text("No content available")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("This section has no items to display.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
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
