import SwiftUI
import Domain

public struct DetailItemView: View {
    let item: Domain.DetailItem

    public init(item: Domain.DetailItem) {
        self.item = item
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(item.title)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            if let description = item.description {
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }

            if let content = item.content {
                Text(content)
                    .font(.body)
                    .foregroundColor(.primary)
            }

            if !item.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(item.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
            }

            if let href = item.href {
                Link("View More", destination: href)
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(red: 0.95, green: 0.95, blue: 0.97))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
