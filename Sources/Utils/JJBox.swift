//
//  JJBox.swift
//  JJKit
//
//  Created by 郑桂杰 on 2022/9/30.
//

import Foundation

public struct JJBox<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol JJCompatible {
    associatedtype BoxObject
    var jj: JJBox<BoxObject> { get }
}

extension JJCompatible {
    public var jj: JJBox<Self> {
        get {
            return JJBox(self)
        }
        set {}
    }
}
