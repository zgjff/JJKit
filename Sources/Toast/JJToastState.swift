//
//  JJToastState.swift
//  JJToast
//
//  Created by zgjff on 2023/8/11.
//

import Foundation

/// `toast`状态
public enum JJToastState {
    /// 正在展示动画
    case presenting
    /// 已经展示
    case presented
    /// 正在消失动画
    case dismissing
    /// 已经消失
    case dismissed
}
