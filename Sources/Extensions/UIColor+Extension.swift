//
//  UIColor+Extension.swift
//  JJKit
//
//  Created by 郑桂杰 on 2022/9/30.
//

import UIKit

extension UIColor {
    /// 通过色值hex值生成颜色
    /// - Parameter hexString: 色值hex值
    public convenience init?(hexString: String) {
        if hexString.count < 3 {
            return nil
        }
        var hex = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if hex.hasPrefix("#") {
            let h = hex.suffix(from: String.Index(utf16Offset: 1, in: hex))
            hex = String(h)
        } else if hex.hasPrefix("0X") {
            let h = hex.suffix(from: String.Index(utf16Offset: 2, in: hex))
            hex = String(h)
        }
        guard let c = Int(hex, radix: 16) else { return nil }
        switch hex.count {
        case 3: //RGB
            let r = (c >> 8 & 0xf) | (c >> 4 & 0x0f0)
            let g = (c >> 4 & 0xf) | (c & 0xf0)
            let b = ((c & 0xf) << 4) | (c & 0xf)
            self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
        case 4: //ARGB
            let r = c >> 16 & 0xff
            let g = c >> 8 & 0xff
            let b = c & 0xff
            let a = c >> 24 & 0xff
            self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 100.0)
        case 6: //RRGGBB
            let r = c >> 16 & 0xff
            let g = c >> 8 & 0xff
            let b = c & 0xff
            self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
        case 8: //RRGGBBAA
            let r = c >> 24 & 0xff
            let g = c >> 16 & 0xff
            let b = c >> 8 & 0xff
            let a = c & 0xff
            self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 100.0)
        default:
            return nil
        }
    }
    
    /// 随机颜色
    public static func jRandom() -> UIColor {
        return UIColor(hue: CGFloat(arc4random() % 256) / 256.0, saturation: CGFloat(arc4random() % 128) / 256.0 + 0.5, brightness: CGFloat(arc4random() % 128) / 256.0 + 0.5, alpha: 1)
    }
}

extension UIColor: JJCompatible {}

public extension JJBox where Base: UIColor {
    /// 混合第二种颜色生成新的颜色
    /// - Parameters:
    ///   - color: 第二种颜色
    ///   - ratio: 第二种颜色占比
    /// - Returns: 新的颜色
    func mix(secondColor color: UIColor, secondColorRatio ratio: Float) -> UIColor {
        let rio = CGFloat(ratio > 1 ? 1 : (ratio < 0) ? 0 : ratio)
        
        var fr: CGFloat = 0
        var fg: CGFloat = 0
        var fb: CGFloat = 0
        var fa: CGFloat = 0
        
        var sr: CGFloat = 0
        var sg: CGFloat = 0
        var sb: CGFloat = 0
        var sa: CGFloat = 0
        
        guard base.getRed(&fr, green: &fg, blue: &fb, alpha: &fa),
              color.getRed(&sr, green: &sg, blue: &sb, alpha: &sa) else {
            return color
        }
        let r = fr * (1 - rio) + sr * rio
        let g = fg * (1 - rio) + sg * rio
        let b = fb * (1 - rio) + sb * rio
        let a = fa * (1 - rio) + sa * rio
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}
