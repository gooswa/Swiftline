import Foundation
import XCTest
@testable import Swiftline


class ColorizerTest: XCTestCase {
  
  func testColorizeForgroundWithBlack() {
    let string  = "the string".f.Black
    XCTAssertEqual(string, "\u{001B}[30mthe string\u{001B}[0m")
  }
  
  func testColorizeForgroundWithRed() {
    let string  = "the string".f.Red
    XCTAssertEqual(string, "\u{001B}[31mthe string\u{001B}[0m")
  }
  
  func testColorizeForgroundWithGreen() {
    let string  = "the string".f.Green
    XCTAssertEqual(string, "\u{001B}[32mthe string\u{001B}[0m")
  }
  
  func testColorizeForgroundWithYellow() {
    let string  = "the string".f.Yellow
    XCTAssertEqual(string, "\u{001B}[33mthe string\u{001B}[0m")
  }
  
  func testColorizeForgroundWithBlue() {
    let string  = "the string".f.Blue
    XCTAssertEqual(string, "\u{001B}[34mthe string\u{001B}[0m")
  }
  
  func testColorizeForgroundWithMagenta() {
    let string  = "the string".f.Magenta
    XCTAssertEqual(string, "\u{001B}[35mthe string\u{001B}[0m")
  }
  
  func testColorizeForgroundWithCyan() {
    let string  = "the string".f.Cyan
    XCTAssertEqual(string, "\u{001B}[36mthe string\u{001B}[0m")
  }
  
  func testColorizeForgroundWithWhite() {
    let string  = "the string".f.White
    XCTAssertEqual(string, "\u{001B}[37mthe string\u{001B}[0m")
  }
  
  
  func testColorizeBackgroundWithBlack() {
    let string  = "the string".b.Black
    XCTAssertEqual(string, "\u{001B}[40mthe string\u{001B}[0m")
  }
  
  func testColorizeBackgroundWithRed() {
    let string  = "the string".b.Red
    XCTAssertEqual(string, "\u{001B}[41mthe string\u{001B}[0m")
  }
  
  func testColorizeBackgroundWithGreen() {
    let string  = "the string".b.Green
    XCTAssertEqual(string, "\u{001B}[42mthe string\u{001B}[0m")
  }
  
  func testColorizeBackgroundWithYellow() {
    let string  = "the string".b.Yellow
    XCTAssertEqual(string, "\u{001B}[43mthe string\u{001B}[0m")
  }
  
  func testColorizeBackgroundWithBlue() {
    let string  = "the string".b.Blue
    XCTAssertEqual(string, "\u{001B}[44mthe string\u{001B}[0m")
  }
  
  func testColorizeBackgroundWithMagenta() {
    let string  = "the string".b.Magenta
    XCTAssertEqual(string, "\u{001B}[45mthe string\u{001B}[0m")
  }
  
  func testColorizeBackgroundWithCyan() {
    let string  = "the string".b.Cyan
    XCTAssertEqual(string, "\u{001B}[46mthe string\u{001B}[0m")
  }
  
  func testColorizeBackgroundWithWhite() {
    let string  = "the string".b.White
    XCTAssertEqual(string, "\u{001B}[47mthe string\u{001B}[0m")
  }
  
  func testPrintsBoldStrings() {
    let string  = "the string".s.Bold
    XCTAssertEqual(string, "\u{001B}[1mthe string\u{001B}[0m")
  }
  
  func testPrintsItalicStrings() {
    let string  = "the string".s.Italic
    XCTAssertEqual(string, "\u{001B}[3mthe string\u{001B}[0m")
  }

  func testPrintsUnderlineStrings() {
    let string  = "the string".s.Underline
    XCTAssertEqual(string, "\u{001B}[4mthe string\u{001B}[0m")
  }
  
  func testPrintsInverseStrings() {
    let string  = "the string".s.Inverse
    XCTAssertEqual(string, "\u{001B}[7mthe string\u{001B}[0m")
  }
  
  func testPrintsStrikeThroughStrings() {
    let string  = "the string".s.Strikethrough
    XCTAssertEqual(string, "\u{001B}[9mthe string\u{001B}[0m")
  }
  
  func testPrintsBoldOffStrings() {
    let string  = "the string".s.BoldOff
    XCTAssertEqual(string, "\u{001B}[22mthe string\u{001B}[0m")
  }
  
  func testPrintsItalicOffStrings() {
    let string  = "the string".s.ItalicOff
    XCTAssertEqual(string, "\u{001B}[23mthe string\u{001B}[0m")
  }
  
  func testPrintsUnderlineOffStrings() {
    let string  = "the string".s.UnderlineOff
    XCTAssertEqual(string, "\u{001B}[24mthe string\u{001B}[0m")
  }
  
  func testPrintsInverseOffStrings() {
    let string  = "the string".s.InverseOff
    XCTAssertEqual(string, "\u{001B}[27mthe string\u{001B}[0m")
  }
  
  func testPrintsStrikeThroughOffStrings() {
    let string  = "the string".s.StrikethroughOff
    XCTAssertEqual(string, "\u{001B}[29mthe string\u{001B}[0m")
  }
  
  func testPrintsStrikeResetStrings() {
    let string  = "the string".s.Reset
    XCTAssertEqual(string, "\u{001B}[0mthe string\u{001B}[0m")
  }
  
  func testPrintsMixingStyles() {
    let string  = "the string".s.Bold.f.Red.b.White
    XCTAssertEqual(string, "\u{001B}[47;31;1mthe string\u{001B}[0m")
  }
}
