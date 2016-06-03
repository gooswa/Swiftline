//
//  Argument.swift
//  Swiftline
//
//  Created by Omar Abdelhafith on 26/11/2015.
//  Copyright © 2015 Omar Abdelhafith. All rights reserved.
//

import Foundation


struct Option {
  let argument: Argument
  var value: String?
  
  init(argument: Argument, value: String? = nil) {
    self.argument = argument
    self.value = value
  }
}

struct Argument {
  
  enum ArgumentType {
    case ShortFlag
    case LongFlag
    case NotAFlag
    case FlagsTerminator
    
    var isFlag: Bool {
      return self != .NotAFlag
    }
    
    var isFlagTerminator: Bool {
      return self == .FlagsTerminator
    }
    
    init(_ argument: String) {
      
      if argument == "--" {
        self = .FlagsTerminator
      } else if argument.hasPrefix("--") {
        self = .LongFlag
      } else if argument.hasPrefix("-") {
        self = .ShortFlag
      } else {
        self = .NotAFlag
      }
    }
  }
  
  let type: ArgumentType
  let argument: String
  
  init(_ argument: String) {
    self.type = ArgumentType(argument)
    self.argument = argument
  }
  
  var isFlag: Bool {
    return type.isFlag
  }
  
  var isFlagTerminator: Bool {
    return type.isFlagTerminator
  }
  
  var name: String {
    switch type {
    case .NotAFlag:
      return argument
    case .ShortFlag:
      return argument[1..<argument.utf8.count]
    case .LongFlag:
      return argument[2..<argument.utf8.count]
    case .FlagsTerminator:
      return ""
    }
  }
  
}

extension String {
  public subscript (range: Range<Int>) -> String {
    let length = self.lengthOfBytes(using: NSUTF8StringEncoding)
    
    var distanceFromEndIndex = length - range.upperBound
    if distanceFromEndIndex < 0 {
      distanceFromEndIndex = 0
    }
    
    let start = self.index(self.startIndex, offsetBy: range.lowerBound)
    let end = self.index(self.endIndex, offsetBy: -distanceFromEndIndex)
    
    let actualRange: Range = start..<end
    
    return String(self[actualRange])
  }
  
  public subscript (startOffset startOffset: Int, endOffset endOffset: Int) -> String {
    let rangeWithInset: Range = (self.index(self.startIndex, offsetBy: startOffset))..<(self.index(self.endIndex, offsetBy: -endOffset))
    return String(self[rangeWithInset])
  }
  
  func replacingOccurrences(of: String, with: String) -> String {
    return replacingOccurrences(of: of, with: with, options: .literalSearch, range: self.startIndex..<self.endIndex)
  }
  
  func replacingOccurrences(of: String, with: String, startOffset: Int, endOffset: Int) -> String {
    let range = self.index(self.startIndex, offsetBy: startOffset)..<self.index(self.endIndex, offsetBy: -endOffset)
    return replacingOccurrences(of: of, with: with, options: .literalSearch, range: range)
  }
}
