import XCTest
import SwiftUI
import SnapshotTesting
import UIKit
@testable import DetailSection
@testable import Domain

@MainActor
final class DetailViewtvOSSnapshotTests: XCTestCase {

    private var section: ContentSection!

    override func setUp() {
        super.setUp()
        section = ContentSection(title: "Test Section", description: "Test Description", href: URL(string: "https://example.com")!)
    }

    override func tearDown() {
        section = nil
        super.tearDown()
    }

    func testDetailViewtvOSWithContent() {
        let viewModel = DetailViewModel(section: section, fetchDetailUseCase: StubDetailUseCase(page: DetailPage(
            title: "Test Section",
            description: "This is a test description for the detail view",
            items: [
                DetailItem(id: "item-1", title: "Item 1", description: "Description 1", href: URL(string: "https://example.com/1")),
                DetailItem(id: "item-2", title: "Item 2", description: "Description 2", href: URL(string: "https://example.com/2")),
                DetailItem(id: "item-3", title: "Item 3", description: "Description 3", href: URL(string: "https://example.com/3"))
            ],
            navigationTitle: "Test Section"
        )))
        let view = DetailView(section: section, viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .tv))
    }

    func testDetailViewtvOSLoading() {
        let viewModel = DetailViewModel(section: section, fetchDetailUseCase: StubDetailUseCase(page: nil))
        // simulate loading state
        viewModel.isLoading = true
        let view = DetailView(section: section, viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .tv))
    }

    func testDetailViewtvOSError() {
        let viewModel = DetailViewModel(section: section, fetchDetailUseCase: FailingDetailUseCase(error: NSError(domain: "test", code: 1)))
        let view = DetailView(section: section, viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .tv))
    }

    func testDetailViewtvOSEmpty() {
        let viewModel = DetailViewModel(section: section, fetchDetailUseCase: StubDetailUseCase(page: DetailPage(
            title: "Empty Section",
            description: nil,
            items: [],
            navigationTitle: "Empty Section"
        )))
        let emptySection = ContentSection(title: "Empty Section", description: "Empty Description", href: URL(string: "https://example.com")!)
        let view = DetailView(section: emptySection, viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .tv))
    }

    func testDetailViewtvOSWithLongContent() {
        let viewModel = DetailViewModel(section: section, fetchDetailUseCase: StubDetailUseCase(page: DetailPage(
            title: "Very Long Section Title That Should Test Text Wrapping on Apple TV",
            description: "This is a very long description that should test text wrapping and layout behavior in the detail view on Apple TV. It should handle multiple lines properly and maintain good readability.",
            items: [
                DetailItem(id: "long-1", title: "Very Long Item Title That Should Test Text Wrapping", description: "Very long item description that should test text wrapping and layout behavior", href: URL(string: "https://example.com/1")),
                DetailItem(id: "long-2", title: "Another Long Item", description: "Another very long description for testing purposes", href: URL(string: "https://example.com/2"))
            ],
            navigationTitle: "Long Section"
        )))
        let longSection = ContentSection(title: "Long Section", description: "Long Description", href: URL(string: "https://example.com")!)
        let view = DetailView(section: longSection, viewModel: viewModel)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .tv))
    }

    func testDetailViewtvOSInDarkMode() {
        let viewModel = DetailViewModel(section: section, fetchDetailUseCase: StubDetailUseCase(page: DetailPage(
            title: "Dark Mode Section",
            description: "Dark mode description",
            items: [
                DetailItem(id: "dark-1", title: "Dark Item", description: "Dark description", href: URL(string: "https://example.com")!)
            ],
            navigationTitle: "Dark Section"
        )))
        let darkSection = ContentSection(title: "Dark Section", description: "Dark Description", href: URL(string: "https://example.com")!)
        let view = DetailView(section: darkSection, viewModel: viewModel)
            .preferredColorScheme(.dark)
        let vc = UIHostingController(rootView: view)
        assertSnapshot(of: vc, as: .image(on: .tv))
    }
}

// MARK: - Test Doubles
private struct StubDetailUseCase: Domain.FetchDetailUseCaseProtocol {
    let page: Domain.DetailPage?
    func execute(section: ContentSection) async throws -> Domain.DetailPage {
        if let page = page { return page }
        return Domain.DetailPage(title: section.title, description: section.description, items: [], navigationTitle: section.title)
    }
}

private struct FailingDetailUseCase: Domain.FetchDetailUseCaseProtocol {
    let error: Error
    func execute(section: ContentSection) async throws -> Domain.DetailPage {
        throw error
    }
}
