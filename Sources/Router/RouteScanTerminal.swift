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
        /// #/
        case hash
        /// 字母
        case letters(_ value: String)
    }
}
