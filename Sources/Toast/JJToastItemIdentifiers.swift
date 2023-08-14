//
//  JJToastItemIdentifiers.swift
//  JJKit
//
//  Created by zgjff on 2023/8/11.
//

import Foundation

/// `toast`样式标志符
internal struct JJToastItemIdentifiers {
    let identifier: String
}

extension JJToastItemIdentifiers {
    static let text = JJToastItemIdentifiers(identifier: "JJTextToastItem")
    static let activity = JJToastItemIdentifiers(identifier: "JJActivityToastItem")
    static let arcrotation = JJToastItemIdentifiers(identifier: "JJArcrotationToastItem")
    static let image = JJToastItemIdentifiers(identifier: "JJImageToastItem")
}
