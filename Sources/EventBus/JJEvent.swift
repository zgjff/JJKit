//
//  JJEvent.swift
//  JJEventBus
//
//  Created by zgjff on 2023/9/15.
//

import Foundation

public protocol JJEvent {
    associatedtype Element
    /// 事件消息唯一标识
    var identifier: JJEventIdentifier { get }
    /// 事件消息携带内容
    var context: Element { get }
}

/// 默认的事件消息model
public struct JJDefaultEvent: JJEvent {
    public let identifier: any JJEventIdentifier
    public let context: Any
    internal let file: String
    internal let function: String
    internal let line: UInt
    public init(identifier: any JJEventIdentifier, context: Any, _ file: String = #file, _ function: String = #function, _ line: UInt = #line) {
        self.identifier = identifier
        self.context = context
        self.file = file
        self.function = function
        self.line = line
    }
}

extension JJDefaultEvent: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return "JJDefaultEvent: \(file).\(function):\(line)---[identifier: \(identifier), context: \(String(describing: context))]"
    }
    
    public var debugDescription: String {
        description
    }
}
