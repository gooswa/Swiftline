//
//  Glob.swift
//  Swiftline
//
//  Created by Omar Abdelhafith on 30/11/2015.
//  Copyright © 2015 Omar Abdelhafith. All rights reserved.
//

import Foundation
import Darwin

class Glob {
  
  static func expand(_ pattern: String) -> [String] {
    var files = [String]()
    var gt: glob_t = glob_t()

    if (glob(pattern.cString(using: NSUTF8StringEncoding)!, 0, nil, &gt) == 0) {
      
      for i in (0..<gt.gl_matchc) {
        files.append(String(cString: gt.gl_pathv[Int(i)]!, encoding: NSUTF8StringEncoding)!)
      }
      
    }
    
    globfree(&gt);
    return files
  }
  
}
