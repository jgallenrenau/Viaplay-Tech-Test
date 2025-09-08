import SwiftUI
import Domain
import DSKit

public struct DetailViewtvOS: View {
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
    
    public init(domainSection: Domain.Section, viewModel: DetailViewModel? = nil) {
        let contentSection = ContentSection(
            title: domainSection.title,
            description: domainSection.description,
            href: domainSection.href
        )
        if let viewModel = viewModel {
            self._viewModel = StateObject(wrappedValue: viewModel)
        } else {
            self._viewModel = StateObject(wrappedValue: DetailFactory.makeDetailViewModel(for: contentSection))
        }
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: DSSpacing.tvExtraLarge) {
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
            .padding(.horizontal, DSSpacing.tvExtraLarge)
            .padding(.vertical, DSSpacing.tvExtraLarge)
        }
        .task {
            await viewModel.loadDetail()
        }
    }

    private func detailContentView(detailPage: Domain.DetailPage) -> some View {
        VStack(alignment: .leading, spacing: DSSpacing.tvExtraLarge) {
            // TV-optimized title
            Text(detailPage.title)
                .font(DSTypography.tvTitle)
                .foregroundColor(DSPalette.textPrimary)
                .multilineTextAlignment(.leading)

            // TV-optimized description - Show section description from cache if available
            if let sectionDescription = viewModel.section.description, !sectionDescription.isEmpty {
                Text(sectionDescription)
                    .font(DSTypography.tvBody)
                    .foregroundColor(DSPalette.textSecondary)
                    .multilineTextAlignment(.leading)
            } else if let detailDescription = detailPage.description, !detailDescription.isEmpty {
                Text(detailDescription)
                    .font(DSTypography.tvBody)
                    .foregroundColor(DSPalette.textSecondary)
                    .multilineTextAlignment(.leading)
            }

            // Section icon chip under description (tvOS) - single source of truth for the section name
            HStack(spacing: DSSpacing.tvSmall) {
                Image(systemName: iconForSection(viewModel.section.title))
                    .font(DSTypography.tvBody)
                    .foregroundColor(colorForSection(viewModel.section.title))
                Text(detailPage.title.isEmpty ? viewModel.section.title : detailPage.title)
                    .font(DSTypography.tvBody)
                    .foregroundColor(DSPalette.textPrimary)
            }
            .padding(.horizontal, DSSpacing.tvLarge)
            .padding(.vertical, DSSpacing.tvMedium)
            .background(
                Capsule().fill(colorForSection(viewModel.section.title).opacity(0.12))
            )
            .frame(maxWidth: .infinity, alignment: .leading)

            // TV-optimized metadata row
            HStack(spacing: DSSpacing.tvMedium) {
                // Items count chip
                if !detailPage.items.isEmpty {
                    HStack(spacing: DSSpacing.tvSmall) {
                        Image(systemName: "list.bullet")
                            .font(DSTypography.tvBody)
                        Text("\(detailPage.items.count)")
                            .font(DSTypography.tvBody)
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal, DSSpacing.tvLarge)
                    .padding(.vertical, DSSpacing.tvMedium)
                    .background(
                        Capsule().fill(DSPalette.tvAccent)
                    )
                    .foregroundColor(DSPalette.brand)
                }

                // Category chip (if provided)
                if let navTitle = detailPage.navigationTitle, !navTitle.isEmpty {
                    HStack(spacing: DSSpacing.tvSmall) {
                        Image(systemName: "folder")
                            .font(DSTypography.tvBody)
                        Text(navTitle)
                            .font(DSTypography.tvBody)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal, DSSpacing.tvLarge)
                    .padding(.vertical, DSSpacing.tvMedium)
                    .background(
                        Capsule().fill(DSPalette.tvHighlight)
                    )
                    .foregroundColor(DSPalette.brand)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DSSpacing.tvExtraLarge)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(DSPalette.tvCardBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(DSPalette.tvBorder, lineWidth: 2)
                )
                .shadow(
                    color: DSPalette.tvGlow,
                    radius: 20,
                    x: 0,
                    y: 10
                )
        )
    }

    private var emptyView: some View {
        VStack(spacing: DSSpacing.tvLarge) {
            Image(systemName: "doc.text")
                .font(.system(size: 96))
                .foregroundColor(.gray)
            
            Text("No content available")
                .font(DSTypography.tvTitle)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("This section has no items to display.")
                .font(DSTypography.tvBody)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(DSSpacing.tvExtraLarge)
    }
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
