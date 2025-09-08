import SwiftUI
import Domain

#if canImport(UIKit)
import UIKit
#endif

public struct EnhancedDetailItemView: View {
    let item: Domain.DetailItem
    @State private var isPressed = false
    @State private var showFullDescription = false
    
    public init(item: Domain.DetailItem) {
        self.item = item
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with title and metadata
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(showFullDescription ? nil : 2)
                        
                        if let description = item.description, !description.isEmpty {
                            Text(description)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                                .lineLimit(showFullDescription ? nil : 3)
                        }
                    }
                    
                    Spacer()
                    
                    // Item type indicator
                    VStack(spacing: 4) {
                        Image(systemName: iconForItem)
                            .font(.title3)
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(
                                Circle()
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [.blue, .purple]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                            )
                        
                        Text(itemType)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Content preview
                if let content = item.content, !content.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Contenido:")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                        
                        Text(content)
                            .font(.body)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(showFullDescription ? nil : 4)
                    }
                    .padding(.top, 8)
                }
            }
            
            // Tags section
            if !item.tags.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Etiquetas:")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 80), spacing: 8)
                    ], spacing: 8) {
                        ForEach(item.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(LinearGradient(
                                            gradient: Gradient(colors: [.orange, .red]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ))
                                )
                        }
                    }
                }
            }
            
            // Action buttons
            HStack(spacing: 12) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showFullDescription.toggle()
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: showFullDescription ? "eye.slash" : "eye")
                            .font(.caption)
                        Text(showFullDescription ? "Show less" : "Show more")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.blue.opacity(0.1))
                    )
                }
                
                if let href = item.href {
                    Button(action: {
                        // Handle link action
                        if let url = URL(string: href.absoluteString) {
                            #if canImport(UIKit) && !os(tvOS)
                            UIApplication.shared.open(url)
                            #endif
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "link")
                                .font(.caption)
                            Text("Abrir")
                                .font(.caption)
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.green)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.green.opacity(0.1))
                        )
                    }
                }
                
                Spacer()
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundFillColor)
                .shadow(
                    color: isPressed ? Color.black.opacity(0.1) : Color.black.opacity(0.15),
                    radius: isPressed ? 4 : 12,
                    x: 0,
                    y: isPressed ? 2 : 6
                )
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = false
                }
            }
        }
    }
    
    // MARK: - Helper Properties
    
    private var backgroundFillColor: Color {
        #if os(tvOS)
        return Color.black
        #elseif os(iOS)
        return Color(.systemGroupedBackground)
        #else
        return Color.gray.opacity(0.1)
        #endif
    }
    
    private var iconForItem: String {
        if let content = item.content, !content.isEmpty {
            return "doc.text"
        } else if !item.tags.isEmpty {
            return "tag"
        } else {
            return "doc"
        }
    }
    
    private var itemType: String {
        if let content = item.content, !content.isEmpty {
            return "Documento"
        } else if !item.tags.isEmpty {
            return "Etiquetado"
        } else {
            return "Item"
        }
    }
}

// MARK: - Preview
#Preview {
    VStack {
        EnhancedDetailItemView(item: Domain.DetailItem(
            id: "1",
            title: "Example Item",
            description: "This is an example description to show how the enhanced component looks.",
            href: URL(string: "https://example.com"), content: "Additional content that can be very long and show more information about the item.",
            tags: ["iOS", "SwiftUI", "Example", "Demo"]
        ))
        
        Spacer()
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
