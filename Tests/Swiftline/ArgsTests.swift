import Foundation
import XCTest
@testable import Swiftline

class ArgsTests: XCTestCase {
  
  func testReturnsTheCorrectNumberOfArgsPassed() {
    XCTAssertTrue(Args.all.count > 0)
  }
  
  func testReturnsTheExcatArgumentPassedToApp() {
    ProcessInfo.internalProcessInfo = DummyProcessInfo("1", "2", "3")
    XCTAssertEqual(Args.all, ["1", "2", "3"])
  }
  
  func testCreatsAHashFromPassedArgs() {
    ProcessInfo.internalProcessInfo = DummyProcessInfo("excutable_name", "-f", "file.rb", "--integer", "1", "Some custom one", "one", "two", "--no-ff")
    let _ = [
      "f": "file.rb",
      "integer": "1",
      "no-ff": ""]
    
    //    XCTAssertEqual(Args.parsed.flags, result)
    XCTAssertEqual(Args.parsed.parameters, ["Some custom one", "one", "two"])
    XCTAssertEqual(Args.parsed.command, "excutable_name")
  }
  
  func testReturnsEmptyForEmptyArray() {
    let r = ArgsParser.parseFlags([])
    XCTAssertEqual(r.0.count, 0)
    XCTAssertEqual(r.1.count, 0)
  }
  
  func testReturnsAllLeadingNonFlagParams() {
    let r = ArgsParser.parseFlags(["omar", "hello", "-f", "test", "--help"])
    XCTAssertEqual(r.1, ["omar", "hello"])
  }
  
  func testReturnsAllTailingNonFlags() {
    let r = ArgsParser.parseFlags(["-f", "test", "--help", "x",  "omar", "hello"])
    
    XCTAssertEqual(r.1, ["omar", "hello"])
  }
  
  func testReturnsAllMixedNonFlags() {
    let r = ArgsParser.parseFlags(["-f", "test", "omar", "--help", "x", "hello"])
    XCTAssertEqual(r.1, ["omar", "hello"])
  }
  
  func testReturnsAllFlagsIfTheyAreSet() {
    let r = ArgsParser.parseFlags(["-f", "test", "omar", "--help", "x", "hello"])
    
    XCTAssertEqual(r.0[0].argument.name, "f")
    XCTAssertEqual(r.0[0].value, "test")
    
  XCTAssertEqual(r.0[1].argument.name, "help")
    XCTAssertEqual(r.0[1].value, "x")
  }
  
  func testReturnsAllFlagsIfSomeAreNotSet() {
    let r = ArgsParser.parseFlags(["-f", "-w", "omar", "--help", "x", "hello"])
    
    XCTAssertEqual(r.0[0].argument.name, "f")
    XCTAssertNil(r.0[0].value)
    
    XCTAssertEqual(r.0[1].argument.name, "w")
    XCTAssertEqual(r.0[1].value, "omar")
    
    XCTAssertEqual(r.0[2].argument.name, "help")
    XCTAssertEqual(r.0[2].value, "x")
  }
  
  func testParsesComplexFlags() {
    let r = ArgsParser.parseFlags(["one", "-f", "-w", "omar", "two", "--help", "x", "hello"])
    
    XCTAssertEqual(r.1, ["one", "two", "hello"])

    XCTAssertEqual(r.0[0].argument.name, "f")
    XCTAssertNil(r.0[0].value)
    
    XCTAssertEqual(r.0[1].argument.name, "w")
    XCTAssertEqual(r.0[1].value, "omar")

    XCTAssertEqual(r.0[2].argument.name, "help")
    XCTAssertEqual(r.0[2].value, "x")
  }

  func testStopsParsingFlagsAfterLimit() {
    let r = ArgsParser.parseFlags(["one", "-f", "-w", "omar", "two", "--", "--help", "x", "hello"])

    XCTAssertEqual(r.1, ["one", "two", "--help", "x", "hello"])
    XCTAssertEqual(r.0[0].argument.name, "f")
    XCTAssertNil(r.0[0].value)
    
    XCTAssertEqual(r.0[1].argument.name, "w")
    XCTAssertEqual(r.0[1].value, "omar")
  }
  
  func testKnowsTheArgTypeForAString() {
    XCTAssertEqual(Argument.ArgumentType("-f"), Argument.ArgumentType.ShortFlag)
    XCTAssertEqual(Argument.ArgumentType("--force"), Argument.ArgumentType.LongFlag)
    
    XCTAssertEqual(Argument.ArgumentType("--no-repo-update"), Argument.ArgumentType.LongFlag)
    XCTAssertEqual(Argument.ArgumentType("not an arg"), Argument.ArgumentType.NotAFlag)
    
    XCTAssertEqual(Argument.ArgumentType("not-an-arg"), Argument.ArgumentType.NotAFlag)
  }
  
  func testKnowsIfAnArgIsAFlag() {
    XCTAssertTrue(Argument.ArgumentType.ShortFlag.isFlag)
    XCTAssertTrue(Argument.ArgumentType.LongFlag.isFlag)
    XCTAssertFalse(Argument.ArgumentType.NotAFlag.isFlag)
  }
  
  func testNormalizesAFlag() {
    XCTAssertEqual(Argument("-f").name, "f")
    XCTAssertEqual(Argument("--force").name, "force")
    XCTAssertEqual(Argument("--no-repo-update").name, "no-repo-update")
    XCTAssertEqual(Argument("--no-repo-update").name, "no-repo-update")
    XCTAssertEqual(Argument("not an arg").name, "not an arg")
    XCTAssertEqual(Argument("not-an-arg").name, "not-an-arg")
  }
}
