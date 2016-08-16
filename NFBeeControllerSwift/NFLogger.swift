//
//  NFLogger.swift
//  NFBeeControllerSwift
//
//  Created by jiangpengcheng on 27/7/16.
//  Copyright © 2016年 jiangpengcheng. All rights reserved.
//

import Foundation

/// 设置显示的日志级别，默认Debug
/// 如果设置了日志级别，依然没有显示日志，请按照下面的方法进行设置。
/// 注意：在过去 Objective-C 项目里，针对 Development 环境和 Release 环境使用不同的方法
/// 进行 Logging 我们是通过 Preprocessor Macros 来进行的。
/// 比如 DEBUG 是作为一个默认的 Macro 加进去的. 
/// 只要有 $(inherited) 这个在，DEBUG 这个Macro就会存在项目的 Development 模式
/// Swift 项目里面我们如何去区分 Debug 和 Release 模式呢 ?
/// 需要到 Target 的 Build Settings 里面，找到 Swift Compiler Custom Flags，
/// 在 Debug 处传入一个 `-D DEBUG`或者`-DDEBUG` 即可。
public var NFLoggerLevel: NFLogLevel = .Debug

public enum NFLogLevel: Int {
    case Verbose = 1, Debug, Info, Error, High
    
    func toString() -> String {
        switch self {
        case .Verbose:
            return "VERBOSE"
        case .Debug:
            return "DEBUG"
        case .Info:
            return "INFO"
        case .Error:
            return "ERROR"
        case .High:
            return "HIGH"
        }
    }
}

public func NFLogVerbose<T>(message: T, file: String = #file, method: String = #function, line: Int = #line){
    #if DEBUG
        NFLog(message, maxLogLevel: .Verbose, file: file, method: method, line: line)
    #endif
}

public func NFLogDebug<T>(message: T, file: String = #file, method: String = #function, line: Int = #line){
    #if DEBUG
        NFLog(message, maxLogLevel: .Debug, file: file, method: method, line: line)
    #endif
}

public func NFLogInfo<T>(message: T, file: String = #file, method: String = #function, line: Int = #line){
    #if DEBUG
        NFLog(message, maxLogLevel: .Info, file: file, method: method, line: line)
    #endif
}

public func NFLogError<T>(message: T, file: String = #file, method: String = #function, line: Int = #line){
    #if DEBUG
        NFLog(message, maxLogLevel: .Error, file: file, method: method, line: line)
    #endif
}


public func NFLogHigh<T>(message: T, file: String = #file, method: String = #function, line: Int = #line){
    #if DEBUG
        NFLog(message, maxLogLevel: .High, file: file, method: method, line: line)
    #endif
}

private func NFLog<T>(message: T, maxLogLevel: NFLogLevel, file: String = #file, method: String = #function, line: Int = #line)
{
    #if DEBUG
        if NFLoggerLevel.rawValue <= maxLogLevel.rawValue {
            print("\(curentTimeString()) [\((file as NSString).lastPathComponent):\(line)][\(maxLogLevel.toString())] \(message)")
        }
    #endif
}

private func curentTimeString() ->String {
    let dfmatter = NSDateFormatter()
    dfmatter.dateFormat="yyyy-MM-dd HH:mm:ss.SSS"
    return dfmatter.stringFromDate(NSDate())
}

