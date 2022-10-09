//
//  UIImage+Shape.swift
//  JJKit
//
//  Created by zgjff on 2022/9/30.
//

import UIKit

extension UIImage {
    /// 绘制特定形状的图片
    /// - Parameters:
    ///   - shape: 要绘制的形状
    ///   - size: 大小
    ///   - tintColor: 颜色
    /// - Returns: 绘制之后的图片
    public static func shape(_ shape: UIImage.Shape, size: CGFloat, tintColor: UIColor = .white) -> UIImage? {
        let shapeInfo = UIImage.Shape.CacheInfo(key: shape.cacheKey, size: size, tintColor: tintColor)
        if let cacheImg = UIImage.MemoryCache.shared.image(for: shapeInfo) {
            return cacheImg
        }
        let img = UIImage(size: CGSize(width: size, height: size)) { ctx in
            shape.draw(ctx: ctx, size: size, tintColor: tintColor)
        }
        if let img {
            UIImage.MemoryCache.shared.setImage(img, for: shapeInfo)
            return img
        }
        return nil
    }
}

extension UIImage {
    /// 纯线条形状
    public typealias LineShape = (_ lineWidth: CGFloat) -> UIImage.Shape
    /// 特定颜色的线条形状
    public typealias LineWithColorShape = (_ lineWidth: CGFloat, _ lineColor: UIColor) -> UIImage.Shape
    /// 特定方向的形状
    public typealias ArrowShape = (_ direction: Shape.ArrowDriection, _ lineWidth: CGFloat) -> UIImage.Shape
    /// 特定方向颜色的线条形状
    public typealias ArrowWithColorShape = (_ direction: Shape.ArrowDriection, _ lineWidth: CGFloat, _ lineColor: UIColor) -> UIImage.Shape
    
    /// 要绘制的图片形状
    public struct Shape {
        /// 具体绘制图片的方式
        public let actions: ((_ ctx: CGContext, _ size: CGFloat, _ tintColor: UIColor) -> Void)
        fileprivate let cacheKey: String
        public init(cacheKey: String, actions: @escaping (_ ctx: CGContext, _ size: CGFloat, _ tintColor: UIColor) -> Void) {
            self.cacheKey = cacheKey
            self.actions = actions
        }
        
        fileprivate func draw(ctx: CGContext, size: CGFloat, tintColor: UIColor) {
            actions(ctx, size, tintColor)
        }
        
        /// 箭头方向
        public enum ArrowDriection: String {
            case left, right, up, down
        }
    }
}

extension UIImage.Shape {
    /// 绘制固定宽度的空心圆
    public static var circle: UIImage.LineShape = { lw in
        return UIImage.Shape(cacheKey: "UIImage.Shape.circle: lineWidth=\(lw)") { (ctx, size, tintColor) in
            ctx.setStrokeColor(tintColor.cgColor)
            UIImage.Shapes.circle(UIBezierPath(arcCenter: CGPoint(x: size * 0.5, y: size * 0.5), radius: (size - lw) * 0.5, startAngle: 0, endAngle: .pi * 2, clockwise: true))(.stroke(lineWidth: lw))
        }
    }

    /// 绘制实心圆
    public static var circleFill = UIImage.Shape(cacheKey: "UIImage.Shape.circleFill") { (ctx, size, tintColor) in
        ctx.setFillColor(tintColor.cgColor)
        UIImage.Shapes.circle(UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size, height: size), cornerRadius: size * 0.5))(.fill)
    }
    
    /// 绘制+号
    public static var plus: UIImage.LineShape = { lw in
        return UIImage.Shape(cacheKey: "UIImage.Shape.plus: lineWidth=\(lw)") { (ctx, size, tintColor) in
            ctx.setStrokeColor(tintColor.cgColor)
            UIImage.Shapes.plus(UIBezierPath())(CGRect(x: lw, y: lw, width: size - lw * 2, height: size - lw * 2))(lw)
        }
    }
    
    /// 空心+号    lineWidth:线条宽
    public static var plusCircle: UIImage.LineShape = { lw in
        return UIImage.Shape(cacheKey: "UIImage.Shape.plusCircle: lineWidth=\(lw)") { (ctx, size, tintColor) in
            ctx.setStrokeColor(tintColor.cgColor)
            let path = UIBezierPath(arcCenter: CGPoint(x: size * 0.5, y: size * 0.5), radius: (size - lw) * 0.5, startAngle: 0, endAngle: .pi * 2, clockwise: true)
            UIImage.Shapes.plus(path)(CGRect(x: size * 0.28, y: size * 0.28, width: size * 0.44, height: size * 0.44))(lw)
        }
    }
    
    /// 实心+  lineWidth:线条宽  lineColor:线条颜色
    public static var plusCircleFill: UIImage.LineWithColorShape = { lw, lc in
        return UIImage.Shape(cacheKey: "UIImage.Shape.plusCircleFill: lineWidth=\(lw) lineColor:=\(lc)") { (ctx, size, tintColor) in
            ctx.setFillColor(tintColor.cgColor)
            UIImage.Shapes.circle(UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size, height: size), cornerRadius: size * 0.5))(.fill)
            ctx.setStrokeColor(lc.cgColor)
            UIImage.Shapes.plus(UIBezierPath())(CGRect(x: size * 0.28, y: size * 0.28, width: size * 0.44, height: size * 0.44))(lw)
        }
    }
    
    /// -号    lineWidth:线条宽
    public static var minus: UIImage.LineShape = { lw in
        return UIImage.Shape(cacheKey: "UIImage.Shape.minus: lineWidth=\(lw)") { (ctx, size, tintColor) in
            ctx.setStrokeColor(tintColor.cgColor)
            UIImage.Shapes.line(UIBezierPath())(CGRect(x: lw, y: 0, width: size - lw * 2, height: size))(lw)
        }
    }
    
    /// 空心-号    lineWidth:线条宽
    public static var minusCircle: UIImage.LineShape = { lw in
        return UIImage.Shape(cacheKey: "UIImage.Shape.minusCircle: lineWidth=\(lw)") { (ctx, size, tintColor) in
            ctx.setStrokeColor(tintColor.cgColor)
            let path = UIBezierPath(arcCenter: CGPoint(x: size * 0.5, y: size * 0.5), radius: (size - lw) * 0.5, startAngle: 0, endAngle: .pi * 2, clockwise: true)
            UIImage.Shapes.circle(path)(.stroke(lineWidth: lw))
            UIImage.Shapes.line(path)(CGRect(x: size * 0.28, y: 0, width: size * 0.44, height: size))(lw)
        }
    }
    
    /// 实心-  lineWidth:线条宽  lineColor:线条颜色
    public static var minusCircleFill: UIImage.LineWithColorShape = { lw, lc in
        return UIImage.Shape(cacheKey: "UIImage.Shape.minusCircleFill: lineWidth=\(lw) lineColor:=\(lc)") { (ctx, size, tintColor) in
            ctx.setFillColor(tintColor.cgColor)
            UIImage.Shapes.circle(UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size, height: size), cornerRadius: size * 0.5))(.fill)
            ctx.setStrokeColor(lc.cgColor)
            UIImage.Shapes.line(UIBezierPath())(CGRect(x: size * 0.28, y: size * 0.28, width: size * 0.44, height: size * 0.44))(lw)
        }
    }
    
    /// x号    lineWidth:线条宽
    public static var multiply: UIImage.LineShape = { lw in
        return UIImage.Shape(cacheKey: "UIImage.Shape.multiply: lineWidth=\(lw)") { (ctx, size, tintColor) in
            ctx.setStrokeColor(tintColor.cgColor)
            UIImage.Shapes.multiply(UIBezierPath())(CGRect(x: lw, y: lw, width: size - lw * 2, height: size - lw * 2))(lw)
        }
    }
    
    /// 空心x号    lineWidth:线条宽
    public static var multiplyCircle: UIImage.LineShape = { lw in
        return UIImage.Shape(cacheKey: "UIImage.Shape.multiplyCircle: lineWidth=\(lw)") { (ctx, size, tintColor) in
            ctx.setStrokeColor(tintColor.cgColor)
            let path = UIBezierPath(arcCenter: CGPoint(x: size * 0.5, y: size * 0.5), radius: (size - lw) * 0.5, startAngle: 0, endAngle: .pi * 2, clockwise: true)
            UIImage.Shapes.circle(path)(.stroke(lineWidth: lw))
            let ang45: CGFloat = cos(.pi * 0.25)
            UIImage.Shapes.multiply(path)(CGRect(x: size * (0.5 - ang45 * 0.25), y: size * (0.5 - ang45 * 0.25), width: size * 0.5 * ang45, height: size * 0.5 * ang45))(lw)
        }
    }
    
    /// 实心x  lineWidth:线条宽  lineColor:线条颜色
    public static var multiplyCircleFill: UIImage.LineWithColorShape = { lw, lc in
        return UIImage.Shape(cacheKey: "UIImage.Shape.multiplyCircleFill: lineWidth=\(lw) lineColor=\(lc)") { (ctx, size, tintColor) in
            ctx.setFillColor(tintColor.cgColor)
            UIImage.Shapes.circle(UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size, height: size), cornerRadius: size * 0.5))(.fill)
            ctx.setStrokeColor(lc.cgColor)
            let ang45: CGFloat = cos(.pi * 0.25)
            UIImage.Shapes.multiply(UIBezierPath())(CGRect(x: size * (0.5 - ang45 * 0.25), y: size * (0.5 - ang45 * 0.25), width: size * 0.5 * ang45, height: size * 0.5 * ang45))(lw)
        }
    }
    
    /// =号    lineWidth:线条宽
    public static var equal: UIImage.LineShape = { lw in
        return UIImage.Shape(cacheKey: "UIImage.Shape.equal: lineWidth=\(lw)") { (ctx, size, tintColor) in
            ctx.setStrokeColor(tintColor.cgColor)
            let path = UIBezierPath()
            let space: CGFloat = 6
            let h = space + lw
            UIImage.Shapes.line(path)(CGRect(x: lw, y: size * 0.5 - h, width: size - lw * 2, height: h))(lw)
            UIImage.Shapes.line(path)(CGRect(x: lw, y: size * 0.5, width: size - lw * 2, height: h))(lw)
        }
    }
    
    /// 空心=   lineWidth:线条宽
    public static var equalCircle: UIImage.LineShape = { lw in
        return UIImage.Shape(cacheKey: "UIImage.Shape.equalCircle: lineWidth=\(lw)") { (ctx, size, tintColor) in
            ctx.setStrokeColor(tintColor.cgColor)
            let path = UIBezierPath(arcCenter: CGPoint(x: size * 0.5, y: size * 0.5), radius: (size - lw) * 0.5, startAngle: 0, endAngle: .pi * 2, clockwise: true)
            UIImage.Shapes.circle(path)(.stroke(lineWidth: lw))
            let space: CGFloat = 6
            let h = space + lw
            UIImage.Shapes.line(path)(CGRect(x: size * 0.28, y: size * 0.5 - h, width: size * 0.44, height: h))(lw)
            UIImage.Shapes.line(path)(CGRect(x: size * 0.28, y: size * 0.5, width: size * 0.44, height: h))(lw)
        }
    }
    
    /// 实心=  lineWidth:线条宽  lineColor:线条颜色
    public static var equalCircleFill: UIImage.LineWithColorShape = { lw, lc in
        return UIImage.Shape(cacheKey: "UIImage.Shape.equalCircleFill: lineWidth=\(lw) lineColor=\(lc)") { (ctx, size, tintColor) in
            ctx.setFillColor(tintColor.cgColor)
            UIImage.Shapes.circle(UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size, height: size), cornerRadius: size * 0.5))(.fill)
            let space: CGFloat = 6
            let h = space + lw
            ctx.setStrokeColor(lc.cgColor)
            let path = UIBezierPath()
            UIImage.Shapes.line(path)(CGRect(x: size * 0.28, y: size * 0.5 - h, width: size * 0.44, height: h))(lw)
            UIImage.Shapes.line(path)(CGRect(x: size * 0.28, y: size * 0.5, width: size * 0.44, height: h))(lw)
        }
    }
    
    /// >  direction: 方向 lineWidth:线条宽
    public static var chevron: UIImage.ArrowShape = { direction, lw in
        return UIImage.Shape(cacheKey: "UIImage.Shape.chevron.\(direction.rawValue): lineWidth=\(lw)") { (ctx, size, tintColor) in
            ctx.setStrokeColor(tintColor.cgColor)
            let rect: CGRect
            switch direction {
            case .left, .right:
                rect = CGRect(x: size * 0.75 - 0.5 * (size - lw), y: lw * 0.5, width: 0.5 * (size - lw), height: size - lw)
            case .up, .down:
                rect = CGRect(x: lw * 0.5, y: size * 0.75 - 0.5 * (size - lw), width: size - lw, height: 0.5 * (size - lw))
            }
            UIImage.Shapes.chevron(direction, UIBezierPath())(rect)(lw)
        }
    }
    
    /// 空心 >  direction: 方向 lineWidth:线条宽
    public static var chevronCircle: UIImage.ArrowShape = { direction, lw in
        return UIImage.Shape(cacheKey: "UIImage.Shape.chevronCircle.\(direction.rawValue)Circle: lineWidth=\(lw)") { (ctx, size, tintColor) in
            ctx.setStrokeColor(tintColor.cgColor)
            let path = UIBezierPath(arcCenter: CGPoint(x: size * 0.5, y: size * 0.5), radius: (size - lw) * 0.5, startAngle: 0, endAngle: .pi * 2, clockwise: true)
            UIImage.Shapes.circle(path)(.stroke(lineWidth: lw))
            let rect: CGRect
            switch direction {
            case .left:
                rect = CGRect(x: (size - lw) * (0.5 - 0.11), y: size * 0.28 + 0.22 * lw, width: (size - lw) * 0.22, height: (size - lw) * 0.44)
            case .right:
                rect = CGRect(x: (size + lw) * (0.5 - 0.11), y: size * 0.28 + 0.22 * lw, width: (size - lw) * 0.22, height: (size - lw) * 0.44)
            case .up:
                rect = CGRect(x: size * 0.28 + 0.22 * lw, y: (size - lw) * (0.5 - 0.11), width: (size - lw) * 0.44, height: (size - lw) * 0.22)
            case .down:
                rect = CGRect(x: size * 0.28 + 0.22 * lw, y: (size + lw) * (0.5 - 0.11), width: (size - lw) * 0.44, height: (size - lw) * 0.22)
            }
            UIImage.Shapes.chevron(direction, UIBezierPath())(rect)(lw)
        }
    }
    
    /// 实心 >  direction: 方向 lineWidth:线条宽  lineColor:线条颜色
    public static var chevronCircleFill: UIImage.ArrowWithColorShape = { direction, lw, lc in
        return UIImage.Shape(cacheKey: "UIImage.Shape.chevronCircleFill.\(direction.rawValue)Fill: lineWidth=\(lw) lineColor=\(lc)") { (ctx, size, tintColor) in
            ctx.setFillColor(tintColor.cgColor)
            UIImage.Shapes.circle(UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size, height: size), cornerRadius: size * 0.5))(.fill)
            ctx.setStrokeColor(lc.cgColor)
            let rect: CGRect
            switch direction {
            case .left:
                rect = CGRect(x: (size - lw) * (0.5 - 0.11), y: size * 0.28 + 0.22 * lw, width: (size - lw) * 0.22, height: (size - lw) * 0.44)
            case .right:
                rect = CGRect(x: (size + lw) * (0.5 - 0.11), y: size * 0.28 + 0.22 * lw, width: (size - lw) * 0.22, height: (size - lw) * 0.44)
            case .up:
                rect = CGRect(x: size * 0.28 + 0.22 * lw, y: (size - lw) * (0.5 - 0.11), width: (size - lw) * 0.44, height: (size - lw) * 0.22)
            case .down:
                rect = CGRect(x: size * 0.28 + 0.22 * lw, y: (size + lw) * (0.5 - 0.11), width: (size - lw) * 0.44, height: (size - lw) * 0.22)
            }
            UIImage.Shapes.chevron(direction, UIBezierPath())(rect)(lw)
        }
    }
    
    /// -->  direction: 方向 lineWidth:线条宽
    public static var arrow: UIImage.ArrowShape = { direction, lw in
        return UIImage.Shape(cacheKey: "UIImage.Shape.arrow.\(direction.rawValue): lineWidth=\(lw)") { (ctx, size, tintColor) in
            ctx.setStrokeColor(tintColor.cgColor)
            let path = UIBezierPath()
            let rect: CGRect
            switch direction {
            case .left:
                UIImage.Shapes.line(path)(CGRect(x: size * 0.1, y: 0, width: size * 0.8, height: size))(lw)
                rect = CGRect(x: size * 0.1, y: size * 0.07, width: size * 0.36, height: size * 0.86)
            case .right:
                UIImage.Shapes.line(path)(CGRect(x: size * 0.1, y: 0, width: size * 0.8, height: size))(lw)
                rect = CGRect(x: size * 0.54, y: size * 0.07, width: size * 0.36, height: size * 0.86)
            case .up:
                UIImage.Shapes.verticalLine(path)(CGRect(x: 0, y: size * 0.1, width: size, height: size * 0.8))(lw)
                rect = CGRect(x: size * 0.07, y: size * 0.1, width: size * 0.86, height: size * 0.36)
            case .down:
                UIImage.Shapes.verticalLine(path)(CGRect(x: 0, y: size * 0.1, width: size, height: size * 0.8))(lw)
                rect = CGRect(x: size * 0.07, y: size * 0.54, width: size * 0.86, height: size * 0.36)
            }
            UIImage.Shapes.chevron(direction, path)(rect)(lw)
        }
    }
    
    /// 空心 -->  direction: 方向 lineWidth:线条宽
    public static var arrowCircle: UIImage.ArrowShape = { direction, lw in
        return UIImage.Shape(cacheKey: "UIImage.Shape.arrowCircle.\(direction.rawValue)Circle: lineWidth=\(lw)") { (ctx, size, tintColor) in
            ctx.setStrokeColor(tintColor.cgColor)
            let path = UIBezierPath(arcCenter: CGPoint(x: size * 0.5, y: size * 0.5), radius: (size - lw) * 0.5, startAngle: 0, endAngle: .pi * 2, clockwise: true)
            UIImage.Shapes.circle(path)(.stroke(lineWidth: lw))
            let rect: CGRect
            switch direction {
            case .left:
                UIImage.Shapes.line(path)(CGRect(x: size * (1 - 0.44 * 0.86) * 0.5, y: 0, width: size * 0.44 * 0.86, height: size))(lw)
                rect = CGRect(x: size * 0.28, y: size * 0.32, width: size * 0.21, height: size * 0.36)
            case .right:
                UIImage.Shapes.line(path)(CGRect(x: size * (1 - 0.44 * 0.86) * 0.5, y: 0, width: size * 0.44 * 0.86, height: size))(lw)
                rect = CGRect(x: size * 0.51, y: size * 0.32, width: size * 0.21, height: size * 0.36)
            case .up:
                UIImage.Shapes.verticalLine(path)(CGRect(x: 0, y: size * (1 - 0.44 * 0.86) * 0.5, width: size, height: size * 0.44 * 0.86))(lw)
                rect = CGRect(x: size * 0.32, y: size * (1 - 0.44 * 0.86) * 0.5, width: size * 0.36, height: size * 0.21)
            case .down:
                UIImage.Shapes.verticalLine(path)(CGRect(x: 0, y: size * (1 - 0.44 * 0.86) * 0.5, width: size, height: size * 0.44 * 0.86))(lw)
                rect = CGRect(x: size * 0.32, y: size * 0.51, width: size * 0.36, height: size * 0.21)
            }
            UIImage.Shapes.chevron(direction, path)(rect)(lw)
        }
    }
    
    /// 实心 -->  direction: 方向 lineWidth:线条宽  lineColor:线条颜色
    public static var arrowCircleFill: UIImage.ArrowWithColorShape = { direction, lw, lc in
        return UIImage.Shape(cacheKey: "UIImage.Shape.arrowCircleFill.\(direction.rawValue)Fill: lineWidth=\(lw) lineColor=\(lc)") { (ctx, size, tintColor) in
            ctx.setFillColor(tintColor.cgColor)
            UIImage.Shapes.circle(UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size, height: size), cornerRadius: size * 0.5))(.fill)
            ctx.setStrokeColor(lc.cgColor)
            let path = UIBezierPath()
            let rect: CGRect
            switch direction {
            case .left:
                UIImage.Shapes.line(path)(CGRect(x: size * (1 - 0.44 * 0.86) * 0.5, y: 0, width: size * 0.44 * 0.86, height: size))(lw)
                rect = CGRect(x: size * 0.28, y: size * 0.32, width: size * 0.21, height: size * 0.36)
            case .right:
                UIImage.Shapes.line(path)(CGRect(x: size * (1 - 0.44 * 0.86) * 0.5, y: 0, width: size * 0.44 * 0.86, height: size))(lw)
                rect = CGRect(x: size * 0.51, y: size * 0.32, width: size * 0.21, height: size * 0.36)
            case .up:
                UIImage.Shapes.verticalLine(path)(CGRect(x: 0, y: size * (1 - 0.44 * 0.86) * 0.5, width: size, height: size * 0.44 * 0.86))(lw)
                rect = CGRect(x: size * 0.32, y: size * (1 - 0.44 * 0.86) * 0.5, width: size * 0.36, height: size * 0.21)
            case .down:
                UIImage.Shapes.verticalLine(path)(CGRect(x: 0, y: size * (1 - 0.44 * 0.86) * 0.5, width: size, height: size * 0.44 * 0.86))(lw)
                rect = CGRect(x: size * 0.32, y: size * 0.51, width: size * 0.36, height: size * 0.21)
            }
            UIImage.Shapes.chevron(direction, path)(rect)(lw)
        }
    }
}

extension UIImage {
    fileprivate struct Shapes {
        enum CircleStyle {
            case fill
            case stroke(lineWidth: CGFloat)
        }
        
        /// 圆圈
        static var circle: (UIBezierPath) -> (CircleStyle) -> Void = { path in
            return { style in
                switch style {
                case .fill:
                    path.fill()
                case .stroke(lineWidth: let lw):
                    path.lineWidth = lw
                    path.stroke()
                }
            }
        }
        
        /// +
        static var plus: (UIBezierPath) -> (CGRect) -> (CGFloat) -> Void = { path in
            path.lineCapStyle = .round
            return { rect in
                path.move(to: CGPoint(x: rect.minX, y: rect.midY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
                path.move(to: CGPoint(x: rect.midX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
                return { lineWidth in
                    path.lineWidth = lineWidth
                    path.stroke()
                }
            }
        }
        
        /// -
        static var line: (UIBezierPath) -> (CGRect) -> (CGFloat) -> Void = { path in
            path.lineCapStyle = .round
            return { rect in
                path.move(to: CGPoint(x: rect.minX, y: rect.midY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
                return { lineWidth in
                    path.lineWidth = lineWidth
                    path.stroke()
                }
            }
        }
        
        /// |
        static var verticalLine: (UIBezierPath) -> (CGRect) -> (CGFloat) -> Void = { path in
            path.lineCapStyle = .round
            return { rect in
                path.move(to: CGPoint(x: rect.midX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
                return { lineWidth in
                    path.lineWidth = lineWidth
                    path.stroke()
                }
            }
        }
        
        /// x
        static var multiply: (UIBezierPath) -> (CGRect) -> (CGFloat) -> Void = { path in
            path.lineCapStyle = .round
            return { rect in
                path.move(to: CGPoint(x: rect.minX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
                return { lineWidth in
                    path.lineWidth = lineWidth
                    path.stroke()
                }
            }
        }
        
        /// <
        static var chevron: (UIImage.Shape.ArrowDriection, UIBezierPath) -> (CGRect) -> (CGFloat) -> Void = { direction, path in
            path.lineCapStyle = .round
            path.lineJoinStyle = .round
            return { rect in
                switch direction {
                case .left:
                    path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
                    path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
                    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                case .right:
                    path.move(to: CGPoint(x: rect.minX, y: rect.minY))
                    path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
                    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
                case .up:
                    path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
                    path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
                    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
                case .down:
                    path.move(to: CGPoint(x: rect.minX, y: rect.minY))
                    path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
                    path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
                }
                return { lineWidth in
                    path.lineWidth = lineWidth
                    path.stroke()
                }
            }
        }
    }
}

extension UIImage.Shape {
    struct CacheInfo: CustomStringConvertible {
        var description: String {
            return "key=\(key) size=\(size) tintColor=\(tintColor)"
        }
        let key: String
        let size: CGFloat
        let tintColor: UIColor
    }
}
