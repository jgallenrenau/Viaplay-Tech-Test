import SwiftUI

public struct SectionRowView: View {
    public struct Model: Equatable, Hashable {
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
    #if os(tvOS)
    @State private var isFocusedTV = false
    #endif

    public init(model: Model, onTap: (() -> Void)? = nil) {
        self.model = model
        self.onTap = onTap
    }

    public var body: some View {
        HStack(spacing: 16) {
            #if os(tvOS)
            // tvOS: no leading icon – clean, text-centric row
            VStack(alignment: .leading, spacing: 6) {
                Text(model.title)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(.primary)
                if let description = model.description, !description.isEmpty {
                    Text(description)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            #else
            // iOS: keep previous layout with icon
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
            #endif
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(backgroundFillColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(DSPalette.border(for: .iOS), lineWidth: 1)
                )
                .shadow(
                    color: Color.black.opacity(0.10),
                    radius: tvOSShadowRadius,
                    x: 0,
                    y: tvOSShadowY
                )
        )
        .scaleEffect(scaleEffectValue)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        #if os(tvOS)
        .focusable(true) { focused in
            isFocusedTV = focused
        }
        #endif
        #if os(tvOS)
        .onPlayPauseCommand {
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
        #else
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
        #endif
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
    
    private var backgroundFillColor: Color {
        #if os(tvOS)
        // Light background that increases on focus to pair with the system focus ring
        return Color.white.opacity(isFocusedTV ? 0.18 : 0.08)
        #else
        return DSPalette.cardBackground(for: .iOS)
        #endif
    }

    private var scaleEffectValue: CGFloat {
        #if os(tvOS)
        return isFocusedTV ? 1.03 : 1.0
        #else
        return isPressed ? 0.98 : 1.0
        #endif
    }

    private var tvOSShadowRadius: CGFloat {
        #if os(tvOS)
        return isFocusedTV ? 12 : 6
        #else
        return isPressed ? 2 : 8
        #endif
    }

    private var tvOSShadowY: CGFloat {
        #if os(tvOS)
        return isFocusedTV ? 8 : 4
        #else
        return isPressed ? 1 : 4
        #endif
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
            return DSPalette.sectionSeries
        case "filmer", "movies", "film":
            return DSPalette.sectionMovies
        case "sport":
            return DSPalette.sectionSport
        case "barn", "kids", "children":
            return DSPalette.sectionKids
        case "kanaler", "channels":
            return DSPalette.sectionChannels
        default:
            return DSPalette.brand
        }
    }
}
