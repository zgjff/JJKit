//
//  JJToastDuration.swift
//  JJKit
//
//  Created by zgjff on 2023/8/9.
//

import Foundation

/// toast的显示时长
///
///     seconds: 显示时长: 秒
///     distantFuture: 只要不主动隐藏就会永久显示
public enum JJToastDuration {
    /// 显示时长: 秒
    case seconds(TimeInterval)
    /// 只要不主动隐藏就会永久显示
    case distantFuture
}
