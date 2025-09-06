import SwiftUI
import Domain
import DSKit
import DetailSection

public struct SectionsListView: View {
    @StateObject private var viewModel: SectionsViewModel
    @State private var animateSections = false
    @State private var selectedSection: Domain.Section?

    public init(viewModel: SectionsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemBackground),
                        Color(.systemBackground).opacity(0.8)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                Group {
                    if viewModel.isLoading {
                        LoadingView.contentLoading()
                    } else if let errorMessage = viewModel.errorMessage {
                        DesignSystem.Components.errorView(
                            title: LocalizationKeys.Sections.errorTitle.localized,
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
            .navigationTitle("Viaplay")
            .navigationBarTitleDisplayMode(.large)
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



    private var sectionsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Header section
                VStack(alignment: .leading, spacing: 8) {
                    Text("explore.content.title".localized)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("explore.content.subtitle".localized)
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                // Sections grid
                ForEach(viewModel.sections.indices, id: \.self) { index in
                    NavigationLink(destination: DetailView(section: ContentSection(
                        title: viewModel.sections[index].title,
                        description: viewModel.sections[index].description,
                        href: viewModel.sections[index].href
                    ))) {
                        SectionRowView(
                            model: SectionRowView.Model(
                                title: viewModel.sections[index].title,
                                description: viewModel.sections[index].description
                            ),
                            onTap: {
                                selectedSection = viewModel.sections[index]
                            }
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, 20)
                    .opacity(animateSections ? 1.0 : 0.0)
                    .offset(y: animateSections ? 0 : 30)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.8)
                        .delay(Double(index) * 0.1),
                        value: animateSections
                    )
                }
                
                // Bottom padding
                Color.clear
                    .frame(height: 20)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) {
                animateSections = true
            }
        }
    }
}
