//
//  String+NSRange.swift
//  JJKit
//
//  Created by zgjff on 2023/8/9.
//

import Foundation

extension JJBox where Base == String {
    /// 从给定的Swift String Index Range获取对应的NSRange
    /// - Parameter range: Swift String Index Range
    /// - Returns: NSRange
    public func nsRange(from range: Range<String.Index>) -> NSRange {
        if range.isEmpty {
            return NSRange(location: 0, length: 0)
        }
        guard let from = range.lowerBound.samePosition(in: base.utf16),
              let to = range.upperBound.samePosition(in: base.utf16) else {
                  return NSRange(location: 0, length: 0)
              }
        return NSRange(location: base.utf16.distance(from: base.utf16.startIndex, to: from),length: base.utf16.distance(from: from, to: to))
    }
}
