import Foundation
import XCTest
@testable import Swiftline


class AgreeTest: XCTestCase {
  
  var promptPrinter: DummyPromptPrinter!
  
  override func setUp() {
    promptPrinter = DummyPromptPrinter()
    PromptSettings.printer = promptPrinter
  }
  
  
  func testReturnsTrueIfYesPassed() {
    PromptSettings.reader = DummyPromptReader(toReturn:  "Yes")
    
    let ret = agree("Are you a test?")
    
    XCTAssertEqual(ret, true)
    XCTAssertEqual(promptPrinter.printed, "Are you a test?  ")
  }
  
  func testReturnsTrueIfNPassed() {
    PromptSettings.reader = DummyPromptReader(toReturn:  "n")
    
    let ret = agree("Are you a test?")
    
    XCTAssertEqual(ret, false)
    XCTAssertEqual(promptPrinter.printed, "Are you a test?  ")
  }
  
  func testKeepsAskingIfWrongParamsPassed() {
    PromptSettings.reader = DummyPromptReader(toReturn: "a", "n")
    
    let ret = agree("Are you a test?")
    
    XCTAssertEqual(ret, false)
    let prompts = "Are you a test?  Please enter \"yes\" or \"no\".\nAre you a test?  "
    XCTAssertEqual(promptPrinter.printed, prompts)
  }
  
}
