import SwiftUI
import Domain

public struct SectionRowView: View {
    let section: Domain.Section

    public init(section: Domain.Section) {
        self.section = section
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(section.title)
                .font(.headline)
                .foregroundColor(.primary)

            if let description = section.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(Color(red: 0.95, green: 0.95, blue: 0.97))
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}
