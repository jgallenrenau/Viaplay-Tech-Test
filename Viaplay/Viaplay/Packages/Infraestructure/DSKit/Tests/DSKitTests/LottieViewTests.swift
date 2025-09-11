import XCTest
import SwiftUI
import Lottie
@testable import DSKit

final class LottieViewTests: XCTestCase {
    
    private var sut: DSKit.LottieView!
    
    override func setUp() async throws {
        try await super.setUp()
        
        // Initialize SUT with default parameters
        sut = DSKit.LottieView(name: "Loading")
    }
    
    override func tearDown() async throws {
        sut = nil
        try await super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func test_init_withDefaultParameters() {
        let lottieView = DSKit.LottieView(name: "TestAnimation")
        
        XCTAssertEqual(lottieView.name, "TestAnimation")
        XCTAssertEqual(lottieView.loopMode, .loop)
        XCTAssertNil(lottieView.accessibilityLabel)
        XCTAssertNil(lottieView.accessibilityHint)
    }
    
    func test_init_withAllParameters() {
        let lottieView = DSKit.LottieView(
            name: "TestAnimation",
            loopMode: .playOnce,
            accessibilityLabel: "Test Label",
            accessibilityHint: "Test Hint"
        )
        
        XCTAssertEqual(lottieView.name, "TestAnimation")
        XCTAssertEqual(lottieView.loopMode, .playOnce)
        XCTAssertEqual(lottieView.accessibilityLabel, "Test Label")
        XCTAssertEqual(lottieView.accessibilityHint, "Test Hint")
    }
    
    func test_init_withDifferentLoopModes() {
        let loopView = DSKit.LottieView(name: "Test", loopMode: .loop)
        let playOnceView = DSKit.LottieView(name: "Test", loopMode: .playOnce)
        let autoReverseView = DSKit.LottieView(name: "Test", loopMode: .autoReverse)
        
        XCTAssertEqual(loopView.loopMode, .loop)
        XCTAssertEqual(playOnceView.loopMode, .playOnce)
        XCTAssertEqual(autoReverseView.loopMode, .autoReverse)
    }
    
    // MARK: - Property Tests
    
    func test_nameProperty() {
        let customName = "CustomAnimationName"
        let view = DSKit.LottieView(name: customName)
        
        XCTAssertEqual(view.name, customName)
    }
    
    func test_loopModeProperty() {
        let view = DSKit.LottieView(name: "Test", loopMode: .playOnce)
        
        XCTAssertEqual(view.loopMode, .playOnce)
    }
    
    func test_accessibilityProperties() {
        let view = DSKit.LottieView(
            name: "Test",
            accessibilityLabel: "Test Label",
            accessibilityHint: "Test Hint"
        )
        
        XCTAssertEqual(view.accessibilityLabel, "Test Label")
        XCTAssertEqual(view.accessibilityHint, "Test Hint")
    }
    
    // MARK: - Animation Name Tests
    
    func test_differentAnimationNames() {
        let names = ["Loading", "Success", "Error", "Spinner", "CustomAnimation"]
        
        for name in names {
            let view = DSKit.LottieView(name: name)
            XCTAssertEqual(view.name, name)
        }
    }
    
    func test_emptyAnimationName() {
        let view = DSKit.LottieView(name: "")
        XCTAssertEqual(view.name, "")
    }
    
    // MARK: - Edge Cases Tests
    
    func test_multipleInstances() {
        let view1 = DSKit.LottieView(name: "Animation1")
        let view2 = DSKit.LottieView(name: "Animation2")
        
        XCTAssertNotEqual(view1.name, view2.name)
        XCTAssertEqual(view1.name, "Animation1")
        XCTAssertEqual(view2.name, "Animation2")
    }
    
    func test_sameInstanceMultipleAccess() {
        XCTAssertEqual(sut.name, "Loading")
        XCTAssertEqual(sut.loopMode, .loop)
        // Note: accessibilityLabel and accessibilityHint are not tested here due to SwiftUI ambiguity
    }
    
    // MARK: - Integration Tests
    
    func test_swiftUIIntegration() {
        // Test that LottieView can be used in SwiftUI
        let swiftUIView = DSKit.LottieView(name: "Test")
        
        XCTAssertEqual(swiftUIView.name, "Test")
        XCTAssertEqual(swiftUIView.loopMode, .loop)
    }
    
    func test_loopModeConfiguration() {
        let loopModes: [LottieLoopMode] = [.loop, .playOnce, .autoReverse]
        
        for loopMode in loopModes {
            let view = DSKit.LottieView(name: "Test", loopMode: loopMode)
            XCTAssertEqual(view.loopMode, loopMode)
        }
    }
    
    // MARK: - Accessibility Tests
    
    func test_accessibilityLabelOnly() {
        let view = DSKit.LottieView(
            name: "Test",
            accessibilityLabel: "Loading Animation"
        )
        
        XCTAssertEqual(view.accessibilityLabel, "Loading Animation")
        XCTAssertNil(view.accessibilityHint)
    }
    
    func test_accessibilityHintOnly() {
        let view = DSKit.LottieView(
            name: "Test",
            accessibilityHint: "This animation indicates loading"
        )
        
        XCTAssertNil(view.accessibilityLabel)
        XCTAssertEqual(view.accessibilityHint, "This animation indicates loading")
    }
    
    func test_accessibilityBoth() {
        let view = DSKit.LottieView(
            name: "Test",
            accessibilityLabel: "Loading Animation",
            accessibilityHint: "This animation indicates loading"
        )
        
        XCTAssertEqual(view.accessibilityLabel, "Loading Animation")
        XCTAssertEqual(view.accessibilityHint, "This animation indicates loading")
    }
    
    func test_accessibilityNone() {
        let view = DSKit.LottieView(name: "Test")
        
        XCTAssertNil(view.accessibilityLabel)
        XCTAssertNil(view.accessibilityHint)
    }
    
    // MARK: - Loop Mode Edge Cases
    
    func test_loopModeDefault() {
        let view = DSKit.LottieView(name: "Test")
        XCTAssertEqual(view.loopMode, .loop)
    }
    
    func test_loopModePlayOnce() {
        let view = DSKit.LottieView(name: "Test", loopMode: .playOnce)
        XCTAssertEqual(view.loopMode, .playOnce)
    }
    
    func test_loopModeAutoReverse() {
        let view = DSKit.LottieView(name: "Test", loopMode: .autoReverse)
        XCTAssertEqual(view.loopMode, .autoReverse)
    }
    
    // MARK: - String Edge Cases
    
    func test_nameWithSpecialCharacters() {
        let specialName = "Animation-With_Special.Chars123"
        let view = DSKit.LottieView(name: specialName)
        
        XCTAssertEqual(view.name, specialName)
    }
    
    func test_nameWithUnicode() {
        let unicodeName = "Animation🚀With🎉Unicode"
        let view = DSKit.LottieView(name: unicodeName)
        
        XCTAssertEqual(view.name, unicodeName)
    }
    
    func test_nameWithSpaces() {
        let spacedName = "Animation With Spaces"
        let view = DSKit.LottieView(name: spacedName)
        
        XCTAssertEqual(view.name, spacedName)
    }
    
    // MARK: - Memory Management Tests
    
    func test_memoryManagement() {
        // Since LottieView is a struct, we test value semantics instead
        var view1 = DSKit.LottieView(name: "Test")
        let view2 = view1
        
        // Modifying one should not affect the other (value semantics)
        view1 = DSKit.LottieView(name: "Modified")
        
        XCTAssertEqual(view1.name, "Modified")
        XCTAssertEqual(view2.name, "Test")
    }
    
    // MARK: - Equality Tests
    
    func test_equality() {
        let view1 = DSKit.LottieView(name: "Test")
        let view2 = DSKit.LottieView(name: "Test")
        
        // Properties should be equal
        XCTAssertEqual(view1.name, view2.name)
        XCTAssertEqual(view1.loopMode, view2.loopMode)
        XCTAssertEqual(view1.accessibilityLabel, view2.accessibilityLabel)
        XCTAssertEqual(view1.accessibilityHint, view2.accessibilityHint)
    }
    
    // MARK: - Performance Tests
    
    func test_initializationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = DSKit.LottieView(name: "Test")
            }
        }
    }
    
    func test_propertyAccessPerformance() {
        let view = DSKit.LottieView(name: "Test")
        
        measure {
            for _ in 0..<10000 {
                _ = view.name
                _ = view.loopMode
                _ = view.accessibilityLabel
                _ = view.accessibilityHint
            }
        }
    }
}