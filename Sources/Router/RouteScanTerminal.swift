//
//  RouteScanTerminal.swift
//  JJKit
//
//  Created by zgjff on 2022/9/30.
//

import Foundation

extension JJRouter.Scanner {
    internal enum Terminal {
        /// /
        case slash
        /// ?
        case query
        /// =
        case equal
        /// &
        case and
        /// :
        case variable
        /// #
        case fragment
        case letters(_ value: String)
        
        // TODO: - 添加hash模式url支持   #/xxx 格式
    }
}
