//
//  StoreValueManager.swift
//  Demo
//
//  Created by 123 on 2018/6/29.
//  Copyright © 2018年 郑桂杰. All rights reserved.
//

import Foundation
struct StoreValueManager {
    static func get<ValueType: Any>(from base: Any,
                                    key: UnsafeRawPointer,
                                    initialiser: () -> ValueType) -> ValueType {
        if let associated = objc_getAssociatedObject(base, key) as? ValueType { return associated }
        let associated = initialiser()
        objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN)
        return associated
    }
    
    static func set<ValueType: Any>(
        for base: Any,
        key: UnsafeRawPointer,
        value: ValueType) {
        objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
    }
}

