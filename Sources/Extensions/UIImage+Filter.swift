//
//  UIImage+Filter.swift
//  JJKit
//
//  Created by zgjff on 2022/9/30.
//

import UIKit

extension UIImage: JJCompatible { }

extension JJBox where Base: UIImage {
    /// 使用CoreImage给图片添加滤镜
    /// - Parameter filter: 操作滤镜生成逻辑
    /// - Returns: 滤镜之后的UIImage
    public func applyFilter(_ filter: UIImage.JJFilterAction) -> UIImage? {
        guard let inputImage = CIImage(image: base) else { return nil }
        let outputImage = filter(inputImage)
        guard let cgImage = UIImage.ciContext.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}

extension UIImage {
    /// 操作滤镜生成逻辑
    public typealias JJFilterAction = (_ inputImage: CIImage) -> CIImage
    
    /// 创建CIContext比较耗性能,所有用了一个全局context对象
    static var ciContext = CIContext(options: nil)
    
    /// 滤镜配方
    public struct JJFilter {
        private init() {}
        
        /// 滤镜生成的二维码容错等级
        public enum QRCorrectionLevel: String {
            case l = "L"
            case m = "M"
            case q = "Q"
            case h = "H"
        }
    }
}

// CICategoryBlur
public extension UIImage.JJFilter {
    /// 均值模糊---CIBoxBlur
    static var boxBlur: (_ inputRadius: Double) -> UIImage.JJFilterAction {
        return transformRadiusFilter(name: "CIBoxBlur") { inputRadius in
            return inputRadius > 100 ? 100 : (inputRadius < 1) ? 1 : inputRadius
        }
    }
    
    /// 环形卷积模糊---CIDiscBlur
    static var discBlur: (_ inputRadius: Double) -> UIImage.JJFilterAction {
        return transformRadiusFilter(name: "CIDiscBlur") { inputRadius in
            return inputRadius > 100 ? 100 : (inputRadius < 0) ? 0 : inputRadius
        }
    }
    
    /// 高斯模糊---CIGaussianBlur
    static var gaussianBlur: (_ inputRadius: Double) -> UIImage.JJFilterAction {
        return transformRadiusFilter(name: "CIGaussianBlur") { inputRadius in
            return inputRadius > 100 ? 100 : (inputRadius < 0) ? 0 : inputRadius
        }
    }
    
    private static func transformRadiusFilter(name: String, transform: @escaping (Double) -> Double) -> (Double) -> UIImage.JJFilterAction {
        return { inputRadius in
            guard let filter = CIFilter(name: name) else { fatalError() }
            let radius = transform(inputRadius)
            filter.setValue(radius, forKey: kCIInputRadiusKey)
            return { inputImage in
                filter.setValue(inputImage, forKey: kCIInputImageKey)
                guard let outputImage = filter.outputImage else { fatalError() }
                return outputImage
            }
        }
    }
}

// CICategoryColorEffect
public extension UIImage.JJFilter {
    /// CIColorInvert滤镜
    static var colorInvert: UIImage.JJFilterAction {
        return colorEffect(name: "CIColorInvert")
    }
    
    /// CIPhotoEffectChrome滤镜
    static var chrome: UIImage.JJFilterAction {
        return colorEffect(name: "CIPhotoEffectChrome")
    }
    
    /// CIColorPosterize滤镜
    static var colorPosterize: (_ inputLevle: Double) -> UIImage.JJFilterAction {
        return { inputLevle in
            guard let filter = CIFilter(name: "CIColorPosterize") else { fatalError() }
            let level = inputLevle > 30 ? 30 : (inputLevle < 2) ? 2 : inputLevle
            filter.setValue(level, forKey: "inputLevels")
            return { inputImage in
                filter.setValue(inputImage, forKey: kCIInputImageKey)
                guard let outputImage = filter.outputImage else { fatalError() }
                return outputImage
            }
        }
    }
    
    /// CIMaximumComponent滤镜
    static var maximumComponent: UIImage.JJFilterAction {
        return colorEffect(name: "CIMaximumComponent")
    }
    
    /// CIMinimumComponent滤镜
    static var minimumComponent: UIImage.JJFilterAction {
        return colorEffect(name: "CIMinimumComponent")
    }
    
    /// CIPhotoEffectFade滤镜
    static var fade: UIImage.JJFilterAction {
        return colorEffect(name: "CIPhotoEffectFade")
    }
    
    /// CIPhotoEffectInstant滤镜
    static var instant: UIImage.JJFilterAction {
        return colorEffect(name: "CIPhotoEffectInstant")
    }
    
    /// CIPhotoEffectMono滤镜
    static var mono: UIImage.JJFilterAction {
        return colorEffect(name: "CIPhotoEffectMono")
    }
    
    /// CIPhotoEffectNoir滤镜
    static var noir: UIImage.JJFilterAction {
        return colorEffect(name: "CIPhotoEffectNoir")
    }
    
    /// CIPhotoEffectProcess滤镜
    static var process: UIImage.JJFilterAction {
        return colorEffect(name: "CIPhotoEffectProcess")
    }
    
    /// CIPhotoEffectTonal滤镜
    static var tonal: UIImage.JJFilterAction {
        return colorEffect(name: "CIPhotoEffectTonal")
    }
    
    /// CIPhotoEffectTransfer滤镜
    static var transfer: UIImage.JJFilterAction {
        return colorEffect(name: "CIPhotoEffectTransfer")
    }
    
    private static func colorEffect(name: String) -> UIImage.JJFilterAction {
        guard let filter = CIFilter(name: name) else { fatalError() }
        return { inputImage in
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            guard let outputImage = filter.outputImage else { fatalError() }
            return outputImage
        }
    }
}

// CICategoryGenerator
public extension UIImage.JJFilter {
    /// 颜色生成器---CIConstantColorGenerator
    static var colorGenerator: (_ inputColor: UIColor) -> (_ size: CGSize) -> UIImage.JJFilterAction {
        return { inputColor in
            guard let filter = CIFilter(name: "CIConstantColorGenerator") else { fatalError() }
            filter.setValue(CIColor(cgColor: inputColor.cgColor), forKey: kCIInputColorKey)
            return { size in
                guard let outputImage = filter.outputImage else { fatalError() }
                let f = CGRect(origin: .zero, size: size)
                let img = outputImage.cropped(to: f)
                return { _ in
                    return img
                }
            }
        }
    }
    
    /// 二维码生成器---CIQRCodeGenerator
    static var qrGenerator: (_ inputMessage: Data) -> (_ level: QRCorrectionLevel, _ size: CGFloat) -> UIImage.JJFilterAction {
        return { inputMessage in
            guard let filter = CIFilter(name: "CIQRCodeGenerator") else { fatalError() }
            filter.setValue(inputMessage, forKey: "inputMessage")
            return { level, size in
                filter.setValue(level.rawValue, forKey: "inputCorrectionLevel")
                guard let outputImage = filter.outputImage else { fatalError() }
                let f = outputImage.extent
                let sx = size / f.width
                let sy = size / f.height
                let img = outputImage.transformed(by: CGAffineTransform(scaleX: sx, y: sy))
                return { _ in
                    return img
                }
            }
        }
    }
}
