import SwiftUI
import Domain

public struct DetailView: View {
    @StateObject private var viewModel: DetailViewModel
    @State private var animateContent = false

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
                } else if let detailPage = viewModel.detailPage {
                    detailContentView(detailPage: detailPage)
                } else {
                    emptyView
                }
            }
        }
        .navigationTitle(viewModel.detailPage?.navigationTitle ?? "Detalle")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.loadDetail()
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
                    .rotationEffect(.degrees(animateContent ? 360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: animateContent)
            }
            
            VStack(spacing: 8) {
                Text("Cargando contenido")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text("Preparando los detalles...")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            animateContent = true
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
            .scaleEffect(animateContent ? 1.0 : 0.8)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateContent)

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
                    await viewModel.loadDetail()
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
            .scaleEffect(animateContent ? 1.0 : 0.9)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: animateContent)
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            animateContent = true
        }
    }

    private func detailContentView(detailPage: Domain.DetailPage) -> some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                // Header section
                VStack(alignment: .leading, spacing: 12) {
                    Text(detailPage.title)
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    if let description = detailPage.description, !description.isEmpty {
                        Text(description)
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                // Items grid
                ForEach(Array(detailPage.items.enumerated()), id: \.element.id) { index, item in
                    DetailItemView(item: item)
                        .padding(.horizontal, 20)
                        .opacity(animateContent ? 1.0 : 0.0)
                        .offset(y: animateContent ? 0 : 30)
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.8)
                            .delay(Double(index) * 0.1),
                            value: animateContent
                        )
                }
                
                // Bottom padding
                Color.clear
                    .frame(height: 20)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) {
                animateContent = true
            }
        }
    }

    private var emptyView: some View {
        VStack(spacing: 24) {
            // Empty state icon
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 80, height: 80)
                
                Image(systemName: "doc.text.fill")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(.gray)
            }
            .scaleEffect(animateContent ? 1.0 : 0.8)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateContent)

            VStack(spacing: 12) {
                Text("No hay contenido disponible")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)

                Text("Esta sección no tiene elementos para mostrar en este momento.")
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            animateContent = true
        }
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
