import Foundation
import XCTest
@testable import Swiftline


class AgreeSettingsTest: XCTestCase {
  
  let settings = AgreeSettings(prompt: "The Prompt is")
  
  func testAcceptsYesIfYandy() {
    XCTAssertNil(settings.invalidItemMessage("Yes"))
    XCTAssertNil(settings.invalidItemMessage("Y"))
    XCTAssertNil(settings.invalidItemMessage("yes"))
    XCTAssertNil(settings.invalidItemMessage("y"))
  }

  func testAcceptsNo() {
    XCTAssertNil(settings.invalidItemMessage("No"))
    XCTAssertNil(settings.invalidItemMessage("N"))
    XCTAssertNil(settings.invalidItemMessage("no"))
    XCTAssertNil(settings.invalidItemMessage("n"))
  }

  func testDoesNotAcceptInvalidInputs() {
    XCTAssertNotNil(settings.invalidItemMessage("www"))
    XCTAssertNotNil(settings.invalidItemMessage(""))
  }

  func tesetReturnsTheSameItemAsValid() {
    XCTAssertEqual(settings.validatedItem(forString: "No"), "No")
    XCTAssertEqual(settings.validatedItem(forString: "Yes"), "Yes")
  }

  func testValidatesYesasTrue() {
    XCTAssertTrue(settings.isPositive("Yes"))
    XCTAssertTrue(settings.isPositive("Y"))
    XCTAssertTrue(settings.isPositive("yes"))
    XCTAssertTrue(settings.isPositive("y"))
  }

  func testValidatesNoasFalse() {
    XCTAssertFalse(settings.isPositive("No"))
    XCTAssertFalse(settings.isPositive("N"))
    XCTAssertFalse(settings.isPositive("n"))
    XCTAssertFalse(settings.isPositive("n"))
  }
  

  func testReturnsCorrectInvalidMessagePrompt() {
    let invalid = settings.invalidItemMessage("")
    XCTAssertEqual(invalid, "Please enter \"yes\" or \"no\".")
  }
  
  func testReturnsCorrectPrompt() {
    let invalid = settings.newItemPromptMessage()
    XCTAssertEqual(invalid, "The Prompt is  ")
  }
}