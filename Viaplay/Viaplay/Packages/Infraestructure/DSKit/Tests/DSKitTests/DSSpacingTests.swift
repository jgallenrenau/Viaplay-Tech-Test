import XCTest
import CoreGraphics
@testable import DSKit

final class DSSpacingTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
    }
    
    
    func test_extraSmall_spacing() {
        XCTAssertEqual(DSSpacing.extraSmall, 4)
    }
    
    func test_small_spacing() {
        XCTAssertEqual(DSSpacing.small, 8)
    }
    
    func test_medium_spacing() {
        XCTAssertEqual(DSSpacing.medium, 12)
    }
    
    func test_large_spacing() {
        XCTAssertEqual(DSSpacing.large, 16)
    }
    
    func test_extraLarge_spacing() {
        XCTAssertEqual(DSSpacing.extraLarge, 24)
    }
    
    func test_huge_spacing() {
        XCTAssertEqual(DSSpacing.huge, 32)
    }
    
    
    func test_tvExtraSmall_spacing() {
        XCTAssertEqual(DSSpacing.tvExtraSmall, 12)
    }
    
    func test_tvSmall_spacing() {
        XCTAssertEqual(DSSpacing.tvSmall, 20)
    }
    
    func test_tvMedium_spacing() {
        XCTAssertEqual(DSSpacing.tvMedium, 32)
    }
    
    func test_tvLarge_spacing() {
        XCTAssertEqual(DSSpacing.tvLarge, 48)
    }
    
    func test_tvExtraLarge_spacing() {
        XCTAssertEqual(DSSpacing.tvExtraLarge, 64)
    }
    
    func test_tvHuge_spacing() {
        XCTAssertEqual(DSSpacing.tvHuge, 96)
    }
    
    func test_tvMassive_spacing() {
        XCTAssertEqual(DSSpacing.tvMassive, 128)
    }
    
    
    func test_extraSmallForPlatform_iOS() {
        let spacing = DSSpacing.extraSmall(for: .iOS)
        XCTAssertEqual(spacing, DSSpacing.extraSmall)
    }
    
    func test_extraSmallForPlatform_tvOS() {
        let spacing = DSSpacing.extraSmall(for: .tvOS)
        XCTAssertEqual(spacing, DSSpacing.tvExtraSmall)
    }
    
    func test_smallForPlatform_iOS() {
        let spacing = DSSpacing.small(for: .iOS)
        XCTAssertEqual(spacing, DSSpacing.small)
    }
    
    func test_smallForPlatform_tvOS() {
        let spacing = DSSpacing.small(for: .tvOS)
        XCTAssertEqual(spacing, DSSpacing.tvSmall)
    }
    
    func test_mediumForPlatform_iOS() {
        let spacing = DSSpacing.medium(for: .iOS)
        XCTAssertEqual(spacing, DSSpacing.medium)
    }
    
    func test_mediumForPlatform_tvOS() {
        let spacing = DSSpacing.medium(for: .tvOS)
        XCTAssertEqual(spacing, DSSpacing.tvMedium)
    }
    
    func test_largeForPlatform_iOS() {
        let spacing = DSSpacing.large(for: .iOS)
        XCTAssertEqual(spacing, DSSpacing.large)
    }
    
    func test_largeForPlatform_tvOS() {
        let spacing = DSSpacing.large(for: .tvOS)
        XCTAssertEqual(spacing, DSSpacing.tvLarge)
    }
    
    func test_extraLargeForPlatform_iOS() {
        let spacing = DSSpacing.extraLarge(for: .iOS)
        XCTAssertEqual(spacing, DSSpacing.extraLarge)
    }
    
    func test_extraLargeForPlatform_tvOS() {
        let spacing = DSSpacing.extraLarge(for: .tvOS)
        XCTAssertEqual(spacing, DSSpacing.tvExtraLarge)
    }
    
    
    func test_iOS_spacingHierarchy() {
        XCTAssertLessThan(DSSpacing.extraSmall, DSSpacing.small)
        XCTAssertLessThan(DSSpacing.small, DSSpacing.medium)
        XCTAssertLessThan(DSSpacing.medium, DSSpacing.large)
        XCTAssertLessThan(DSSpacing.large, DSSpacing.extraLarge)
        XCTAssertLessThan(DSSpacing.extraLarge, DSSpacing.huge)
    }
    
    func test_tvOS_spacingHierarchy() {
        XCTAssertLessThan(DSSpacing.tvExtraSmall, DSSpacing.tvSmall)
        XCTAssertLessThan(DSSpacing.tvSmall, DSSpacing.tvMedium)
        XCTAssertLessThan(DSSpacing.tvMedium, DSSpacing.tvLarge)
        XCTAssertLessThan(DSSpacing.tvLarge, DSSpacing.tvExtraLarge)
        XCTAssertLessThan(DSSpacing.tvExtraLarge, DSSpacing.tvHuge)
        XCTAssertLessThan(DSSpacing.tvHuge, DSSpacing.tvMassive)
    }
    
    func test_tvOS_spacingIsLargerThaniOS() {
        XCTAssertGreaterThan(DSSpacing.tvExtraSmall, DSSpacing.extraSmall)
        XCTAssertGreaterThan(DSSpacing.tvSmall, DSSpacing.small)
        XCTAssertGreaterThan(DSSpacing.tvMedium, DSSpacing.medium)
        XCTAssertGreaterThan(DSSpacing.tvLarge, DSSpacing.large)
        XCTAssertGreaterThan(DSSpacing.tvExtraLarge, DSSpacing.extraLarge)
        XCTAssertGreaterThan(DSSpacing.tvHuge, DSSpacing.huge)
    }
    
    func test_spacingValuesArePositive() {
        let iOSSpacings = [
            DSSpacing.extraSmall,
            DSSpacing.small,
            DSSpacing.medium,
            DSSpacing.large,
            DSSpacing.extraLarge,
            DSSpacing.huge
        ]
        
        let tvOSSpacings = [
            DSSpacing.tvExtraSmall,
            DSSpacing.tvSmall,
            DSSpacing.tvMedium,
            DSSpacing.tvLarge,
            DSSpacing.tvExtraLarge,
            DSSpacing.tvHuge,
            DSSpacing.tvMassive
        ]
        
        for spacing in iOSSpacings + tvOSSpacings {
            XCTAssertGreaterThan(spacing, 0)
        }
    }
    
    func test_platformHelperFunctionsConsistency() {
        XCTAssertEqual(DSSpacing.extraSmall(for: .iOS), DSSpacing.extraSmall)
        XCTAssertEqual(DSSpacing.small(for: .iOS), DSSpacing.small)
        XCTAssertEqual(DSSpacing.medium(for: .iOS), DSSpacing.medium)
        XCTAssertEqual(DSSpacing.large(for: .iOS), DSSpacing.large)
        XCTAssertEqual(DSSpacing.extraLarge(for: .iOS), DSSpacing.extraLarge)
        
        XCTAssertEqual(DSSpacing.extraSmall(for: .tvOS), DSSpacing.tvExtraSmall)
        XCTAssertEqual(DSSpacing.small(for: .tvOS), DSSpacing.tvSmall)
        XCTAssertEqual(DSSpacing.medium(for: .tvOS), DSSpacing.tvMedium)
        XCTAssertEqual(DSSpacing.large(for: .tvOS), DSSpacing.tvLarge)
        XCTAssertEqual(DSSpacing.extraLarge(for: .tvOS), DSSpacing.tvExtraLarge)
    }
}

