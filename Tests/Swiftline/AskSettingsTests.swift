import Foundation
import XCTest
@testable import Swiftline


class AskSettingsTests: XCTestCase {

  func testReturnsTheDefualtIfStringIsEmpty() {
    let askSettings = AskSettings<String>()
    askSettings.defaultValue = "Def"
    
    XCTAssertEqual(askSettings.preparedItem(originalString: ""), "Def")
  }
  
  func testDoesNotReturnsTheDefualtIfStringIsEmpty() {
    let askSettings = AskSettings<String>()
    askSettings.defaultValue = "Def"
    
    XCTAssertEqual(askSettings.preparedItem(originalString: "asd"), "asd")
  }
  
  func tesetValidatesWithABlock() {
    let askSettings = AskSettings<String>()
    askSettings.addInvalidCase("") { s in return false }
    
    XCTAssertNil(askSettings.invalidItemMessage("ss"))
    
    askSettings.addInvalidCase("") { s in return true }
    XCTAssertNotNil(askSettings.invalidItemMessage("ss"))
  }

  func testReturnsCorrectInvalidMessage() {
    let askSettings = AskSettings<String>()
    
    XCTAssertEqual(askSettings.invalidItemMessage(nil), "You provided an empty message, pelase enter anything!")
  }

  func testReturnsCorrectInvalidMessageWhenNotValid() {
    let askSettings = AskSettings<Int>()
    
    XCTAssertEqual(askSettings.invalidItemMessage("dd"), "You must enter a valid Integer.")
  }
  
  func testReturnsCorrectInvalidPrompt() {
    let askSettings = AskSettings<String>()
    
    XCTAssertEqual(askSettings.newItemPromptMessage(), "?  ")
  }
}
