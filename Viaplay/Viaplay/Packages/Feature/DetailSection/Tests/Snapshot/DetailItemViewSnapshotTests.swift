import XCTest
import SnapshotTesting
import Domain
@testable import DetailSection
import SwiftUI

@MainActor
final class DetailItemViewSnapshotTests: XCTestCase {
    private let record = false
    
    private func makeVC<T: View>(_ view: T, dark: Bool = false, traits: UITraitCollection? = nil, size: CGSize = CGSize(width: 390, height: 200)) -> UIViewController {
        let v = dark ? AnyView(view.preferredColorScheme(.dark)) : AnyView(AnyView(view))
        let vc = UIHostingController(rootView: v)
        vc.view.frame = CGRect(origin: .zero, size: size)
        if let traits { vc.setOverrideTraitCollection(traits, forChild: vc) }
        return vc
    }
    
    func test_item_variants_light_dark_dynamicType() {
        let base = DetailItem(
            id: "1",
            title: String(repeating: "Title ", count: 5),
            description: "Desc",
            href: URL(string: "https://example.com"),
            imageURL: nil,
            content: String(repeating: "Content ", count: 10),
            publishedDate: nil,
            tags: ["a","b","c"]
        )
        let view = DetailItemView(item: base)
        assertSnapshot(of: makeVC(view), as: .image, record: isRecording)
        assertSnapshot(of: makeVC(view, dark: true), as: .image, record: isRecording)
        let traits = UITraitCollection(preferredContentSizeCategory: .accessibilityExtraExtraExtraLarge)
        assertSnapshot(of: makeVC(view, traits: traits), as: .image, record: isRecording)
    }
    
    func test_item_without_tags_or_href() {
        let item = DetailItem(id: "2", title: "Simple", description: nil, href: nil, imageURL: nil, content: "Short")
        let view = DetailItemView(item: item)
        assertSnapshot(of: makeVC(view, size: CGSize(width: 390, height: 120)), as: .image, record: isRecording)
    }
}
