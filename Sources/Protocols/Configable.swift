//
//  Configable.swift
//  Demo
//
//  Created by 123 on 2018/6/29.
//  Copyright © 2018年 郑桂杰. All rights reserved.
//

import Foundation
public protocol Configable {}

extension Configable where Self: AnyObject {
    @discardableResult
    public func config(_ make: (Self) -> Void) -> Self {
        make(self)
        return self
    }
}

extension Configable where Self: NSObject {
    public static func alloc(_ make: (Self) -> Void) -> Self {
        let object = Self()
        make(object)
        return object
    }
}

extension Configable where Self: Any {
    ///     let frame = CGRect().with {
    ///       $0.origin.x = 10
    ///       $0.size.width = 100
    ///     }
    public func with(_ block: (inout Self) -> Void) -> Self {
        var copy = self
        block(&copy)
        return copy
    }
    
    ///     UserDefaults.standard.do {
    ///       $0.set("devxoul", forKey: "username")
    ///       $0.set("devxoul@gmail.com", forKey: "email")
    ///       $0.synchronize()
    ///     }
    public func `do`(_ make: (Self) -> Void) {
        make(self)
    }
}

extension NSObject: Configable{}
