import XCTest
import Data
import Domain
import NetworkingKit
import StorageKit
@testable import Sections

@MainActor
final class SectionsFactoryTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
    }
    
    func test_makeSectionsViewModel_createsViewModelWithCorrectDependencies() {
        let viewModel = SectionsFactory.makeSectionsViewModel()
        
        XCTAssertNotNil(viewModel)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.sections.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_makeSectionsViewModel_createsIndependentInstances() {
        let viewModel1 = SectionsFactory.makeSectionsViewModel()
        let viewModel2 = SectionsFactory.makeSectionsViewModel()
        
        XCTAssertNotNil(viewModel1)
        XCTAssertNotNil(viewModel2)
        
        XCTAssertNotIdentical(viewModel1, viewModel2)
    }
    
    func test_makeSectionsViewModel_hasCorrectInitialState() {
        let viewModel = SectionsFactory.makeSectionsViewModel()
        
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertTrue(viewModel.sections.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func test_makeSectionsViewModel_canLoadSections() async {
        let viewModel = SectionsFactory.makeSectionsViewModel()
        
        XCTAssertTrue(viewModel.sections.isEmpty)
        
        await viewModel.loadSections()
        
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func test_makeSectionsViewModel_hasCacheService() {
        let viewModel = SectionsFactory.makeSectionsViewModel()
        
        let testSection = Domain.Section(
            id: "test",
            title: "Test Section",
            href: URL(string: "https://example.com")!,
            description: "Test Description"
        )
        
        let description = viewModel.getSectionDescription(for: testSection.id)
        XCTAssertNil(description) // Initially should be nil
        
        let isCached = viewModel.isSectionCached(testSection.id)
        XCTAssertFalse(isCached) // Initially should not be cached
    }
    
    func test_makeSectionsViewModel_multipleCallsConsistency() {
        let viewModels = (0..<5).map { _ in SectionsFactory.makeSectionsViewModel() }
        
        for viewModel in viewModels {
            XCTAssertNotNil(viewModel)
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertTrue(viewModel.sections.isEmpty)
            XCTAssertNil(viewModel.errorMessage)
        }
        
        let uniqueViewModels = Set(viewModels.map { ObjectIdentifier($0) })
        XCTAssertEqual(uniqueViewModels.count, viewModels.count)
    }
}
