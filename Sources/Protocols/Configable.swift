//
//  Configable.swift
//  Demo
//
//  Created by 123 on 2018/6/29.
//  Copyright © 2018年 郑桂杰. All rights reserved.
//

import Foundation

extension JJ where Original: AnyObject {
    @discardableResult
    public func config(_ block: (_ object: Original) -> Void) -> Original {
        block(original)
        return original
    }
}

