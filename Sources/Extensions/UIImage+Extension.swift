//
//  UIImage+Extension.swift
//  JJKit
//
//  Created by zgjff on 2022/9/30.
//

import UIKit

extension UIImage {
    /// 在size大小CGContext画布中，根据actions闭包来操作画布
    ///
    /// - Parameters:
    ///   - size: 图像画布大小
    ///   - actions: 操作画布---(CGContext)
    public convenience init?(size: CGSize, actions: @escaping (_ ctx: CGContext) -> ()) {
        var img: UIImage?
        let scale = UIScreen.main.scale
        if #available(iOS 10.0, *) {
            let f = UIGraphicsImageRendererFormat.default()
            f.scale = scale
            if #available(iOS 12.0, *) {
                f.preferredRange = .extended
            } else {
                f.prefersExtendedRange = true
            }
            let render = UIGraphicsImageRenderer(size: size, format: f)
            img = render.image(actions: { c in
                actions(c.cgContext)
            })
        } else {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            defer {
                UIGraphicsEndImageContext()
            }
            if let c = UIGraphicsGetCurrentContext() {
                actions(c)
            }
            img = UIGraphicsGetImageFromCurrentImageContext()
        }
        if let i = img, let cg = i.cgImage {
            self.init(cgImage: cg, scale: i.scale, orientation: i.imageOrientation)
        } else {
            return nil
        }
    }
    
    /// 颜色 -> 纯色图像
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 大小 默认 CGSize(width: 1, height: 1)
    ///   - cornerRadius: 图片圆角大小
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1), cornerRadius: CGFloat = 0) {
        let cacheInfo = UIImage.UIColorImageCache(color: color, size: size, cornerRadius: cornerRadius)
        let cacheImg = UIImage.MemoryCache.shared.image(for: cacheInfo)
        guard cacheImg == nil else {
            self.init(cgImage: cacheImg!.cgImage!, scale: cacheImg!.scale, orientation: cacheImg!.imageOrientation)
            return
        }
        let rect = CGRect(origin: .zero, size: size)
        let build: (CGContext) -> () = { context in
            context.setFillColor(color.cgColor)
            if cornerRadius > 0 {
                let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
                path.addClip()
                path.fill()
            } else {
                context.fill(rect)
            }
        }
        if let img = UIImage(size: size, actions: build), let cg = img.cgImage {
            UIImage.MemoryCache.shared.setImage(img, for: cacheInfo)
            self.init(cgImage: cg, scale: img.scale, orientation: img.imageOrientation)
        } else {
            return nil
        }
    }
    
    /// 线性颜色渐变图像
    ///
    /// - Parameters:
    ///   - linearColors: (颜色, 起始点)数组 注意：起始点范围(0~1.0)
    ///   - size: 大小
    ///   - start: 起始点(起点所在size中的x，y的百分比)
    ///   - end: 结束点(起点所在size中的x，y的百分比)
    public convenience init?(linearColors: (CGSize) -> ([(UIColor, CGFloat)]), size: CGSize, start: CGPoint = .zero, end: CGPoint = CGPoint(x: 1, y: 0)) {
        guard size != .zero else {
            return nil
        }
        let colors = linearColors(size)
        if colors.count == 1 {
            self.init(color: colors[0].0, size: size)
            return
        }
        guard !colors.isEmpty else {
            return nil
        }
        let build: (CGContext) -> () = { context in
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let initial: ([CGFloat], [CGFloat]) = ([], [])
            let (colorComponents, locations) = colors.map({ tupe -> ([CGFloat], CGFloat)? in
                guard let colorComponents = tupe.0.cgColor.components else {
                    return nil
                }
                return (colorComponents, tupe.1)
            }).reduce(initial, { (result, signle) -> ([CGFloat], [CGFloat]) in
                    var temp = result
                    if let signle = signle {
                        temp.0.append(contentsOf: signle.0)
                        temp.1.append(signle.1)
                    }
                    return temp
                })
            let s = CGPoint(x: size.width * start.x, y: size.height * start.y)
            let e = CGPoint(x: size.width * end.x, y: size.height * end.y)
            if let gradient = CGGradient(colorSpace: colorSpace, colorComponents: colorComponents, locations: locations, count: locations.count) {
                context.drawLinearGradient(gradient, start: s, end: e, options: .drawsAfterEndLocation)
            }
        }
        guard let img = UIImage(size: size, actions: build),
            let cg = img.cgImage else {
                return nil
        }
        self.init(cgImage: cg, scale: img.scale, orientation: img.imageOrientation)
    }
    
    /// 径向颜色渐变图像
    ///
    /// - Parameters:
    ///   - radialColors: (颜色, 起始点)数组 注意：起始点范围(0~1.0)
    ///   - size: 大小
    ///   - center: 中心点(中心点所在size中的x，y的百分比)--默认中心点CGPoint(x: 0.5, y: 0.5)
    ///   - radius: 径向渐变半径
    public convenience init?(radialColors: (CGSize) -> ([(UIColor, CGFloat)]), size: CGSize, center: CGPoint = CGPoint(x: 0.5, y: 0.5), radius: CGFloat) {
        guard size != .zero else {
            return nil
        }
        let colors = radialColors(size)
        guard !colors.isEmpty else {
            return nil
        }
        if colors.count == 1 {
            self.init(color: colors[0].0, size: size)
            return
        }
        let build: (CGContext) -> () = { context in
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let initial: ([CGFloat], [CGFloat]) = ([], [])
            let (colorComponents, locations) = colors.map({ tupe -> ([CGFloat], CGFloat)? in
                guard let colorComponents = tupe.0.cgColor.components else {
                    return nil
                }
                return (colorComponents, tupe.1)
            }).reduce(initial, { (result, signle) -> ([CGFloat], [CGFloat]) in
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
        }
        guard let img = UIImage(size: size, actions: build),
            let cg = img.cgImage else {
                return nil
        }
        self.init(cgImage: cg, scale: img.scale, orientation: img.imageOrientation)
    }
}

extension UIImage {
    struct UIColorImageCache: CustomStringConvertible {
        var description: String {
            let width = size.width
            let height = size.height
            return "UIImage.Color color:\(color) width:\(width) height:\(height) cornerRadius:\(cornerRadius)"
        }
        let color: UIColor
        let size: CGSize
        let cornerRadius: CGFloat
    }
}
