import Foundation
import XCTest
@testable import Swiftline


class ChooseSettingsTests: XCTestCase {
  var chooseSettings: ChooseSettings<String>!
  
  override func setUp() {
    chooseSettings = ChooseSettings<String>()
    chooseSettings.addChoice("one") { "one" }
    chooseSettings.addChoice("two") { "two" }
    chooseSettings.addChoice("three") { "three" }
  }
  
  
  func testAcceptsOneTwoThree() {
    XCTAssertNil(chooseSettings.invalidItemMessage("one"))
    XCTAssertNil(chooseSettings.invalidItemMessage("two"))
    XCTAssertNil(chooseSettings.invalidItemMessage("three"))
  }
  
  func testAccepts123() {
    XCTAssertNil(chooseSettings.invalidItemMessage("1"))
    XCTAssertNil(chooseSettings.invalidItemMessage("2"))
    XCTAssertNil(chooseSettings.invalidItemMessage("3"))
  }
  
  
  func testDoesNotAccept04xasd() {
    XCTAssertNotNil(chooseSettings.invalidItemMessage("0"))
    XCTAssertNotNil(chooseSettings.invalidItemMessage("4"))
    XCTAssertNotNil(chooseSettings.invalidItemMessage("x"))
    XCTAssertNotNil(chooseSettings.invalidItemMessage("asd"))
  }
  
  
  func testReturnsOneAndTwo() {
    XCTAssertEqual(chooseSettings.validatedItem(forString: "one"), "one")
    XCTAssertEqual(chooseSettings.validatedItem(forString: "2"), "two")
  }
  
  func testReturnsTheCorrectInvalidMessage() {
    XCTAssertEqual(chooseSettings.invalidItemMessage(""), "You must choose one of [1, 2, 3, one, two, three].")
  }
  
  func testReturnsTheCorrectPrompt() {
    XCTAssertEqual(chooseSettings.newItemPromptMessage(), "?  ")
  }
  
  func testReturns123OneTwoThree() {
    XCTAssertEqual(chooseSettings.validChoices(), ["1", "2", "3", "one", "two", "three"])
  }
  
  func testReturnsTheCorrectPromptMessage() {
    XCTAssertEqual(chooseSettings.newItemPromptMessage(), "?  ")
  }
  
  func testReturnsTheCorrectInitialPrompt() {
    let items = ["1. one", "2. two", "3. three"]
    XCTAssertEqual(chooseSettings.preparePromptItems(), items)
  }
  
  func testRetunrsOnefor1AndTwofor2() {
    XCTAssertEqual(chooseSettings.choiceForInput("1"), "one")
    XCTAssertEqual(chooseSettings.choiceForInput("two"), "two")
  }
}

class ChooseSettingsBlockTests: XCTestCase {
  var chooseSettings: ChooseSettings<String>!
  
  override func setUp() {
    chooseSettings = ChooseSettings<String>()
    chooseSettings.addChoice("one") { "one" }
    chooseSettings.addChoice("two") { "two" }
    chooseSettings.addChoice("three") { "three" }
  }
  
  func testCreatesPromptWithNumberAndDot() {
    let items = ["1. one", "2. two", "3. three"]
    XCTAssertEqual(chooseSettings.preparePromptItems(), items)
  }
  
  func testCreatesPromptWithNumberAndBrackets() {
    let items = ["1)  one", "2)  two", "3)  three"]
    chooseSettings.indexSuffix = ")  "
    
    XCTAssertEqual(chooseSettings.preparePromptItems(), items)
  }
  
  func testCreatesPromptWithLetters() {
    let items = ["a - one", "b - two", "c - three"]
    chooseSettings.indexSuffix = " - "
    chooseSettings.index = .Letters
    
    XCTAssertEqual(chooseSettings.preparePromptItems(), items)
  }
}

class ChooseSettingsBlock2Tests: XCTestCase {
  
  var chooseSettings: ChooseSettings<Int>!
  
  override func setUp() {
    chooseSettings = ChooseSettings<Int>()
    chooseSettings.addChoice("one") { 10 }
    chooseSettings.addChoice("two") { 20 }
    chooseSettings.addChoice("three") { 33 }
  }
  
  func testAcceptsOneAndTwo() {
    XCTAssertNil(chooseSettings.invalidItemMessage("one"))
    XCTAssertNil(chooseSettings.invalidItemMessage("1"))
  }
  
  func testDoesNotAccept04x() {
    XCTAssertNotNil(chooseSettings.invalidItemMessage("0"))
    XCTAssertNotNil(chooseSettings.invalidItemMessage("4"))
    XCTAssertNotNil(chooseSettings.invalidItemMessage("x"))
    XCTAssertNotNil(chooseSettings.invalidItemMessage("asd"))
  }
  
  func testReturnsOneandTwo() {
    XCTAssertEqual(chooseSettings.validatedItem(forString: "one"), 10)
    XCTAssertEqual(chooseSettings.validatedItem(forString: "2"), 20)
  }
  
  func testReturnsTheCorrectInvalidMessage() {
    XCTAssertEqual(chooseSettings.invalidItemMessage(""), "You must choose one of [1, 2, 3, one, two, three].")
  }
  
  func testReturnsTheCorrectPromptMessage() {
    XCTAssertEqual(chooseSettings.newItemPromptMessage(), "?  ")
  }
  
  func testReturns123() {
    XCTAssertEqual(chooseSettings.validChoices(), ["1", "2", "3", "one", "two", "three"])
  }
  
  func testReturnsTheCorrectPromptItems() {
    XCTAssertEqual(chooseSettings.newItemPromptMessage(), "?  ")
  }
  
  func testReturnsTheCorrectInitialPromptWith123() {
    let items = ["1. one", "2. two", "3. three"]
    XCTAssertEqual(chooseSettings.preparePromptItems(), items)
  }
  
  func testReturns123Values(){
    XCTAssertEqual(chooseSettings.choiceForInput("1"), 10)
    XCTAssertEqual(chooseSettings.choiceForInput("two"), 20)
  }
  
}
