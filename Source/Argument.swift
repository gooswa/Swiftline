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
    case shortFlag
    case longFlag
    case notAFlag
    case flagsTerminator
    
    var isFlag: Bool {
      return self != .notAFlag
    }
    
    var isFlagTerminator: Bool {
      return self == .flagsTerminator
    }
    
    init(_ argument: String) {
      
      if argument == "--" {
        self = .flagsTerminator
      } else if argument.hasPrefix("--") {
        self = .longFlag
      } else if argument.hasPrefix("-") {
        self = .shortFlag
      } else {
        self = .notAFlag
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
    case .notAFlag:
      return argument
    case .shortFlag:
      return argument[1..<argument.utf8.count]
    case .longFlag:
      return argument[2..<argument.utf8.count]
    case .flagsTerminator:
      return ""
    }
  }
  
}

extension String {
  public subscript (range: Range<Int>) -> String {
    let length = self.lengthOfBytes(using: String.Encoding.utf8)
    
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
    return replacingOccurrences(of: of, with: with, options: .literal, range: self.startIndex..<self.endIndex)
  }
  
  func replacingOccurrences(of: String, with: String, startOffset: Int, endOffset: Int) -> String {
    let range = self.index(self.startIndex, offsetBy: startOffset)..<self.index(self.endIndex, offsetBy: -endOffset)
    return replacingOccurrences(of: of, with: with, options: .literal, range: range)
  }
}
