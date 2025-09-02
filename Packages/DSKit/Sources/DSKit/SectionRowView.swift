import SwiftUI
import CoreKit

public struct SectionRowView: View {
    private let section: ViaplaySection

    public init(section: ViaplaySection) {
        self.section = section
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(section.title).font(.headline)
            if let description = section.description, !description.isEmpty {
                Text(description).font(.subheadline).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}


