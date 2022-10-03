//
//  UIImage+Filter.swift
//  JJKit
//
//  Created by zgjff on 2022/9/30.
//

import UIKit

extension JJBox where Base: UIImage {
    /// 使用CoreImage给图片添加滤镜
    /// - Parameter filter: 滤镜配方
    /// - Returns: 滤镜之后的UIImage
    public func applyFilter(_ filter: UIImage.Filter) -> UIImage? {
        guard let inputImage = CIImage(image: base) else { return nil }
        let outputImage = filter(inputImage)
        guard let cgImage = UIImage.ciContext.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}

extension UIImage {
    /// 滤镜配方
    public typealias Filter = (_ inputImage: CIImage) -> CIImage
    static var ciContext = CIContext(options: nil)
}

/// 滤镜配方
public struct Filter {
    private init() {}
    
    
    /// 滤镜生成的二维码容错等级
    public enum QRCorrectionLevel: String {
        case l = "L"
        case m = "M"
        case q = "Q"
        case h = "H"
    }
}

// CICategoryBlur
public extension Filter {
    /// 均值模糊
    static var boxBlur: (_ inputRadius: Double) -> UIImage.Filter {
        return transformRadiusFilter(name: "CIBoxBlur") { inputRadius in
            return inputRadius > 100 ? 100 : (inputRadius < 1) ? 1 : inputRadius
        }
    }
    
    /// 环形卷积模糊
    static var discBlur: (_ inputRadius: Double) -> UIImage.Filter {
        return transformRadiusFilter(name: "CIDiscBlur") { inputRadius in
            return inputRadius > 100 ? 100 : (inputRadius < 0) ? 0 : inputRadius
        }
    }
    
    /// 高斯模糊
    static var gaussianBlur: (_ inputRadius: Double) -> UIImage.Filter {
        return transformRadiusFilter(name: "CIGaussianBlur") { inputRadius in
            return inputRadius > 100 ? 100 : (inputRadius < 0) ? 0 : inputRadius
        }
    }
    
    private static func transformRadiusFilter(name: String, transform: @escaping (Double) -> Double) -> (Double) -> UIImage.Filter {
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
public extension Filter {
    static var colorInvert: UIImage.Filter {
        return colorEffect(name: "CIColorInvert")
    }
    
    static var chrome: UIImage.Filter {
        return colorEffect(name: "CIPhotoEffectChrome")
    }
    
    static var colorPosterize: (_ inputLevle: Double) -> UIImage.Filter {
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
    
    static var maximumComponent: UIImage.Filter {
        return colorEffect(name: "CIMaximumComponent")
    }
    
    static var minimumComponent: UIImage.Filter {
        return colorEffect(name: "CIMinimumComponent")
    }
    
    static var fade : UIImage.Filter {
        return colorEffect(name: "CIPhotoEffectFade")
    }
    
    static var instant : UIImage.Filter {
        return colorEffect(name: "CIPhotoEffectInstant")
    }
    
    static var mono : UIImage.Filter {
        return colorEffect(name: "CIPhotoEffectMono")
    }
    
    static var noir : UIImage.Filter {
        return colorEffect(name: "CIPhotoEffectNoir")
    }
    
    static var process : UIImage.Filter {
        return colorEffect(name: "CIPhotoEffectProcess")
    }
    
    static var tonal : UIImage.Filter {
        return colorEffect(name: "CIPhotoEffectTonal")
    }
    
    static var transfer : UIImage.Filter {
        return colorEffect(name: "CIPhotoEffectTransfer")
    }
    
    private static func colorEffect(name: String) -> UIImage.Filter {
        guard let filter = CIFilter(name: name) else { fatalError() }
        return { inputImage in
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            guard let outputImage = filter.outputImage else { fatalError() }
            return outputImage
        }
    }
}

// CICategoryGenerator
public extension Filter {
    /// 颜色生成器
    static var colorGenerator: (_ inputColor: UIColor) -> (_ size: CGSize) -> UIImage.Filter {
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
    
    /// 二维码生成器
    static var qrGenerator: (_ inputMessage: Data) -> (_ level: QRCorrectionLevel, _ size: CGSize) -> UIImage.Filter {
        return { inputMessage in
            guard let filter = CIFilter(name: "CIQRCodeGenerator") else { fatalError() }
            filter.setValue(inputMessage, forKey: "inputMessage")
            return { level, size in
                filter.setValue(level.rawValue, forKey: "inputCorrectionLevel")
                guard let outputImage = filter.outputImage else { fatalError() }
                let f = outputImage.extent
                let sx = size.width / f.width
                let sy = size.height / f.height
                let img = outputImage.transformed(by: CGAffineTransform(scaleX: sx, y: sy))
                return { _ in
                    return img
                }
            }
        }
    }
}
