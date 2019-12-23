import UIKit

extension UIImage {
    public static func imageWithShape(_ shape: UIImage.Shape, size: CGFloat, tintColor: UIColor = .white) -> UIImage? {
        return UIImage(size: CGSize(width: size, height: size)) { ctx in
            shape.draw(ctx: ctx, size: size, tintColor: tintColor)
        }
    }
}

extension UIImage {
    public typealias LineShape = (_ lineWidth: CGFloat) -> UIImage.Shape
    public typealias LineWithColorShape = (_ lineWidth: CGFloat, _ lineColor: UIColor) -> UIImage.Shape
    public struct Shape {
        public let actions: ((CGContext, CGFloat, UIColor) -> Void)
        
        fileprivate func draw(ctx: CGContext, size: CGFloat, tintColor: UIColor) {
            actions(ctx, size, tintColor)
        }
    }
}

extension UIImage.Shape {
    /// 空心圆  lineWidth:线条宽
    public static var circle: UIImage.LineShape = { lw in
         return UIImage.Shape { (ctx, size, tintColor) in
            ctx.setStrokeColor(tintColor.cgColor)
            UIImage.Shapes.circle(UIBezierPath(arcCenter: CGPoint(x: size * 0.5, y: size * 0.5), radius: (size - lw) * 0.5, startAngle: 0, endAngle: .pi * 2, clockwise: true))(.stroke(lineWidth: lw))
        }
    }

    /// 实心圆
    public static var circleFill = UIImage.Shape { (ctx, size, tintColor) in
        ctx.setFillColor(tintColor.cgColor)
        UIImage.Shapes.circle(UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size, height: size), cornerRadius: size * 0.5))(.fill)
    }
    
    /// +号    lineWidth:线条宽
    public static var plus: UIImage.LineShape = { lw in
        return UIImage.Shape { (ctx, size, tintColor) in
            ctx.setStrokeColor(tintColor.cgColor)
            UIImage.Shapes.plus(UIBezierPath())(CGRect(x: lw, y: lw, width: size - lw * 2, height: size - lw * 2))(lw)
        }
    }
    
    /// 空心+号    lineWidth:线条宽
    public static var plusCircle: UIImage.LineShape = { lw in
        return UIImage.Shape { (ctx, size, tintColor) in
            ctx.setStrokeColor(tintColor.cgColor)
            let path = UIBezierPath(arcCenter: CGPoint(x: size * 0.5, y: size * 0.5), radius: (size - lw) * 0.5, startAngle: 0, endAngle: .pi * 2, clockwise: true)
            UIImage.Shapes.plus(path)(CGRect(x: size * 0.28, y: size * 0.28, width: size * 0.44, height: size * 0.44))(lw)
        }
    }
    
    /// 实心+  lineWidth:线条宽  lineColor:线条颜色
    public static var plusCircleFill: UIImage.LineWithColorShape = { lw, lc in
        return UIImage.Shape { (ctx, size, tintColor) in
            ctx.setFillColor(tintColor.cgColor)
            UIImage.Shapes.circle(UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size, height: size), cornerRadius: size * 0.5))(.fill)
            ctx.setStrokeColor(lc.cgColor)
            UIImage.Shapes.plus(UIBezierPath())(CGRect(x: size * 0.28, y: size * 0.28, width: size * 0.44, height: size * 0.44))(lw)
        }
    }
    
    /// -号    lineWidth:线条宽
    public static var minus: UIImage.LineShape = { lw in
        return UIImage.Shape { (ctx, size, tintColor) in
            ctx.setStrokeColor(tintColor.cgColor)
            UIImage.Shapes.line(UIBezierPath())(CGRect(x: lw, y: 0, width: size - lw * 2, height: size))(lw)
        }
    }
    
    /// 空心-号    lineWidth:线条宽
    public static var minusCircle: UIImage.LineShape = { lw in
        return UIImage.Shape { (ctx, size, tintColor) in
            ctx.setStrokeColor(tintColor.cgColor)
            let path = UIBezierPath(arcCenter: CGPoint(x: size * 0.5, y: size * 0.5), radius: (size - lw) * 0.5, startAngle: 0, endAngle: .pi * 2, clockwise: true)
            UIImage.Shapes.circle(path)(.stroke(lineWidth: lw))
            UIImage.Shapes.line(path)(CGRect(x: size * 0.28, y: 0, width: size * 0.44, height: size))(lw)
        }
    }
    
    /// 实心-  lineWidth:线条宽  lineColor:线条颜色
    public static var minusCircleFill: UIImage.LineWithColorShape = { lw, lc in
        return UIImage.Shape { (ctx, size, tintColor) in
            ctx.setFillColor(tintColor.cgColor)
            UIImage.Shapes.circle(UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size, height: size), cornerRadius: size * 0.5))(.fill)
            ctx.setStrokeColor(lc.cgColor)
            UIImage.Shapes.line(UIBezierPath())(CGRect(x: size * 0.28, y: size * 0.28, width: size * 0.44, height: size * 0.44))(lw)
        }
    }
    
    /// x号    lineWidth:线条宽
    public static var multiply: UIImage.LineShape = { lw in
        return UIImage.Shape { (ctx, size, tintColor) in
            ctx.setStrokeColor(tintColor.cgColor)
            UIImage.Shapes.multiply(UIBezierPath())(CGRect(x: lw, y: lw, width: size - lw * 2, height: size - lw * 2))(lw)
        }
    }
    
    /// 空心x号    lineWidth:线条宽
    public static var multiplyCircle: UIImage.LineShape = { lw in
        return UIImage.Shape { (ctx, size, tintColor) in
            ctx.setStrokeColor(tintColor.cgColor)
            let path = UIBezierPath(arcCenter: CGPoint(x: size * 0.5, y: size * 0.5), radius: (size - lw) * 0.5, startAngle: 0, endAngle: .pi * 2, clockwise: true)
            UIImage.Shapes.circle(path)(.stroke(lineWidth: lw))
            let ang45: CGFloat = cos(.pi * 0.25)
            UIImage.Shapes.multiply(path)(CGRect(x: size * (0.5 - ang45 * 0.25), y: size * (0.5 - ang45 * 0.25), width: size * 0.5 * ang45, height: size * 0.5 * ang45))(lw)
        }
    }
    
    /// 实心x  lineWidth:线条宽  lineColor:线条颜色
    public static var multiplyCircleFill: UIImage.LineWithColorShape = { lw, lc in
        return UIImage.Shape { (ctx, size, tintColor) in
            ctx.setFillColor(tintColor.cgColor)
            UIImage.Shapes.circle(UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size, height: size), cornerRadius: size * 0.5))(.fill)
            ctx.setStrokeColor(lc.cgColor)
            let ang45: CGFloat = cos(.pi * 0.25)
            UIImage.Shapes.multiply(UIBezierPath())(CGRect(x: size * (0.5 - ang45 * 0.25), y: size * (0.5 - ang45 * 0.25), width: size * 0.5 * ang45, height: size * 0.5 * ang45))(lw)
        }
    }
    
    /// =号    lineWidth:线条宽
    public static var equal: UIImage.LineShape = { lw in
        return UIImage.Shape { (ctx, size, tintColor) in
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
        return UIImage.Shape { (ctx, size, tintColor) in
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
        return UIImage.Shape { (ctx, size, tintColor) in
            ctx.setFillColor(tintColor.cgColor)
            UIImage.Shapes.circle(UIBezierPath(arcCenter: CGPoint(x: size * 0.5, y: size * 0.5), radius: (size - lw) * 0.5, startAngle: 0, endAngle: .pi * 2, clockwise: true))(.fill)
            let space: CGFloat = 6
            let h = space + lw
            ctx.setStrokeColor(lc.cgColor)
            let path = UIBezierPath()
            UIImage.Shapes.line(path)(CGRect(x: size * 0.28, y: size * 0.5 - h, width: size * 0.44, height: h))(lw)
            UIImage.Shapes.line(path)(CGRect(x: size * 0.28, y: size * 0.5, width: size * 0.44, height: h))(lw)
        }
    }
}


extension UIImage {
    fileprivate struct Shapes {
        enum CircleStyle {
            case fill
            case stroke(lineWidth: CGFloat)
        }
        
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
    }
}
