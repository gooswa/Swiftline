import Foundation
import XCTest
@testable import Swiftline


class ChooseTests: XCTestCase {
  
  var promptPrinter: DummyPromptPrinter!
  
  override func setUp() {
    promptPrinter = DummyPromptPrinter()
    PromptSettings.printer = promptPrinter
  }
  
  func testPromtStringWithChoices() {
    PromptSettings.reader = DummyPromptReader(toReturn: "1")
    _ = choose("Select one of  ", choices:  "one", "two", "three")
    
    let prompt = [
      "1. one",
      "2. two",
      "3. three",
      "Select one of  "].joined(separator: "\n")
    
    XCTAssertEqual(promptPrinter.printed, prompt)
  }
  
  func testReturnsChoice1() {
    PromptSettings.reader = DummyPromptReader(toReturn: "1")
    let choice = choose("Select one of", choices:  "one", "two", "three")
    
    XCTAssertEqual(choice, "one")
  }
  
  func testReturnChouce2() {
    PromptSettings.reader = DummyPromptReader(toReturn: "two")
    let choice = choose("Select one of", choices:  "one", "two", "three")
    
    XCTAssertEqual(choice, "two")
  }
  
  func testKeepsPromptingForCorrectAnswer() {
    PromptSettings.reader = DummyPromptReader(toReturn: "x", "y", "three")
    let choice = choose("Select one of  ", choices:  "one", "two", "three")
    
    let prompt = [
      "1. one\n",
      "2. two\n",
      "3. three\n",
      "Select one of  ",
      "You must choose one of [1, 2, 3, one, two, three].\n?  ",
      "You must choose one of [1, 2, 3, one, two, three].\n?  "].joined(separator: "")
    
    XCTAssertEqual(promptPrinter.printed, prompt)
    XCTAssertEqual(choice, "three")
  }
  
  func testDiplaysChouceWithBlock() {
    PromptSettings.reader = DummyPromptReader(toReturn: "1")
    let choice = choose("Select one of  ", type: Double.self) {
      $0.addChoice("one") { 10 }
      $0.addChoice("two") { 20 }
      $0.addChoice("three") { 30 }
    }
    
    let prompt = [
      "1. one",
      "2. two",
      "3. three",
      "Select one of  "].joined(separator: "\n")
    
    XCTAssertEqual(promptPrinter.printed, prompt)
    XCTAssertEqual(choice, 10)
  }
  
  func testDisplaysChouceWithBlocl() {
    PromptSettings.reader = DummyPromptReader(toReturn: "two")
    let choice = choose("Select one of  ", type: Double.self) {
      $0.addChoice("one") { 10 }
      $0.addChoice("two", "three") { 20 }
    }
    
    let prompt = [
      "1. one",
      "2. two",
      "3. three",
      "Select one of  "].joined(separator: "\n")
    
    XCTAssertEqual(promptPrinter.printed, prompt)
    XCTAssertEqual(choice, 20)
  }
  
  func testDisplayChoicesWithBlockAndSelectThird() {
    PromptSettings.reader = DummyPromptReader(toReturn: "3")
    let choice = choose("Select one of  ", type: Double.self) {
      $0.addChoice("one") { 10 }
      $0.addChoice("two", "three") { 20 }
    }
    
    let prompt = [
      "1. one",
      "2. two",
      "3. three",
      "Select one of  "].joined(separator: "\n")
    
    XCTAssertEqual(promptPrinter.printed, prompt)
    XCTAssertEqual(choice, 20)
  }
  
  func tesetCreatesChoiceWithBlock() {
    PromptSettings.reader = DummyPromptReader(toReturn: "3")
    let choice: Int = choose {
      $0.promptQuestion = "Select one of  "
      $0.addChoice("one") { 10 }
      $0.addChoice("two", "three") { 20 }
    }
    
    let prompt = [
      "1. one",
      "2. two",
      "3. three",
      "Select one of  "].joined(separator: "\n")

    XCTAssertEqual(promptPrinter.printed, prompt)
    XCTAssertEqual(choice, 20)
  }
  
  func testCreatesChoiceWithBlockAndType() {
    PromptSettings.reader = DummyPromptReader(toReturn: "3")
    let choice = choose(Int.self) {
      $0.promptQuestion = "Select one of  "
      $0.addChoice("one") { 10 }
      $0.addChoice("two", "three") { 20 }
    }
    
    let prompt = [
      "1. one",
      "2. two",
      "3. three",
      "Select one of  "].joined(separator: "\n")
    
    XCTAssertEqual(promptPrinter.printed, prompt)
    XCTAssertEqual(choice, 20)
  }
}
