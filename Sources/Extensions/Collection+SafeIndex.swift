//
//  Collection+SafeIndex.swift
//  JJKit
//
//  Created by 郑桂杰 on 2022/9/30.
//

import Foundation

extension Collection {
    subscript(safeIndex index: Index) -> Element? {
        guard startIndex <= index && index < endIndex else {
            return nil
        }
        return self[index]
    }
}
