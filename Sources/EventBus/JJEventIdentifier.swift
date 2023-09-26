//
//  JJEventIdentifier.swift
//  JJEventBus
//
//  Created by zgjff on 2023/9/18.
//

import Foundation
/// 事件消息唯一标识协议
public protocol JJEventIdentifier: CustomStringConvertible, CustomDebugStringConvertible {
    /// 事件消息唯一标识
    var identifier: String { get }
}

extension String: JJEventIdentifier {
    public var identifier: String {
        self
    }
}
