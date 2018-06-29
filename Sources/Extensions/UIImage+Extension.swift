//
//  UIImage+Extension.swift
//  Demo
//
//  Created by 郑桂杰 on 2018/5/16.
//  Copyright © 2018年 郑桂杰. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 颜色 -> 纯色图像
    ///
    /// - Parameter color: 颜色
    /// - Returns: 纯色图像
     public static func fromColor(_ color: UIColor) -> UIImage? {
        let cacheImg = UIColorCache.shared.imageFor(color: color)
        guard cacheImg == nil else {
            return cacheImg
        }
        let size = CGSize(width: 1, height: 1)
        if let img = apply(size: size, modify: { context in
            color.set()
            context.fill(CGRect(origin: .zero, size: size))
        }) {
            UIColorCache.shared.setImage(img, for: color)
            return img
        } else {
            return nil
        }
    }
    
    /// 线性颜色渐变图像
    ///
    /// - Parameter colors: (颜色, 起始点)变参 注意：起始点范围(0~1.0)
    /// - Returns: 渐变图像
    public static func fromLinearColors(_ colors: (color: UIColor, location: CGFloat)..., size: CGSize, start: CGPoint = .zero, end: CGPoint) -> UIImage? {
        return apply(size: size) { context in
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            
            let initial: ([CGFloat], [CGFloat]) = ([], [])
            let (colorComponents, locations) = colors.map({ tupe -> ([CGFloat], CGFloat)? in
                guard let colorComponents = tupe.color.cgColor.components else {
                    return nil
                }
                
                let location = tupe.location
                
                return (colorComponents, location)
            })
                .reduce(initial, { (result, signle) -> ([CGFloat], [CGFloat]) in
                    var temp = result
                    if let signle = signle {
                        temp.0.append(contentsOf: signle.0)
                        temp.1.append(signle.1)
                    }
                    return temp
                })
            
            if let gradient = CGGradient(colorSpace: colorSpace, colorComponents: colorComponents, locations: locations, count: locations.count) {
                context.drawLinearGradient(gradient, start: start, end: end, options: .drawsAfterEndLocation)
            }
        }
    }
    
    /// 径向颜色渐变图像
    ///
    /// - Parameters:
    ///   - colors: (颜色, 起始点)变参 注意：起始点范围(0~1.0)
    ///   - size: 画布大小
    ///   - center: 径向渐变中心点(0~1.0)
    ///   - radius: 径向渐变半径
    /// - Returns: 渐变图像
    public static func fromRadialColors(_ colors: (color: UIColor, location: CGFloat)..., size: CGSize, center: CGPoint, radius: CGFloat) -> UIImage? {
        return apply(size: size, modify: { context in
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            
            let initial: ([CGFloat], [CGFloat]) = ([], [])
            let (colorComponents, locations) = colors.map({ tupe -> ([CGFloat], CGFloat)? in
                guard let colorComponents = tupe.color.cgColor.components else {
                    return nil
                }
                
                let location = tupe.location
                
                return (colorComponents, location)
            })
                .reduce(initial, { (result, signle) -> ([CGFloat], [CGFloat]) in
                    var temp = result
                    if let signle = signle {
                        temp.0.append(contentsOf: signle.0)
                        temp.1.append(signle.1)
                    }
                    return temp
                })
            let aCenter = CGPoint(x: center.x * size.width, y: center.y * size.height)
            if let gradient = CGGradient(colorSpace: colorSpace, colorComponents: colorComponents, locations: locations, count: locations.count) {
                context.drawRadialGradient(gradient, startCenter: aCenter, startRadius: 0, endCenter: aCenter, endRadius: radius, options: .drawsAfterEndLocation)
            }
        })
    }
    /// view -> UIImage
    ///
    /// - Parameter view: 需要截图的view
    /// - Returns: view的截图
    public static func fromView(_ view: UIView) -> UIImage? {
        let size = view.bounds.size
        return apply(size: size, modify: { context in
            view.layer.render(in: context)
        })
    }
}

private extension UIImage {
    /// 在size大小CGContext画布中，根据modiy闭包来操作画布，并返回图像
    ///
    /// - Parameters:
    ///   - size: 画布的大小
    ///   - modify: block(CGContext)
    /// - Returns: 图像
    static func apply(size: CGSize, modify: @escaping (CGContext) -> ()) -> UIImage? {
        if #available(iOS 10.0, *) {
            let render = UIGraphicsImageRenderer(size: size)
            return render.image(actions: { context in
                context.cgContext.saveGState()
                modify(context.cgContext)
                context.cgContext.restoreGState()
            })
        } else {
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            defer {
                UIGraphicsEndImageContext()
            }
            if let context = UIGraphicsGetCurrentContext() {
                context.saveGState()
                modify(context)
                context.restoreGState()
            }
            return UIGraphicsGetImageFromCurrentImageContext()
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
