import SwiftUI
import Domain
import DSKit


public struct DetailItemView: View {
    let item: Domain.DetailItem
    @State private var isPressed = false

    public init(item: Domain.DetailItem) {
        self.item = item
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DSSpacing.large) {
            // Header with icon and title
            HStack(alignment: .top, spacing: DSSpacing.medium) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "play.rectangle.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: DSSpacing.extraSmall) {
                    Text(item.title)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .lineLimit(2)
                    
                    if let description = item.description {
                        Text(description)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                            .lineLimit(3)
                    }
                }
                
                Spacer()
            }

            // Content section
            if let content = item.content {
                VStack(alignment: .leading, spacing: DSSpacing.small) {
                    textWithTracking("Contenido", size: 14, weight: .semibold, design: .rounded, color: .primary, uppercase: true)
                    
                    Text(content)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(.primary)
                        .lineLimit(4)
                }
                .padding(.vertical, DSSpacing.small)
                .padding(.horizontal, DSSpacing.medium)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(contentBackgroundColor)
                )
            }

            // Tags section
            if !item.tags.isEmpty {
                VStack(alignment: .leading, spacing: DSSpacing.small) {
                    textWithTracking("Etiquetas", size: 14, weight: .semibold, design: .rounded, color: .primary, uppercase: true)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: DSSpacing.small) {
                            ForEach(item.tags, id: \.self) { tag in
                                Text(tag)
                                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                                    .padding(.horizontal, DSSpacing.medium)
                                    .padding(.vertical, DSSpacing.extraSmall)
                                    .background(
                                        Capsule()
                                            .fill(LinearGradient(
                                                gradient: Gradient(colors: [.blue, .purple]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            ))
                                    )
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal, DSSpacing.extraSmall)
                    }
                }
            }

            // Action button
            if item.href != nil {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        // Handle link tap
                    }) {
                        HStack(spacing: DSSpacing.extraSmall) {
                            Image(systemName: "arrow.up.right.square.fill")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Show more")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, DSSpacing.large)
                        .padding(.vertical, DSSpacing.small)
                        .background(
                            Capsule()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [.blue, .purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ))
                        )
                        .shadow(color: .blue.opacity(0.3), radius: 4, x: 0, y: 2)
                    }
                    .scaleEffect(isPressed ? 0.95 : 1.0)
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
            }
        }
        .padding(DSSpacing.extraLarge)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(cardBackgroundColor)
                .shadow(
                    color: Color.black.opacity(0.05),
                    radius: isPressed ? 2 : 8,
                    x: 0,
                    y: isPressed ? 1 : 4
                )
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
    }

    private var contentBackgroundColor: Color {
        #if os(tvOS)
        return Color.gray.opacity(0.2)
        #elseif os(iOS)
        return Color(.systemGray6)
        #else
        return Color.gray.opacity(0.2)
        #endif
    }

    private var cardBackgroundColor: Color {
        #if os(tvOS)
        return Color.black
        #elseif os(iOS)
        return Color(.systemBackground)
        #else
        return Color.white
        #endif
    }
    
    private func textWithTracking(_ text: String, size: CGFloat, weight: Font.Weight, design: Font.Design, color: Color, uppercase: Bool = false) -> some View {
        let baseView = Text(text)
            .font(.system(size: size, weight: weight, design: design))
            .foregroundColor(color)
        
        let uppercasedView = uppercase ? AnyView(baseView.textCase(.uppercase)) : AnyView(baseView)
        
        #if os(macOS)
        return uppercasedView
        #else
        return AnyView(uppercasedView.tracking(0.5))
        #endif
    }
}
