//
//  DebugLog.swift
//  RxSwift-1
//
//  Created by ULS on 4/4/18.
//  Copyright © 2018 ULS. All rights reserved.
//

import Foundation

public enum DebugLog {
    case DebugMode

    public func dlog(object: Any, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line) {
        #if DEBUG
            let className = (fileName as NSString).lastPathComponent
            print("class:<\(className)> function: \(functionName) line:[#\(lineNumber)]| object:\(object)\n")
        #endif
    }
}


