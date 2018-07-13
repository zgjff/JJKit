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
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 大小
    /// - Returns: 纯色图像
    public static func fromColor(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        let colorSize = UIColorCache.ColorSize(color: color, size: size)
        let cacheImg = UIColorCache.shared.imageFor(colorSize: colorSize)
        guard cacheImg == nil else {
            return cacheImg
        }
        if let img = apply(size: size, modify: { context in
            color.set()
            context.fill(CGRect(origin: .zero, size: size))
        }) {
            UIColorCache.shared.setImage(img, for: colorSize)
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
    
    
    public func applyTintColor(_ tintColor: UIColor) -> UIImage? {
        let size = self.size
        return UIImage.apply(size: size, modify: { context in
            tintColor.setFill()
            UIRectFill(CGRect(origin: .zero, size: size))
            self.draw(in: CGRect(origin: .zero, size: size), blendMode: .destinationIn, alpha: 1.0)
        })
    }
    
    public func apply(radius: CGFloat, corners: UIRectCorner = .allCorners, border: CGFloat = 0, color: UIColor? = nil) -> UIImage? {
        return UIImage.apply(size: size, modify: { context in
            guard let cgImg = self.cgImage else { return }
            let rect = CGRect(origin: .zero, size: self.size)
            
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0, y: -rect.size.height)
            
            let minSize = min(self.size.width, self.size.height)

            if border < minSize / 2 {
                let path = UIBezierPath(roundedRect: rect.insetBy(dx: border, dy: border), byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: border))
                path.close()
                context.saveGState()
                path.addClip()
                context.draw(cgImg, in: rect)
                context.restoreGState()
            }
            
            if let borderColor = color, border > 0, border < minSize / 2 {
                let strokeInset = (floor(border * self.scale) + 0.5) / self.scale
                let strokeRect = rect.insetBy(dx: strokeInset, dy: strokeInset)
                let strokeRadius = radius > self.scale / 2 ? radius - self.scale / 2 : 0
                let path = UIBezierPath(roundedRect: strokeRect, byRoundingCorners: corners, cornerRadii: CGSize(width: strokeRadius, height: border))
                path.close()
                path.lineWidth = border
                path.lineJoinStyle = .miter
                borderColor.setStroke()
                path.stroke()
            }
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
    struct ColorSize: CustomStringConvertible {
        var description: String {
            let width = size.width
            let height = size.height
            return color.description + "\(width)" + "\(height)"
        }
        let color: UIColor
        let size: CGSize
        
        init(color: UIColor, size: CGSize) {
            self.color = color
            self.size = size
        }
    }
    
    static let shared = UIColorCache()
    private let cache: NSCache<NSString, UIImage>
    private init() {
        cache = NSCache()
    }
    
    func imageFor(colorSize: ColorSize) -> UIImage? {
        return cache.object(forKey: colorSize.description as NSString)
    }
    func setImage(_ image: UIImage, for colorSize: ColorSize) {
        cache.setObject(image, forKey: colorSize.description as NSString)
    }
}
