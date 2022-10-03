//
//  UIImage+MemoryCache.swift
//  JJKit
//
//  Created by zgjff on 2022/10/1.
//

import UIKit

extension UIImage {
    /// 图片内存缓存
    internal struct MemoryCache {
        static let shared = MemoryCache()
        private let cache: NSCache<NSString, UIImage>
        private init() {
            cache = NSCache()
        }
    }
}

extension UIImage.MemoryCache {
    func image<T>(for key: T) -> UIImage? where T: CustomStringConvertible {
        return cache.object(forKey: key.description as NSString)
    }
    func setImage<T>(_ image: UIImage, for key: T) where T: CustomStringConvertible {
        cache.setObject(image, forKey: key.description as NSString)
    }
}
