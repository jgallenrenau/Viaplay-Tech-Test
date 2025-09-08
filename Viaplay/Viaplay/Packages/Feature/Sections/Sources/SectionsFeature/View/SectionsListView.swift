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
        #if os(macOS)
        VStack {
            sectionsList
        }
        #else
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        DSPalette.background,
                        DSPalette.background.opacity(0.8)
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
                print("🎬 [SectionsListView] Starting to load sections from UI...")
                await viewModel.loadSections()
                print("🎬 [SectionsListView] UI load completed. Sections count: \(viewModel.sections.count)")
            }
            .onAppear {
                print("👁️ [SectionsListView] View appeared. Current state - isLoading: \(viewModel.isLoading), sections: \(viewModel.sections.count), error: \(viewModel.errorMessage ?? "none")")
            }
            .navigationDestination(isPresented: Binding(
                get: { selectedSection != nil },
                set: { if !$0 { selectedSection = nil } }
            )) {
                if let section = selectedSection {
                    DetailView(domainSection: section)
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) {
                    animateSections = true
                }
            }
        }
        #endif
    }

    private var sectionsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    if let rootDescription = viewModel.rootPageDescription {
                        Text(rootDescription)
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(DSPalette.textPrimary)
                    } else {
                        Text("Explore our content")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(DSPalette.textPrimary)
                    }
                    
                    Text("Discover series, movies, sports and more")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(DSPalette.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                ForEach(viewModel.sections.indices, id: \.self) { index in
                    SectionRowView(
                        model: SectionRowView.Model(
                            title: viewModel.sections[index].title,
                            description: viewModel.sections[index].description
                        ),
                        onTap: {
                            selectedSection = viewModel.sections[index]
                        }
                    )
                    .padding(.horizontal, 20)
                    .opacity(animateSections ? 1.0 : 0.0)
                    .offset(y: animateSections ? 0 : 30)
                    .animation(
                        .spring(response: 0.6, dampingFraction: 0.8)
                        .delay(Double(index) * 0.1),
                        value: animateSections
                    )
                }
                
                Color.clear
                    .frame(height: 20)
            }
        }
    }
}