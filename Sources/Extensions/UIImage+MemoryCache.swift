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
    /// 根据缓存key获取图片
    /// - Parameter key: 图片缓存key
    /// - Returns: 图片
    func image<T>(for key: T) -> UIImage? where T: CustomStringConvertible {
        return cache.object(forKey: key.description as NSString)
    }
    
    /// 缓存图片
    /// - Parameters:
    ///   - image: 图片
    ///   - key: 图片缓存key
    func setImage<T>(_ image: UIImage, for key: T) where T: CustomStringConvertible {
        cache.setObject(image, forKey: key.description as NSString)
    }
}
