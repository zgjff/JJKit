//
//  UIImage+Extension.swift
//  Demo
//
//  Created by 郑桂杰 on 2018/5/16.
//  Copyright © 2018年 郑桂杰. All rights reserved.
//

import UIKit

extension UIImage {
    static func colorImageWith(_ color: UIColor) -> UIImage? {
        let img = UIColorCache.shared.imageFor(color: color)
        guard img == nil else {
            return img
        }
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        var alphaChannel: CGFloat = 1.0
        let _ = color.getRed(nil, green: nil, blue: nil, alpha: &alphaChannel)
        let opaqueImage = (alphaChannel == 1.0)
        UIGraphicsBeginImageContextWithOptions(rect.size, opaqueImage, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        color.setFill()
        UIRectFill(rect)
        if  let cImg = UIGraphicsGetImageFromCurrentImageContext() {
            UIColorCache.shared.setImage(cImg, for: color)
            return cImg
        } else {
            return nil
        }
    }
}

private struct UIColorCache {
    static let shared = UIColorCache()
    private let cache: NSCache<UIColor, UIImage>
    private init() {
        cache = NSCache()
    }
    
    func imageFor(color: UIColor) -> UIImage? {
        return cache.object(forKey: color)
    }
    func setImage(_ image: UIImage, for color: UIColor) {
        cache.setObject(image, forKey: color)
    }
}
