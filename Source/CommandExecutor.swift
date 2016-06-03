//
//  CommandExecutor.swift
//  CommandExecutor
//
//  Created by Omar Abdelhafith on 05/11/2015.
//  Copyright © 2015 Omar Abdelhafith. All rights reserved.
//

import Foundation


typealias ExecutorReturnValue = (status: Int, standardOutput: TaskPipe, standardError: TaskPipe)

class CommandExecutor {
  
  static var currentTaskExecutor: TaskExecutor = ActualTaskExecutor()
  
  class func execute(_ commandParts: [String]) -> ExecutorReturnValue {
    return currentTaskExecutor.execute(commandParts)
  }
}


protocol TaskExecutor {
  func execute(_ commandParts: [String]) -> ExecutorReturnValue
}

class DryTaskExecutor: TaskExecutor {
  
  func execute(_ commandParts: [String]) -> ExecutorReturnValue {
    let command = commandParts.joined(separator: " ")
    PromptSettings.print("Executed command '\(command)'")
    return (0,
      Dryipe(dataToReturn: "".data(using: NSUTF8StringEncoding)!),
      Dryipe(dataToReturn: "".data(using: NSUTF8StringEncoding)!))
  }
}

class ActualTaskExecutor: TaskExecutor {
  
  func execute(_ commandParts: [String]) -> ExecutorReturnValue  {
    let task = NSTask()

    task.launchPath = "/usr/bin/env"
    task.arguments = commandParts
    
    let stdoutPipe = NSPipe()
    let stderrPipe = NSPipe()
    
    task.standardOutput = stdoutPipe
    task.standardError = stderrPipe
    task.launch()
    task.waitUntilExit()
    
    return (Int(task.terminationStatus), stdoutPipe, stderrPipe)
  }
}

class InteractiveTaskExecutor: TaskExecutor {
  
  func execute(_ commandParts: [String]) -> ExecutorReturnValue  {
    let result = system(commandParts.joined(separator: " "))
    
    let emptyPipe = Dryipe(dataToReturn: "".data(using: NSUTF8StringEncoding)!)
    return (Int(result), emptyPipe, emptyPipe)
  }
}

class DummyTaskExecutor: TaskExecutor {
  
  var commandsExecuted: [String] = []
  let statusCodeToReturn: Int
  
  let errorToReturn: String
  let outputToReturn: String
  
  init(status: Int, output: String, error: String) {
    statusCodeToReturn = status
    outputToReturn = output
    errorToReturn = error
  }
  
  func execute(_ commandParts: [String]) -> ExecutorReturnValue {
    let command = commandParts.joined(separator: " ")
    commandsExecuted.append(command)
    
    return (statusCodeToReturn,
            Dryipe(dataToReturn: outputToReturn.data(using: NSUTF8StringEncoding)!),
      Dryipe(dataToReturn: errorToReturn.data(using: NSUTF8StringEncoding)!))
  }
}
