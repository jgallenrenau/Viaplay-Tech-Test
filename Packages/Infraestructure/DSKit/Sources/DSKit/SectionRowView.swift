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

    public init(model: Model) {
        self.model = model
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(model.title).font(.headline)
            if let description = model.description, !description.isEmpty {
                Text(description).font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}
