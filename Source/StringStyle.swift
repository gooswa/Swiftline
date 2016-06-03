//
//  StringStyle.swift
//  StringStyle
//
//  Created by Omar Abdelhafith on 31/10/2015.
//  Copyright © 2015 Omar Abdelhafith. All rights reserved.
//

import Foundation


let startOfCode = "\u{001B}["
let endOfCode = "m"
let codesSeperators = ";"


protocol StringStyle {
  var rawValue: Int { get }
  func colorize(_ string: String) -> String
}


extension StringStyle {
  
  func colorize(_ string: String) -> String {
    
    if hasAnyStyleCode(string) {
      return colorizeStringAndAddCodeSeperators(string)
    } else {
      return colorizeStringWithoutPriorCode(string)
    }
  }
  
  private func colorizeStringWithoutPriorCode(_ string: String) -> String {
    return "\(preparedColorCode(self.rawValue))\(string)\(endingColorCode())"
  }
  
  private func colorizeStringAndAddCodeSeperators(_ string: String) -> String {
    //To refactor and use regex matching instead of replacing strings and using tricks
    let stringByRemovingEnding = removeEndingCode(string)
    let sringwWithStart = "\(preparedColorCode(self.rawValue))\(stringByRemovingEnding)"
    
    let stringByAddingCodeSeperator = addCommandSeperators(sringwWithStart)
    
    return "\(stringByAddingCodeSeperator)\(endingColorCode())"
  }
  
  private func preparedColorCode(_ color: Int) -> String {
    return "\(startOfCode)\(color)\(endOfCode)"
  }
  
  private func hasAnyStyleCode(_ string: String) -> Bool {
    return string.contains(startOfCode)
  }
  
  private func addCommandSeperators(_ string: String) -> String {
    
    return string
      .replacingOccurrences(of: startOfCode, with: ";", startOffset: 1, endOffset: 1)
      .replacingOccurrences(of: "m;", with: ";", startOffset: 1, endOffset: 1)
  }
  
  private func removeEndingCode(_ string: String) -> String {
    return string.replacingOccurrences(of: endingColorCode(), with: "", startOffset: 1, endOffset: 0)
  }
  
  private func endingColorCode() -> String {
    return preparedColorCode(0)
  }
}


enum ForegroundColor: Int, StringStyle {
  
  case Black = 30
  case Red = 31
  case Green = 32
  case Yellow = 33
  case Blue = 34
  case Magenta = 35
  case Cyan = 36
  case White = 37
}


enum BackgroundColor: Int, StringStyle {
  
  case Black = 40
  case Red = 41
  case Green = 42
  case Yellow = 43
  case Blue = 44
  case Magenta = 45
  case Cyan = 46
  case White = 47
}


enum StringTextStyle: Int, StringStyle {
  
  case Reset = 0
  case Bold = 1
  case Italic = 3
  case Underline = 4
  case Inverse = 7
  case Strikethrough = 9
  case BoldOff = 22
  case ItalicOff = 23
  case UnderlineOff = 24
  case InverseOff = 27
  case StrikethroughOff = 29
}
