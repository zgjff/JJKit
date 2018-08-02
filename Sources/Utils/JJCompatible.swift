//
//  JJCompatible.swift
//  Demo
//
//  Created by 123 on 2018/6/29.
//  Copyright © 2018年 郑桂杰. All rights reserved.
//

import Foundation

public protocol JJCompatible {
    associatedtype CompatibleObject
    var jj: CompatibleObject { get }
}

extension JJCompatible {
    public var jj: JJ<Self> {
        return JJ(self)
    }
}

final public class JJ<Original>: NSObject {
    let original: Original
    init(_ original: Original) {
        self.original = original
    }
}
