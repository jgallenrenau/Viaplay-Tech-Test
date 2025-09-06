import SwiftUI

public struct SectionRowView: View {
    public struct Model: Equatable {
        public let title: String
        public let description: String?
        public init(title: String, description: String? = nil) {
            self.title = title
            self.description = description
        }
    }

    private let model: Model
    private let onTap: (() -> Void)?
    @State private var isPressed = false

    public init(model: Model, onTap: (() -> Void)? = nil) {
        self.model = model
        self.onTap = onTap
    }

    public var body: some View {
        HStack(spacing: 16) {
            // Icon based on section type
            iconView
            
            VStack(alignment: .leading, spacing: 6) {
                Text(model.title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                
                if let description = model.description, !description.isEmpty {
                    Text(description)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            // Arrow indicator
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.secondary)
                .opacity(0.6)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
                .shadow(
                    color: Color.black.opacity(0.05),
                    radius: isPressed ? 2 : 8,
                    x: 0,
                    y: isPressed ? 1 : 4
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
                onTap?()
            }
        }
    }
    
    private var iconView: some View {
        let iconName = iconForSection(model.title)
        let iconColor = colorForSection(model.title)
        
        return ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(iconColor.opacity(0.15))
                .frame(width: 48, height: 48)
            
            Image(systemName: iconName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(iconColor)
        }
    }
    
    private func iconForSection(_ title: String) -> String {
        switch title.lowercased() {
        case "serier", "series":
            return "tv.fill"
        case "filmer", "movies", "film":
            return "film.fill"
        case "sport":
            return "sportscourt.fill"
        case "barn", "kids", "children":
            return "figure.and.child.holdinghands"
        case "kanaler", "channels":
            return "tv.and.hifispeaker.fill"
        default:
            return "play.rectangle.fill"
        }
    }
    
    private func colorForSection(_ title: String) -> Color {
        switch title.lowercased() {
        case "serier", "series":
            return .purple
        case "filmer", "movies", "film":
            return .blue
        case "sport":
            return .green
        case "barn", "kids", "children":
            return .orange
        case "kanaler", "channels":
            return .red
        default:
            return .indigo
        }
    }
}
