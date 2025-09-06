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
                        loadingView
                    } else if let errorMessage = viewModel.errorMessage {
                        errorView(message: errorMessage)
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

    private var loadingView: some View {
        VStack(spacing: 24) {
            // Animated loading indicator
            ZStack {
                Circle()
                    .stroke(Color.blue.opacity(0.3), lineWidth: 4)
                    .frame(width: 60, height: 60)
                
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 4, lineCap: .round)
                    )
                    .frame(width: 60, height: 60)
                    .rotationEffect(.degrees(animateSections ? 360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: animateSections)
            }
            
            VStack(spacing: 8) {
                Text("Cargando contenido")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Preparando las mejores series y películas...")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            animateSections = true
        }
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 24) {
            // Error icon with animation
            ZStack {
                Circle()
                    .fill(Color.red.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.red)
            }
            .scaleEffect(animateSections ? 1.0 : 0.8)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateSections)

            VStack(spacing: 12) {
                Text("¡Ups! Algo salió mal")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                Text(message)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }

            Button(action: {
                Task {
                    await viewModel.loadSections()
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Intentar de nuevo")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .scaleEffect(animateSections ? 1.0 : 0.9)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateSections)
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            animateSections = true
        }
    }

    private var sectionsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                // Header section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Explora nuestro contenido")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("Descubre series, películas, deportes y más")
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
                        DSKit.SectionRowView(
                            model: DSKit.SectionRowView.Model(
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
