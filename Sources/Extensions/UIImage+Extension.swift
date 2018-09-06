import UIKit
private let context = CIContext(options: nil)
private let filterQueue = DispatchQueue(label: "filterImageQueue.JJKit", attributes: [.concurrent])
extension UIImage {
    /// 所在位置 占 总长的百分比
    public typealias Location = CGFloat
    /// 所在位置的x，y百分比（x/总宽，y/总长）
    public typealias Position = CGPoint
}

extension UIImage {
    /// 在size大小CGContext画布中，根据modiy闭包来操作画布
    ///
    /// - Parameters:
    ///   - size: 图像画布大小
    ///   - actions: 操作画布---block(CGContext)
    public convenience init?(size: CGSize, scale: CGFloat = UIScreen.main.scale, action: @escaping (CGContext) -> ()) {
        if #available(iOS 10.0, *) {
            let f = UIGraphicsImageRendererFormat.default()
            f.scale = scale
            let render = UIGraphicsImageRenderer(size: size, format: f)
            let i = render.image { c in
                action(c.cgContext)
            }
            if let cg = i.cgImage {
                self.init(cgImage: cg, scale: i.scale, orientation: i.imageOrientation)
            } else {
                return nil
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            defer {
                UIGraphicsEndImageContext()
            }
            if let c = UIGraphicsGetCurrentContext() {
                c.saveGState()
                action(c)
                c.restoreGState()
            }
            guard let img = UIGraphicsGetImageFromCurrentImageContext(),
                let cg = img.cgImage else {
                    return nil
            }
            self.init(cgImage: cg, scale: img.scale, orientation: img.imageOrientation)
        }
    }
    /// 颜色 -> 纯色图像
    ///
    /// - Parameters:
    ///   - color: 颜色
    ///   - size: 大小 默认 CGSize(width: 1, height: 1)
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let colorSize = UIColorImageCache.ColorSize(color: color, size: size)
        let cacheImg = UIColorImageCache.shared.imageFor(colorSize: colorSize)
        guard cacheImg == nil else {
            self.init(cgImage: cacheImg!.cgImage!, scale: cacheImg!.scale, orientation: cacheImg!.imageOrientation)
            return
        }
        let build: (CGContext) -> () = { context in
            color.set()
            context.fill(CGRect(origin: .zero, size: size))
        }
        if let img = UIImage(size: size, action: build), let cg = img.cgImage {
            UIColorImageCache.shared.setImage(img, for: colorSize)
            self.init(cgImage: cg, scale: img.scale, orientation: img.imageOrientation)
        } else {
            return nil
        }
    }
    
    /// 线性颜色渐变图像
    ///
    /// - Parameters:
    ///   - linearColors: (颜色, 起始点)变参 注意：起始点范围(0~1.0)
    ///   - size: 大小
    ///   - start: 起始点(起点所在size中的x，y的百分比)
    ///   - end: 结束点(起点所在size中的x，y的百分比)
    public convenience init?(linearColors: (color: UIColor, location: Location)..., size: CGSize, start: Position = .zero, end: Position = CGPoint(x: 1, y: 0)) {
        let build: (CGContext) -> () = { context in
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let initial: ([CGFloat], [Location]) = ([], [])
            let (colorComponents, locations) = linearColors.map({ tupe -> ([CGFloat], Location)? in
                guard let colorComponents = tupe.color.cgColor.components else {
                    return nil
                }
                return (colorComponents, tupe.location)
            })
                .reduce(initial, { (result, signle) -> ([CGFloat], [Location]) in
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
        guard let img = UIImage(size: size, action: build),
            let cg = img.cgImage else {
                return nil
        }
        self.init(cgImage: cg, scale: img.scale, orientation: img.imageOrientation)
    }
    
    /// 径向颜色渐变图像
    ///
    /// - Parameters:
    ///   - radialColors: (颜色, 起始点)变参 注意：起始点范围(0~1.0)
    ///   - size: 大小
    ///   - center: 中心点(中心点所在size中的x，y的百分比)
    ///   - radius: 径向渐变半径
    public convenience init?(radialColors: (color: UIColor, location: Location)..., size: CGSize, center: Position, radius: CGFloat) {
        let build: (CGContext) -> () = { context in
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let initial: ([CGFloat], [Location]) = ([], [])
            let (colorComponents, locations) = radialColors.map({ tupe -> ([CGFloat], Location)? in
                guard let colorComponents = tupe.color.cgColor.components else {
                    return nil
                }
                return (colorComponents, tupe.location)
            })
                .reduce(initial, { (result, signle) -> ([CGFloat], [Location]) in
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
        guard let img = UIImage(size: size, action: build),
            let cg = img.cgImage else {
                return nil
        }
        self.init(cgImage: cg, scale: img.scale, orientation: img.imageOrientation)
    }
}

extension UIImage: JJCompatible {}

extension JJ where Original: UIImage {
    /// 改变图像的颜色
    ///
    /// - Parameter tintColor: 要变的颜色
    /// - Returns: 结果
    public func applyTintColor(_ tintColor: UIColor) -> UIImage? {
        let size = original.size
        return UIImage(size: size, action: { context in
            tintColor.setFill()
            UIRectFill(CGRect(origin: .zero, size: size))
            self.original.draw(in: CGRect(origin: .zero, size: size), blendMode: .destinationIn, alpha: 1.0)
        })
    }
    /// 创建圆角图片
    ///
    /// - Parameters:
    ///   - radius: 圆角大小
    ///   - corners: UIRectCorner
    ///   - border: 边框宽度
    ///   - color: 边框颜色
    /// - Returns: 圆角图片
    public func apply(radius: CGFloat, corners: UIRectCorner = .allCorners, border: CGFloat = 0, color: UIColor? = nil) -> UIImage? {
        let size = original.size
        return UIImage(size: size, action: { context in
            guard let cgImg = self.original.cgImage else { return }
            let rect = CGRect(origin: .zero, size: size)
            context.scaleBy(x: 1, y: -1)
            context.translateBy(x: 0, y: -rect.size.height)
            let minSize = min(size.width, size.height)
            if border < minSize / 2 {
                let path = UIBezierPath(roundedRect: rect.insetBy(dx: border, dy: border), byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: border))
                path.close()
                context.saveGState()
                path.addClip()
                context.draw(cgImg, in: rect)
                context.restoreGState()
            }
            if let borderColor = color, border > 0, border < minSize / 2 {
                let strokeInset = (floor(border * self.original.scale) + 0.5) / self.original.scale
                let strokeRect = rect.insetBy(dx: strokeInset, dy: strokeInset)
                let strokeRadius = radius > self.original.scale / 2 ? radius - self.original.scale / 2 : 0
                let path = UIBezierPath(roundedRect: strokeRect, byRoundingCorners: corners, cornerRadii: CGSize(width: strokeRadius, height: border))
                path.close()
                path.lineWidth = border
                path.lineJoinStyle = .miter
                borderColor.setStroke()
                path.stroke()
            }
        })
    }
    /// 根据滤镜配方创建滤镜图片
    ///
    /// - Parameters:
    ///   - filter: (CIImage) -> CIImage
    ///   - result: 主线程回掉滤镜结果
    public func applyFilter(_ filter: (CIImage) -> CIImage, result: @escaping (UIImage) -> ()) {
        guard let inputImage = CIImage(image: original) else {
            result(original)
            return
        }
        let out = filter(inputImage)
        filterQueue.async {
            var img: UIImage = self.original
            if let cg = context.createCGImage(out, from: inputImage.extent) {
                img = UIImage(cgImage: cg, scale: self.original.scale, orientation: self.original.imageOrientation)
            }
            DispatchQueue.main.async {
                result(img)
            }
        }
    }
}


/**************************private*****************************/
/// 纯色图像缓存
private struct UIColorImageCache {
    struct ColorSize: CustomStringConvertible {
        var description: String {
            let width = size.width
            let height = size.height
            return "\(color.hashValue ^ width.hashValue ^ height.hashValue &* 16777619)"
        }
        let color: UIColor
        let size: CGSize
        init(color: UIColor, size: CGSize) {
            self.color = color
            self.size = size
        }
    }
    static let shared = UIColorImageCache()
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
