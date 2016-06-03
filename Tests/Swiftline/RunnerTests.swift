import XCTest
@testable import Swiftline


class RunnerTests: XCTestCase {
  var promptPrinter: DummyPromptPrinter!
  
  override func setUp() {
    promptPrinter = DummyPromptPrinter()
    PromptSettings.printer = promptPrinter
  }
  
  func testExecuteACommandWithDummyExecutor() {
    var dummyExecutor: DummyTaskExecutor!
    
    dummyExecutor = DummyTaskExecutor(status: 0, output: "123", error: "")
    CommandExecutor.currentTaskExecutor = dummyExecutor
    let res = 🏃.run("ls -all")
    
    XCTAssertEqual(res.exitStatus, 0)
    XCTAssertEqual(res.stdout, "123")
    XCTAssertEqual(res.stderr, "")
    
    XCTAssertEqual(dummyExecutor.commandsExecuted, ["ls -all"])
  }
  
  func testExecuteACommandWithErrorDummyExecutor() {
    var dummyExecutor: DummyTaskExecutor!
    
    dummyExecutor = DummyTaskExecutor(status: 1, output: "", error: "123")
    CommandExecutor.currentTaskExecutor = dummyExecutor
    let res = 🏃.run("test test test")
    
    XCTAssertEqual(res.exitStatus, 1)
    XCTAssertEqual(res.stdout, "")
    XCTAssertEqual(res.stderr, "123")
    
    XCTAssertEqual(dummyExecutor.commandsExecuted, ["test test test"])
  }
  
  func testExecutesACommandWithArgumentsSeparated() {
    var dummyExecutor: DummyTaskExecutor!
    
    dummyExecutor = DummyTaskExecutor(status: 1, output: "", error: "123")
    CommandExecutor.currentTaskExecutor = dummyExecutor
    
    _ = 🏃.run("ls", args: ["-all"])
    XCTAssertEqual(dummyExecutor.commandsExecuted, ["ls -all"])
    
    _ = 🏃.run("echo", args: "bbb")
    XCTAssertEqual(dummyExecutor.commandsExecuted, ["ls -all", "echo bbb"])
  }
  
  func testItEchosBackSTDOUT() {
    let dummyExecutor = DummyTaskExecutor(status: 1, output: "Command output was", error: "error out")
    CommandExecutor.currentTaskExecutor = dummyExecutor
    
    _ = 🏃.run("ls", args: ["-all"]) { s in
      s.echo = [.Stdout, .Stderr]
    }
    
    XCTAssertEqual(dummyExecutor.commandsExecuted, ["ls -all"])
    let output = [
      "Stdout: ",
      "Command output was",
      "Stderr: ",
      "error out\n"].joined(separator: "\n")
    
    XCTAssertEqual(promptPrinter.printed, output)
  }
  
  func testItDoesNotEchoIfEmpty() {
    let dummyExecutor = DummyTaskExecutor(status: 1, output: "", error: "error out")
    CommandExecutor.currentTaskExecutor = dummyExecutor
    
    _ = 🏃.run("ls", args: ["-all"]) { s in
      s.echo = [.Stdout, .Stderr]
    }
    
    XCTAssertEqual(dummyExecutor.commandsExecuted, ["ls -all"])
    
    let output = [
      "Stderr: ",
      "error out\n"].joined(separator: "\n")
    XCTAssertEqual(promptPrinter.printed, output)
  }
  
  func testItEchosBackTheCommand() {
    let dummyExecutor = DummyTaskExecutor(status: 1, output: "", error: "error out")
    CommandExecutor.currentTaskExecutor = dummyExecutor
    
    _ = 🏃.run("ls", args: ["-all"]) { s in
      s.echo = .Command
    }
    
    XCTAssertEqual(dummyExecutor.commandsExecuted, ["ls -all"])
    
    let output = [
      "Command: ",
      "ls -all\n"].joined(separator: "\n")
    
    XCTAssertEqual(promptPrinter.printed, output)
  }
  
  func testItEchosBackSTDOUTOnly() {
    let dummyExecutor = DummyTaskExecutor(status: 1, output: "Command output was 2", error: "error out 2")
    CommandExecutor.currentTaskExecutor = dummyExecutor
    
    _ = 🏃.run("ls") {
      $0.echo = .Stdout
    }
    
    let output = [
      "Stdout: ",
      "Command output was 2\n"].joined(separator: "\n")
    XCTAssertEqual(promptPrinter.printed, output)
  }
  
  func testEchosBackStderrOnly() {
    let dummyExecutor = DummyTaskExecutor(status: 1, output: "Command output was 2", error: "error out 2")
    CommandExecutor.currentTaskExecutor = dummyExecutor
    
    _ = 🏃.run("ls") {
      $0.echo = .Stderr
    }
    
    let output = [
      "Stderr: ",
      "error out 2\n"].joined(separator: "\n")
    XCTAssertEqual(promptPrinter.printed, output)
  }
  
  func testEchosBackSTDERROnly() {
    let dummyExecutor = DummyTaskExecutor(status: 1, output: "Command output was 2", error: "error out 2")
    CommandExecutor.currentTaskExecutor = dummyExecutor
    
    _ = 🏃.run("ls") {
      $0.echo = .None
    }
    
    XCTAssertEqual(promptPrinter.printed, "")
  }
  
  func testExecutesCommandWithAnEcho() {
    let dummyExecutor = DummyTaskExecutor(status: 1, output: "Command output was 2", error: "error out 2")
    CommandExecutor.currentTaskExecutor = dummyExecutor
    
    _ = 🏃.run("ls -all", echo: [.Command])
    
    XCTAssertEqual(dummyExecutor.commandsExecuted, ["ls -all"])
    
    let output = [
      "Command: ",
      "ls -all\n"].joined(separator: "\n")
    XCTAssertEqual(promptPrinter.printed, output)
  }
  
  func testItExecutesls() {
    CommandExecutor.currentTaskExecutor = ActualTaskExecutor()
    let res = 🏃.run("ls -all")
    
    XCTAssertEqual(res.exitStatus, 0)
    XCTAssertNotEqual(res.stdout, "")
    XCTAssertEqual(res.stderr, "")
  }
  
  func testItExcutesDry() {
    CommandExecutor.currentTaskExecutor = ActualTaskExecutor()
    let res = 🏃.run("ls -all") {
      $0.dryRun = true
    }
    
    XCTAssertEqual(res.exitStatus, 0)
    XCTAssertEqual(res.stdout, "")
    XCTAssertEqual(res.stderr, "")
    XCTAssertEqual(promptPrinter.printed, "Executed command 'ls -all'\n")
  }
  
  func testInteractiveRun() {
    CommandExecutor.currentTaskExecutor = InteractiveTaskExecutor()
    let res = 🏃.runWithoutCapture("ls -all")
    
    XCTAssertEqual(res, 0)
  }
}
