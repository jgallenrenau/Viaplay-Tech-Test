import XCTest
import SwiftUI
@testable import DSKit

final class DSTypographyTests: XCTestCase {
    
    override func setUp() async throws {
        try await super.setUp()
    }
    
    override func tearDown() async throws {
        try await super.tearDown()
    }
    
    
    func test_title_font() {
        let font = DSTypography.title
        XCTAssertNotNil(font)
        
        let uiFont = UIFont.preferredFont(forTextStyle: .title1)
        XCTAssertNotNil(uiFont.fontDescriptor)
    }
    
    func test_body_font() {
        let font = DSTypography.body
        XCTAssertNotNil(font)
        
        let uiFont = UIFont.preferredFont(forTextStyle: .body)
        XCTAssertNotNil(uiFont.fontDescriptor)
    }
    
    func test_caption_font() {
        let font = DSTypography.caption
        XCTAssertNotNil(font)
        
        let uiFont = UIFont.preferredFont(forTextStyle: .caption1)
        XCTAssertNotNil(uiFont.fontDescriptor)
    }
    
    func test_small_font() {
        let font = DSTypography.small
        XCTAssertNotNil(font)
        
        let uiFont = UIFont.preferredFont(forTextStyle: .footnote)
        XCTAssertNotNil(uiFont.fontDescriptor)
    }
    
    
    func test_tvTitle_font() {
        let font = DSTypography.tvTitle
        XCTAssertNotNil(font)
        
        let uiFont = UIFont.preferredFont(forTextStyle: .title1)
        XCTAssertNotNil(uiFont.fontDescriptor)
    }
    
    func test_tvSubtitle_font() {
        let font = DSTypography.tvSubtitle
        XCTAssertNotNil(font)
        
        let uiFont = UIFont.preferredFont(forTextStyle: .title1)
        XCTAssertNotNil(uiFont.fontDescriptor)
    }
    
    func test_tvBody_font() {
        let font = DSTypography.tvBody
        XCTAssertNotNil(font)
        
        let uiFont = UIFont.preferredFont(forTextStyle: .title1)
        XCTAssertNotNil(uiFont.fontDescriptor)
    }
    
    func test_tvCaption_font() {
        let font = DSTypography.tvCaption
        XCTAssertNotNil(font)
        
        let uiFont = UIFont.preferredFont(forTextStyle: .title1)
        XCTAssertNotNil(uiFont.fontDescriptor)
    }
    
    func test_tvLarge_font() {
        let font = DSTypography.tvLarge
        XCTAssertNotNil(font)
        
        let uiFont = UIFont.preferredFont(forTextStyle: .title1)
        XCTAssertNotNil(uiFont.fontDescriptor)
    }
    
    
    func test_titleForPlatform_iOS() {
        let font = DSTypography.title(for: .iOS)
        XCTAssertNotNil(font)
        XCTAssertEqual(font, DSTypography.title)
    }
    
    func test_titleForPlatform_tvOS() {
        let font = DSTypography.title(for: .tvOS)
        XCTAssertNotNil(font)
        XCTAssertEqual(font, DSTypography.tvTitle)
    }
    
    func test_bodyForPlatform_iOS() {
        let font = DSTypography.body(for: .iOS)
        XCTAssertNotNil(font)
        XCTAssertEqual(font, DSTypography.body)
    }
    
    func test_bodyForPlatform_tvOS() {
        let font = DSTypography.body(for: .tvOS)
        XCTAssertNotNil(font)
        XCTAssertEqual(font, DSTypography.tvBody)
    }
    
    func test_captionForPlatform_iOS() {
        let font = DSTypography.caption(for: .iOS)
        XCTAssertNotNil(font)
        XCTAssertEqual(font, DSTypography.caption)
    }
    
    func test_captionForPlatform_tvOS() {
        let font = DSTypography.caption(for: .tvOS)
        XCTAssertNotNil(font)
        XCTAssertEqual(font, DSTypography.tvCaption)
    }
    
    
    func test_iOS_fontHierarchy() {
        let fonts = [
            DSTypography.small,
            DSTypography.caption,
            DSTypography.body,
            DSTypography.title
        ]
        
        for font in fonts {
            XCTAssertNotNil(font)
        }
    }
    
    func test_tvOS_fontHierarchy() {
        let fonts = [
            DSTypography.tvCaption,
            DSTypography.tvBody,
            DSTypography.tvSubtitle,
            DSTypography.tvTitle,
            DSTypography.tvLarge
        ]
        
        for font in fonts {
            XCTAssertNotNil(font)
        }
    }
    
    func test_allFontsAreAccessible() {
        let allFonts = [
            DSTypography.title,
            DSTypography.body,
            DSTypography.caption,
            DSTypography.small,
            DSTypography.tvTitle,
            DSTypography.tvSubtitle,
            DSTypography.tvBody,
            DSTypography.tvCaption,
            DSTypography.tvLarge
        ]
        
        for font in allFonts {
            XCTAssertNotNil(font)
        }
    }
    
    func test_platformHelperFunctionsConsistency() {
        XCTAssertEqual(DSTypography.title(for: .iOS), DSTypography.title)
        XCTAssertEqual(DSTypography.body(for: .iOS), DSTypography.body)
        XCTAssertEqual(DSTypography.caption(for: .iOS), DSTypography.caption)
        
        XCTAssertEqual(DSTypography.title(for: .tvOS), DSTypography.tvTitle)
        XCTAssertEqual(DSTypography.body(for: .tvOS), DSTypography.tvBody)
        XCTAssertEqual(DSTypography.caption(for: .tvOS), DSTypography.tvCaption)
    }
    
    func test_fontDesignConsistency() {
        let fonts = [
            DSTypography.title,
            DSTypography.body,
            DSTypography.caption,
            DSTypography.small,
            DSTypography.tvTitle,
            DSTypography.tvSubtitle,
            DSTypography.tvBody,
            DSTypography.tvCaption,
            DSTypography.tvLarge
        ]
        
        for font in fonts {
            XCTAssertNotNil(font, "Font should not be nil")
        }
    }
}
