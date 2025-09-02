import SwiftUI
import CoreKit

public struct DetailView: View {
    private let section: ViaplaySection

    public init(section: ViaplaySection) {
        self.section = section
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(section.title).font(.largeTitle)
            if let description = section.description { Text(description) }
            if let href = section.href { Text(href.absoluteString).font(.footnote).foregroundStyle(.secondary) }
            Spacer()
        }
        .padding()
        .navigationTitle(section.title)
    }
}


