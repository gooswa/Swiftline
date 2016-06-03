import XCTest
@testable import Swiftline

class ENVTests: XCTestCase {
  
  override func setUp() {
    CommandExecutor.currentTaskExecutor = ActualTaskExecutor()
  }
  
  func testReturnNilIfNoEnv() {
    XCTAssertNil(Env.get("AAAAA"))
  }
  
  func testReadsEnvVariables() {
    Env.set("SomeKey", "SomeValue")
    XCTAssertEqual(Env.get("SomeKey"), "SomeValue")
  }
  
  func testItClearsEnvVariables() {
    Env.set("SomeKey", "SomeValue")
    XCTAssertEqual(Env.get("SomeKey"), "SomeValue")
    
    Env.set("SomeKey", nil)
    XCTAssertNil(Env.get("SomeKey"))
  }
  
  func testItClearsAllEnvVariables() {
    Env.set("SomeKey", "SomeValue")
    XCTAssertEqual(Env.get("SomeKey"), "SomeValue")
    
    Env.clear()
    XCTAssertNil(Env.get("SomeKey"))
  }
  
  func testItReturnsAllKeys() {
    Env.clear()
    Env.set("key1", "value1")
    Env.set("key2", "value2")
    
    XCTAssertEqual(Env.keys, ["key1", "key2"])
    Env.clear()
    XCTAssertEqual(Env.keys.count, 0)
  }
  
  func testItReturnsAllValues() {
    Env.clear()
    Env.set("key1", "value1")
    Env.set("key2", "value2")
    
    XCTAssertEqual(Env.values, ["value1", "value2"])
  }
  
  func testItChecksKeyExist() {
    Env.clear()
    Env.set("key1", "value1")
    Env.set("key2", "value2")
    
    XCTAssertTrue(Env.hasKey("key1"))
    Env.clear()
    XCTAssertFalse(Env.hasKey("key1"))
  }
  
  func testItChecksValueExist() {
    Env.clear()
    Env.set("key1", "value1")
    Env.set("key2", "value2")
    
    XCTAssertTrue(Env.hasValue("value1"))
    Env.clear()
    XCTAssertFalse(Env.hasValue("value1"))
  }
  
  func testEnumeratesKeysAndValues() {
    Env.clear()
    Env.set("key1", "value1")
    Env.set("key2", "value2")
    
    Env.eachPair { (key, value) in
      XCTAssertTrue(["key1", "key2"].contains(key))
      XCTAssertTrue(["value1", "value2"].contains(value))
    }
  }
}
