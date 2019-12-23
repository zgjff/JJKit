import UIKit

extension UIImage {
    /// 在size大小CGContext画布中，根据modiy闭包来操作画布
    ///
    /// - Parameters:
    ///   - size: 图像画布大小
    ///   - actions: 操作画布---block(CGContext)
    public convenience init?(size: CGSize, actions: @escaping (CGContext) -> ()) {
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
        let colorSize = UIColorImageCache.ColorSize(color: color, size: size, cornerRadius: cornerRadius)
        let cacheImg = UIColorImageCache.shared.imageFor(colorSize: colorSize)
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
            UIColorImageCache.shared.setImage(img, for: colorSize)
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

extension UIImage: JJCompatible {}

extension JJ where Object: UIImage {
    /// 改变图像的颜色
    ///
    /// - Parameter tintColor: 要变的颜色
    /// - Returns: 结果
    public func applyTintColor(_ tintColor: UIColor) -> UIImage? {
        guard let cgImage = object.cgImage else {
            return nil
        }
        let size = object.size
        let rect = CGRect(origin: .zero, size: size)
        return UIImage(size: size, actions: { context in
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1, y: -1)
            context.setBlendMode(.normal)
            context.clip(to: rect, mask: cgImage)
            context.setFillColor(tintColor.cgColor)
            context.fill(rect)
        })
    }
    
    /// 调整图像大小
    /// - Parameter maxSize: 根据图像原始宽高比与指定的最大尺寸maxSize来缩放图像
    public func resized(maxSize: CGFloat) -> UIImage? {
        guard let data = object.pngData() else { return nil }
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: maxSize
        ]
        guard let img = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) else {
            return nil
        }
        return UIImage(cgImage: img)
    }
}

/**************************private*****************************/
/// 纯色图像缓存
private struct UIColorImageCache {
    struct ColorSize: CustomStringConvertible {
        var description: String {
            let width = size.width
            let height = size.height
            return "color:\(color) width:\(width) height:\(height) cornerRadius:\(cornerRadius)"
        }
        let color: UIColor
        let size: CGSize
        let cornerRadius: CGFloat
        init(color: UIColor, size: CGSize, cornerRadius: CGFloat) {
            self.color = color
            self.size = size
            self.cornerRadius = cornerRadius
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
