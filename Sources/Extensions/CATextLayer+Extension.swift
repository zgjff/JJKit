//
//  CATextLayer+Extension.swift
//  Demo
//
//  Created by 123 on 2018/10/8.
//  Copyright © 2018 郑桂杰. All rights reserved.
//

import UIKit

extension JJ where Original: CATextLayer {
    public var font: UIFont? {
        get {
            // 暂时不知道如何转换
            return nil
        }
        set {
            guard let font = newValue else { return }
            let f = CGFont(font.fontName as CFString)
            original.font = f
            original.fontSize = font.pointSize
        }
    }
    public var textColor: UIColor? {
        get {
            if let c = original.foregroundColor {
                return UIColor(cgColor: c)
            } else {
                return nil
            }
        }
        set {
            original.foregroundColor = newValue?.cgColor
        }
    }
}
