import Foundation
import XCTest
@testable import Swiftline


class AskerTest: XCTestCase {
  var promptPrinter: DummyPromptPrinter!
  
  override func setUp() {
    promptPrinter = DummyPromptPrinter()
    PromptSettings.printer = promptPrinter
  }
  
  func testItReadsFromSTDIN() {
    PromptSettings.reader = DummyPromptReader(toReturn: "A String")
    let res = ask("Enter a string")
    
    XCTAssertEqual(res, "A String")
    XCTAssertEqual(promptPrinter.printed, "Enter a string\n")
  }
  
  func testItReadsAnIntFromSTDIN() {
    PromptSettings.reader = DummyPromptReader(toReturn: "1")
    let res = ask("Enter a string", type: Int.self)
    
    XCTAssertEqual(res, 1)
    XCTAssertEqual(promptPrinter.printed, "Enter a string\n")
  }
  
  func testKeepsAskingIfEnteredIsNotInt() {
    PromptSettings.reader = DummyPromptReader(toReturn: "x", "y", "1")
    
    let res = ask("Enter a string", type: Int.self)
    
    let prompt = ["Enter a string",
                  "You must enter a valid Integer.",
                  "?  You must enter a valid Integer.",
                  "?  "].joined(separator: "\n")
    
    XCTAssertEqual(res, 1)
    XCTAssertEqual(promptPrinter.printed, prompt)
  }
  
  func testReadsDoubleFromSTDIN() {
    PromptSettings.reader = DummyPromptReader(toReturn: "1")
    let res = ask("Enter a string", type: Double.self)
    
    XCTAssertEqual(res, 1.0)
    XCTAssertEqual(promptPrinter.printed, "Enter a string\n")
  }
  
  func testItKeepAskingIfValidationIsFalse() {
    PromptSettings.reader = DummyPromptReader(toReturn: "1", "2", "3")
    let res = ask("Enter a string") { s in
      s.addInvalidCase("Invalid string") { $0 != "3" }
      return
    }
    
    XCTAssertEqual(res, "3")
    
    let prompt = ["Enter a string",
                  "Invalid string",
                  "?  Invalid string\n?  "].joined(separator: "\n")
    
    XCTAssertEqual(promptPrinter.printed, prompt)
  }
  
  func testAsksForConfirmation() {
    PromptSettings.reader = DummyPromptReader(toReturn: "val", "Y")
    let res = ask("Enter a string") { $0.confirm = true }
    
    XCTAssertEqual(res, "val")
    XCTAssertEqual(promptPrinter.printed, "Enter a string\nAre you sure?  ")
  }
  
  func testAsksForConfirmationIfNoIsPassedItKeepsAsking() {
    PromptSettings.reader = DummyPromptReader(toReturn: "val", "N", "other val", "y")
    let res = ask("Enter a string") { $0.confirm = true }
    
    XCTAssertEqual(res, "other val")
    
    let prompt = ["Enter a string",
                  "Are you sure?  ?  Are you sure?  "].joined(separator: "\n")
    
    XCTAssertEqual(promptPrinter.printed, prompt)
  }
  
  func testAsksForConfirmationAndValidatesInput() {
    PromptSettings.reader = DummyPromptReader(toReturn: "1", "n", "10", "9", "yes")
    
    let res = ask("Age?", type: Int.self) {
      $0.confirm = true
      $0.addInvalidCase("Age not correct") { $0 == 10 }
    }
    
    XCTAssertEqual(res, 9)
    
    let prompt = ["Age?",
                  "Are you sure?  ?  Age not correct",
                  "?  Are you sure?  "
      ].joined(separator: "\n")
    
    XCTAssertEqual(promptPrinter.printed, prompt)
  }
  
}
