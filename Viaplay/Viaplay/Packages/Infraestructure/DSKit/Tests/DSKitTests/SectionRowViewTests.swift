import XCTest
import SwiftUI
@testable import DSKit

final class SectionRowViewTests: XCTestCase {
    
    
    func testModelInitializationWithTitleOnly() {
        let model = SectionRowView.Model(title: "Test Title")
        
        XCTAssertEqual(model.title, "Test Title")
        XCTAssertNil(model.description)
    }
    
    func testModelInitializationWithTitleAndDescription() {
        let model = SectionRowView.Model(title: "Test Title", description: "Test Description")
        
        XCTAssertEqual(model.title, "Test Title")
        XCTAssertEqual(model.description, "Test Description")
    }
    
    func testModelEquality() {
        let model1 = SectionRowView.Model(title: "Title", description: "Description")
        let model2 = SectionRowView.Model(title: "Title", description: "Description")
        let model3 = SectionRowView.Model(title: "Different", description: "Description")
        
        XCTAssertEqual(model1, model2)
        XCTAssertNotEqual(model1, model3)
    }
    
    
    func testViewInitialization() {
        let model = SectionRowView.Model(title: "Test Title", description: "Test Description")
        let view = SectionRowView(model: model)
        
        XCTAssertNotNil(view)
    }
    
    func testViewWithEmptyDescription() {
        let model = SectionRowView.Model(title: "Title", description: "")
        let view = SectionRowView(model: model)
        
        XCTAssertNotNil(view)
    }
    
    func testViewWithNilDescription() {
        let model = SectionRowView.Model(title: "Title", description: nil)
        let view = SectionRowView(model: model)
        
        XCTAssertNotNil(view)
    }
    
    
    func testModelWithVeryLongTitle() {
        let longTitle = String(repeating: "Very Long Title ", count: 50)
        let model = SectionRowView.Model(title: longTitle, description: "Description")
        
        XCTAssertEqual(model.title, longTitle)
        XCTAssertEqual(model.description, "Description")
    }
    
    func testModelWithVeryLongDescription() {
        let longDescription = String(repeating: "Very Long Description ", count: 50)
        let model = SectionRowView.Model(title: "Title", description: longDescription)
        
        XCTAssertEqual(model.title, "Title")
        XCTAssertEqual(model.description, longDescription)
    }
    
    func testModelWithEmptyTitle() {
        let model = SectionRowView.Model(title: "", description: "Description")
        
        XCTAssertEqual(model.title, "")
        XCTAssertEqual(model.description, "Description")
    }
    
    func testModelWithUnicodeCharacters() {
        let unicodeTitle = "Título con ñ y áéíóú"
        let unicodeDescription = "Descripción con caracteres especiales"
        let model = SectionRowView.Model(title: unicodeTitle, description: unicodeDescription)
        
        XCTAssertEqual(model.title, unicodeTitle)
        XCTAssertEqual(model.description, unicodeDescription)
    }
    
    func testModelWithNumbersAndSymbols() {
        let titleWithNumbers = "Section 123 !@#$%^&*()"
        let descriptionWithSymbols = "Description with symbols: !@#$%^&*()"
        let model = SectionRowView.Model(title: titleWithNumbers, description: descriptionWithSymbols)
        
        XCTAssertEqual(model.title, titleWithNumbers)
        XCTAssertEqual(model.description, descriptionWithSymbols)
    }
    
    func testModelWithWhitespaceOnly() {
        let whitespaceTitle = "   \t\n   "
        let whitespaceDescription = "   \t\n   "
        let model = SectionRowView.Model(title: whitespaceTitle, description: whitespaceDescription)
        
        XCTAssertEqual(model.title, whitespaceTitle)
        XCTAssertEqual(model.description, whitespaceDescription)
    }
    
    
    func testModelHashable() {
        let model1 = SectionRowView.Model(title: "Title", description: "Description")
        let model2 = SectionRowView.Model(title: "Title", description: "Description")
        let model3 = SectionRowView.Model(title: "Different", description: "Description")
        
        XCTAssertEqual(model1.hashValue, model2.hashValue)
        XCTAssertNotEqual(model1.hashValue, model3.hashValue)
    }
    
    func testModelInSet() {
        let model1 = SectionRowView.Model(title: "Title", description: "Description")
        let model2 = SectionRowView.Model(title: "Title", description: "Description")
        let model3 = SectionRowView.Model(title: "Different", description: "Description")
        
        var set = Set<SectionRowView.Model>()
        set.insert(model1)
        set.insert(model2)
        set.insert(model3)
        
        XCTAssertEqual(set.count, 2) // model1 and model2 are equal, so only 2 unique items
    }
    
    
    func testModelCreationPerformance() {
        measure {
            for i in 0..<1000 {
                _ = SectionRowView.Model(title: "Title \(i)", description: "Description \(i)")
            }
        }
    }
    
    func testModelEqualityPerformance() {
        let model1 = SectionRowView.Model(title: "Title", description: "Description")
        let model2 = SectionRowView.Model(title: "Title", description: "Description")
        
        measure {
            for _ in 0..<10000 {
                _ = model1 == model2
            }
        }
    }
    
    
    func testViewWithVeryLongContent() {
        let longTitle = String(repeating: "Very Long Title ", count: 100)
        let longDescription = String(repeating: "Very Long Description ", count: 100)
        let model = SectionRowView.Model(title: longTitle, description: longDescription)
        let view = SectionRowView(model: model)
        
        XCTAssertNotNil(view)
    }
    
    func testViewWithSpecialCharacters() {
        let specialTitle = "Title with \"quotes\" and 'apostrophes'"
        let specialDescription = "Description with <tags> and & symbols"
        let model = SectionRowView.Model(title: specialTitle, description: specialDescription)
        let view = SectionRowView(model: model)
        
        XCTAssertNotNil(view)
    }
    
    func testViewWithNewlines() {
        let titleWithNewlines = "Title\nwith\nnewlines"
        let descriptionWithNewlines = "Description\nwith\nnewlines"
        let model = SectionRowView.Model(title: titleWithNewlines, description: descriptionWithNewlines)
        let view = SectionRowView(model: model)
        
        XCTAssertNotNil(view)
    }
}
