import SwiftUI
import Domain
import DSKit
import DetailSection

public struct SectionsListViewtvOS: View {
    @StateObject private var viewModel: SectionsViewModel
    @State private var animateSections = false
    
    public init(viewModel: SectionsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        #if os(macOS)
        VStack {
            sectionsList
        }
        #else
        NavigationStack {
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
            .navigationDestination(for: Domain.Section.self) { section in
                DetailViewtvOS(domainSection: section)
            }
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.5)) {
                    animateSections = true
                }
            }
        }
        #endif
    }
    
    private var sectionsList: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                // Header section with description
                VStack(alignment: .leading, spacing: 12) {
                    if let rootDescription = viewModel.rootPageDescription {
                        Text(rootDescription)
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(DSPalette.textPrimary)
                    } else {
                        Text("Explore our content")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(DSPalette.textPrimary)
                    }
                    
                    Text("Discover series, movies, sports and more")
                        .font(.system(size: 20, weight: .medium, design: .rounded))
                        .foregroundColor(DSPalette.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 40)
                .padding(.top, 20)
                
                // Sections grid
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 20),
                    GridItem(.flexible(), spacing: 20)
                ], spacing: 20) {
                ForEach(viewModel.sections.indices, id: \.self) { index in
                    #if os(macOS)
                    SectionRowView(
                        model: SectionRowView.Model(
                            title: viewModel.sections[index].title,
                            description: viewModel.sections[index].description
                        ),
                        onTap: {}
                    )
                    .padding(.horizontal, 20)
                    .opacity(animateSections ? 1.0 : 0.0)
                    .scaleEffect(animateSections ? 1.0 : 0.8)
                    .animation(
                        .spring(response: 0.8, dampingFraction: 0.7)
                        .delay(Double(index) * 0.15),
                        value: animateSections
                    )
                    #else
                    NavigationLink(value: viewModel.sections[index]) {
                        SectionRowView(
                            model: SectionRowView.Model(
                                title: viewModel.sections[index].title,
                                description: viewModel.sections[index].description
                            ),
                            onTap: {}
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 20)
                    .opacity(animateSections ? 1.0 : 0.0)
                    .scaleEffect(animateSections ? 1.0 : 0.8)
                    .animation(
                        .spring(response: 0.8, dampingFraction: 0.7)
                        .delay(Double(index) * 0.15),
                        value: animateSections
                    )
                    #endif
                }
                }
                .padding(.horizontal, 40)
                
                Color.clear
                    .frame(height: 40)
            }
        }
    }
}