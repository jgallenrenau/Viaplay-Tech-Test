import SwiftUI
import Domain
import DSKit
import DetailSection

public struct SectionsListViewtvOS: View {
    @StateObject private var viewModel: SectionsViewModel
    @State private var animateSections = false
    @State private var selectedSection: Domain.Section?

    public init(viewModel: SectionsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ZStack {
            // TV-optimized background
            LinearGradient(
                gradient: Gradient(colors: [
                    DSPalette.background,
                    DSPalette.background.opacity(0.9)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            Group {
                if viewModel.isLoading {
                    LoadingView()
                } else if let errorMessage = viewModel.errorMessage {
                        DesignSystem.Components.errorView(
                            title: "Oops! Something went wrong",
                            message: errorMessage,
                        retryAction: {
                            Task {
                                await viewModel.loadSections()
                            }
                        }
                    )
                } else {
                    sectionsList
                }
            }
        }
        .task {
            print("🎬 [SectionsListViewtvOS] Starting to load sections from UI...")
            await viewModel.loadSections()
            print("🎬 [SectionsListViewtvOS] UI load completed. Sections count: \(viewModel.sections.count)")
        }
        .onAppear {
            print("👁️ [SectionsListViewtvOS] View appeared. Current state - isLoading: \(viewModel.isLoading), sections: \(viewModel.sections.count), error: \(viewModel.errorMessage ?? "none")")
        }
    }

    private var sectionsList: some View {
        ScrollView {
            LazyVStack(spacing: DSSpacing.tvLarge) {
                // TV-optimized header section
                VStack(alignment: .leading, spacing: DSSpacing.tvMedium) {
                    // Show the root page description if available
                    if let rootDescription = viewModel.rootPageDescription {
                        Text(rootDescription)
                            .font(DSTypography.tvTitle)
                            .foregroundColor(DSPalette.textPrimary)
                    } else {
                        Text("Explore our content")
                            .font(DSTypography.tvTitle)
                            .foregroundColor(DSPalette.textPrimary)
                    }
                    
                    Text("Discover series, movies, sports and more")
                        .font(DSTypography.tvBody)
                        .foregroundColor(DSPalette.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, DSSpacing.tvExtraLarge)
                .padding(.top, DSSpacing.tvLarge)
                
                // TV-optimized sections grid
                ForEach(viewModel.sections.indices, id: \.self) { index in
                    NavigationLink(destination: DetailViewtvOS(domainSection: viewModel.sections[index])) {
                        DesignSystem.Components.sectionRowView(
                            title: viewModel.sections[index].title,
                            description: viewModel.sections[index].description,
                            onTap: {
                                selectedSection = viewModel.sections[index]
                            }
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, DSSpacing.tvExtraLarge)
                    .opacity(animateSections ? 1.0 : 0.0)
                    .offset(y: animateSections ? 0 : 50)
                    .animation(
                        .spring(response: 0.8, dampingFraction: 0.7)
                        .delay(Double(index) * 0.15),
                        value: animateSections
                    )
                }
                
                // Bottom padding
                Color.clear
                    .frame(height: DSSpacing.tvHuge)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.5)) {
                animateSections = true
            }
        }
    }
}
