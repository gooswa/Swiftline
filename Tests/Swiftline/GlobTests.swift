import XCTest
import Foundation
@testable import Swiftline

class GlobTests: XCTestCase {
  
  func testExpandsGlob() {
    let expanded = Glob.expand("\(NSFileManager().currentDirectoryPath)/*")
    XCTAssertTrue(expanded.count > 0)
  }
}
