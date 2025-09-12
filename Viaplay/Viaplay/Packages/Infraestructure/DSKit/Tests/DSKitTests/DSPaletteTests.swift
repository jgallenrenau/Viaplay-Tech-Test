import XCTest
import SwiftUI
@testable import DSKit

final class DSPaletteTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
    }
    
    func test_brandColor_exists() {
        XCTAssertNotNil(DSPalette.brand)
    }
    
    func test_textPrimaryColor_exists() {
        XCTAssertNotNil(DSPalette.textPrimary)
    }
    
    func test_textSecondaryColor_exists() {
        XCTAssertNotNil(DSPalette.textSecondary)
    }
    
    func test_backgroundColor_exists() {
        XCTAssertNotNil(DSPalette.background)
    }
    
    func test_surfaceColor_exists() {
        XCTAssertNotNil(DSPalette.surface)
    }
    
    func test_errorColor_exists() {
        XCTAssertNotNil(DSPalette.error)
    }
    
    func test_shadowColor_exists() {
        XCTAssertNotNil(DSPalette.shadow)
    }
    
    func test_iOSAccentColor_exists() {
        XCTAssertNotNil(DSPalette.iOSAccent)
    }
    
    func test_iOSCardBackgroundColor_exists() {
        XCTAssertNotNil(DSPalette.iOSCardBackground)
    }
    
    func test_iOSBorderColor_exists() {
        XCTAssertNotNil(DSPalette.iOSBorder)
    }
    
    func test_tvAccentColor_exists() {
        XCTAssertNotNil(DSPalette.tvAccent)
    }
    
    func test_tvCardBackgroundColor_exists() {
        XCTAssertNotNil(DSPalette.tvCardBackground)
    }
    
    func test_tvBorderColor_exists() {
        XCTAssertNotNil(DSPalette.tvBorder)
    }
    
    func test_tvFocusColor_exists() {
        XCTAssertNotNil(DSPalette.tvFocus)
    }
    
    func test_tvHighlightColor_exists() {
        XCTAssertNotNil(DSPalette.tvHighlight)
    }
    
    func test_tvGlowColor_exists() {
        XCTAssertNotNil(DSPalette.tvGlow)
    }
    
    func test_sectionSeriesColor_exists() {
        XCTAssertNotNil(DSPalette.sectionSeries)
    }
    
    func test_sectionMoviesColor_exists() {
        XCTAssertNotNil(DSPalette.sectionMovies)
    }
    
    func test_sectionSportColor_exists() {
        XCTAssertNotNil(DSPalette.sectionSport)
    }
    
    func test_sectionKidsColor_exists() {
        XCTAssertNotNil(DSPalette.sectionKids)
    }
    
    func test_sectionChannelsColor_exists() {
        XCTAssertNotNil(DSPalette.sectionChannels)
    }
    
    func test_accentForPlatform_iOS() {
        let color = DSPalette.accent(for: .iOS)
        XCTAssertNotNil(color)
    }
    
    func test_accentForPlatform_tvOS() {
        let color = DSPalette.accent(for: .tvOS)
        XCTAssertNotNil(color)
    }
    
    func test_cardBackgroundForPlatform_iOS() {
        let color = DSPalette.cardBackground(for: .iOS)
        XCTAssertNotNil(color)
    }
    
    func test_cardBackgroundForPlatform_tvOS() {
        let color = DSPalette.cardBackground(for: .tvOS)
        XCTAssertNotNil(color)
    }
    
    func test_borderForPlatform_iOS() {
        let color = DSPalette.border(for: .iOS)
        XCTAssertNotNil(color)
    }
    
    func test_borderForPlatform_tvOS() {
        let color = DSPalette.border(for: .tvOS)
        XCTAssertNotNil(color)
    }
    
    func test_allColorsAreUnique() {
        let colors = [
            DSPalette.brand,
            DSPalette.textPrimary,
            DSPalette.textSecondary,
            DSPalette.background,
            DSPalette.surface,
            DSPalette.error,
            DSPalette.shadow,
            DSPalette.iOSAccent,
            DSPalette.iOSCardBackground,
            DSPalette.iOSBorder,
            DSPalette.tvAccent,
            DSPalette.tvCardBackground,
            DSPalette.tvBorder,
            DSPalette.tvFocus,
            DSPalette.tvHighlight,
            DSPalette.tvGlow,
            DSPalette.sectionSeries,
            DSPalette.sectionMovies,
            DSPalette.sectionSport,
            DSPalette.sectionKids,
            DSPalette.sectionChannels
        ]
        
        for color in colors {
            XCTAssertNotNil(color)
        }
    }
    
    func test_platformSpecificColorsConsistency() {
        let iOSAccent = DSPalette.accent(for: .iOS)
        let tvOSAccent = DSPalette.accent(for: .tvOS)
        
        let iOSCardBackground = DSPalette.cardBackground(for: .iOS)
        let tvOSCardBackground = DSPalette.cardBackground(for: .tvOS)
        
        let iOSBorder = DSPalette.border(for: .iOS)
        let tvOSBorder = DSPalette.border(for: .tvOS)
        
        XCTAssertNotNil(iOSAccent)
        XCTAssertNotNil(tvOSAccent)
        XCTAssertNotNil(iOSCardBackground)
        XCTAssertNotNil(tvOSCardBackground)
        XCTAssertNotNil(iOSBorder)
        XCTAssertNotNil(tvOSBorder)
    }
    
    func test_sectionColorsAreAccessible() {
        let sectionColors = [
            DSPalette.sectionSeries,
            DSPalette.sectionMovies,
            DSPalette.sectionSport,
            DSPalette.sectionKids,
            DSPalette.sectionChannels
        ]
        
        for color in sectionColors {
            XCTAssertNotNil(color)
        }
    }
}

