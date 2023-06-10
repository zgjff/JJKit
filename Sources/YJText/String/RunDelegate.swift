//
//  RunDelegate.swift
//  JJKit
//
//  Created by zgjff on 2023/4/15.
//

import UIKit
import CoreText

extension YJText {
    internal struct RunDelegate {
        let ascent: CGFloat
        let descent: CGFloat
        let width: CGFloat
    }
}

extension YJText.RunDelegate {
    internal var ctRunDelegate: CTRunDelegate {
        get {
            let extentBuffer = UnsafeMutablePointer<YJText.RunDelegate>.allocate(capacity: 1)
            extentBuffer.initialize(to: YJText.RunDelegate(ascent: ascent, descent: descent, width: width))
            var callback = CTRunDelegateCallbacks(
                version: kCTRunDelegateCurrentVersion) { _ in
                    
                } getAscent: { p in
                    p.assumingMemoryBound(to: YJText.RunDelegate.self).pointee.ascent
                } getDescent: { p in
                    p.assumingMemoryBound(to: YJText.RunDelegate.self).pointee.descent
                } getWidth: { p in
                    p.assumingMemoryBound(to: YJText.RunDelegate.self).pointee.width
                }
            return CTRunDelegateCreate(&callback, extentBuffer)!
        }
    }
}

extension YJText.RunDelegate: Codable {
    private enum RunDelegateCodingKey: String, CodingKey {
        case ascent, descent, width
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: RunDelegateCodingKey.self)
        ascent = try c.decode(CGFloat.self, forKey: .ascent)
        descent = try c.decode(CGFloat.self, forKey: .descent)
        width = try c.decode(CGFloat.self, forKey: .width)
    }
    
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: RunDelegateCodingKey.self)
        try c.encode(ascent, forKey: .ascent)
        try c.encode(descent, forKey: .descent)
        try c.encode(width, forKey: .width)
    }
}
