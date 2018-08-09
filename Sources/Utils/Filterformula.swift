//
//  Filterformula.swift
//  Demo
//
//  Created by 123 on 2018/8/9.
//  Copyright © 2018年 郑桂杰. All rights reserved.
//

import CoreImage
import UIKit

/// 滤镜配方
public struct Filterformula {
    public typealias Filter = (CIImage) -> CIImage
    
    public static let shared = Filterformula()
    public let context: CIContext
    private init() {
        context = CIContext(options: nil)
    }
}

// MARK: - kCICategoryBlur
extension Filterformula {
    /// 高斯模糊滤镜
    ///
    /// - Parameter radius: 模糊半径 (0...100)
    /// - Returns: (CIImage) -> CIImage
    public static func gaussianBlur(radius: Double = 10) -> Filter {
        assert(0...100 ~= radius, "radius 范围不能超过 0...100")
        return { inputImage in
            let parameters: [String: Any] = [
                kCIInputImageKey: inputImage,
                kCIInputRadiusKey: radius
            ]
            return getFilter(name: "CIGaussianBlur", parameters: parameters)
        }
    }
    
    /// 圆盘形模糊
    ///
    /// - Parameter radius: 模糊半径 0...100
    /// - Returns: (CIImage) -> CIImage
    public static func discBlur(radius: Double = 8) -> Filter {
        assert(0...100 ~= radius, "radius 范围不能超过 0...100")
        return { inputImage in
            let parameters: [String: Any] = [
                kCIInputImageKey: inputImage,
                kCIInputRadiusKey: radius
            ]
            return getFilter(name: "CIDiscBlur", parameters: parameters)
        }
    }
}


// MARK: - CICategoryColorAdjustment
extension Filterformula {
    /// 修改颜色值以使其保持在指定范围内
    /// 在每个像素处，将增加小于inputMinComponents中的颜色分量值以匹配inputMinComponents中的颜色分量值,
    /// 并且将减少大于inputMaxComponents中的颜色分量值以匹配inputMaxComponents中的颜色分量值。
    ///
    /// - Parameters:
    ///   - min: RGBA值表示范围的下限: 默认: [0 0 0 0]
    ///   - max: RGBA值表示范围的上限: 默认:  [1 1 1 1]
    /// - Returns: (CIImage) -> CIImage
    public static func clampColor(min: CIVector = CIVector(x: 0, y: 0, z: 0, w: 0), max: CIVector = CIVector(x: 1, y: 1, z: 1, w: 1)) -> Filter {
        return { inputImage in
            let parameters: [String: Any] = [
                kCIInputImageKey: inputImage,
                "inputMinComponents": min,
                "inputMaxComponents": max
            ]
            return getFilter(name: "CIColorClamp", parameters: parameters)
        }
    }
    
    /// 反转图像中的颜色
    ///
    /// - Returns: (CIImage) -> CIImage
    public static func invertColor() -> Filter {
        return { inputImage in
            let parameters: [String: Any] = [
                kCIInputImageKey: inputImage
            ]
            return getFilter(name: "CIColorInvert", parameters: parameters)
        }
    }
    
    /// 怀旧滤镜
    ///
    /// - Returns: (CIImage) -> CIImage
    public static func instant() -> Filter {
        return { inputImage in
            let parameters: [String: Any] = [
                kCIInputImageKey: inputImage
            ]
            return getFilter(name: "CIPhotoEffectInstant", parameters: parameters)
        }
    }
    
    /// 重新映射颜色，使其落入单一颜色的阴影中
    ///
    /// - Parameters:
    ///   - color: 要映射的颜色
    ///   - intensity: 颜色强度
    /// - Returns: (CIImage) -> CIImage
    public static func monoChrome(color: UIColor, intensity: Float) -> Filter {
        assert(intensity >= 0 && intensity <= 1, "intensity 范围为 0...1")
        return { inputImage in
            let parameters: [String: Any] = [
                kCIInputImageKey: inputImage,
                kCIInputColorKey: CIColor(cgColor: color.cgColor),
                kCIInputIntensityKey: intensity
            ]
            return getFilter(name: "CIColorMonochrome", parameters: parameters)
        }
    }
    
    /// 从max（r，g，b）返回灰度图像
    ///
    /// - Returns: CIImage) -> CIImage
    public static func maxComponent() -> Filter {
        return { inputImage in
            let parameters: [String: Any] = [
                kCIInputImageKey: inputImage
            ]
            return getFilter(name: "CIMaximumComponent", parameters: parameters)
        }
    }
    
    /// 从min（r，g，b）返回灰度图像
    ///
    /// - Returns: CIImage) -> CIImage
    public static func minComponent() -> Filter {
        return { inputImage in
            let parameters: [String: Any] = [
                kCIInputImageKey: inputImage
            ]
            return getFilter(name: "CIMinimumComponent", parameters: parameters)
        }
    }
    
    /// 复古摄影胶片
    ///
    /// - Returns: CIImage) -> CIImage
    public static func chrome() -> Filter {
        return { inputImage in
            let parameters: [String: Any] = [
                kCIInputImageKey: inputImage
            ]
            return getFilter(name: "CIPhotoEffectChrome", parameters: parameters)
        }
    }
    
    /// 褪色滤镜
    ///
    /// - Returns: (CIImage) -> CIImage
    public static func fade() -> Filter {
        return { inputImage in
            let parameters: [String: Any] = [
                kCIInputImageKey: inputImage
            ]
            return getFilter(name: "CIPhotoEffectFade", parameters: parameters)
        }
    }
    
    /// 黑白摄影胶片
    ///
    /// - Returns: (CIImage) -> CIImage
    public static func mono() -> Filter {
        return { inputImage in
            let parameters: [String: Any] = [
                kCIInputImageKey: inputImage
            ]
            return getFilter(name: "CIPhotoEffectMono", parameters: parameters)
        }
    }
    
    /// 黑白滤镜
    ///
    /// - Returns: (CIImage) -> CIImage
    public static func noir() -> Filter {
        return { inputImage in
            let parameters: [String: Any] = [
                kCIInputImageKey: inputImage
            ]
            return getFilter(name: "CIPhotoEffectNoir", parameters: parameters)
        }
    }
    
    /// 复古摄影胶片，强调冷色调。
    ///
    /// - Returns: (CIImage) -> CIImage
    public static func process() -> Filter {
        return { inputImage in
            let parameters: [String: Any] = [
                kCIInputImageKey: inputImage
            ]
            return getFilter(name: "CIPhotoEffectProcess", parameters: parameters)
        }
    }
    
    /// 复古摄影胶片，强调暖色调。
    ///
    /// - Returns: (CIImage) -> CIImage
    public static func transfer() -> Filter {
        return { inputImage in
            let parameters: [String: Any] = [
                kCIInputImageKey: inputImage
            ]
            return getFilter(name: "CIPhotoEffectTransfer", parameters: parameters)
        }
    }
    
    /// 黑白摄影胶片而不会显着改变对比度
    ///
    /// - Returns: (CIImage) -> CIImage
    public static func tonal() -> Filter {
        return { inputImage in
            let parameters: [String: Any] = [
                kCIInputImageKey: inputImage
            ]
            return getFilter(name: "CIPhotoEffectTonal", parameters: parameters)
        }
    }
    
    /// 棕褐色滤镜(老照片效果)
    ///
    /// - Returns: (CIImage) -> CIImage
    
    /// 棕褐色滤镜(老照片效果)
    ///
    /// - Parameter i: 亮度(0...1)
    /// - Returns: (CIImage) -> CIImage
    public static func sepiaTone(intensity: Float) -> Filter {
        var newInten: Float
        if intensity < 0 {
            newInten = 0
        } else if intensity > 1 {
            newInten = 1
        } else {
            newInten = intensity
        }
        return { inputImage in
            let parameters: [String: Any] = [
                kCIInputImageKey: inputImage,
                kCIInputIntensityKey: newInten
            ]
            return getFilter(name: "CISepiaTone", parameters: parameters)
        }
    }
}

// MARK: - Generator 生成器
extension Filterformula {
    /// 颜色叠层滤镜
    ///
    /// - Parameter color: 颜色
    /// - Returns: (CIImage) -> CIImage 注:输入的CIImage不参与计算
    public static func generate(color: UIColor) -> Filter {
        return { _ in
            let parameters: [String: Any] = [
                kCIInputColorKey: CIColor(cgColor: color.cgColor)
            ]
            return getFilter(name: "CIConstantColorGenerator", parameters: parameters)
        }
    }
    
    public static func crop(_ rectangle: CIVector) -> Filter {
        return { inputImage in
            let parameters: [String: Any] = [
                kCIInputImageKey: inputImage,
                "inputRectangle": rectangle
            ]
            return getFilter(name: "CICrop", parameters: parameters)
        }
    }
    
    /// 缩放图像
    ///
    /// - Parameters:
    ///   - scale: 缩放比例  0.05--1.5
    ///   - ratio: 宽高比 0.5--2
    /// - Returns: (CIImage) -> CIImage
    public static func scale(_ scale: Float, ratio: Float) -> Filter {
        return { inputImage in
            let parameters: [String: Any] = [
                kCIInputImageKey: inputImage,
                "inputScale": scale,
                "inputAspectRatio": ratio
            ]
            return getFilter(name: "CILanczosScaleTransform", parameters: parameters)
        }
    }
    
    
    /// 旋转图像，同时缩放和裁剪图像，使旋转的图像适合输入图像的范围
    ///
    /// - Parameter rotate: 旋转的角度
    /// - Returns: (CIImage) -> CIImage
    public static func rotate(_ rotate: Float) -> Filter {
        return { inputImage in
            let parameters: [String: Any] = [
                kCIInputImageKey: inputImage,
                "inputAngle": rotate
            ]
            return getFilter(name: "CIStraightenFilter", parameters: parameters)
        }
    }
}


// MARK: - CICategoryStylize
extension Filterformula {
    /// 调整图像的色调映射，同时保留空间细节。(传送中的美白效果)
    ///
    /// - Parameters:
    ///   - shadow: 阴影 -1 ~ 1
    ///   - highligh: 高亮 0.3~ 1.0
    ///   - radius: 范围  0~10
    /// - Returns: (CIImage) -> CIImage
    public static func adjust(shadow: Float, highligh: Float, radius: Float = 0) -> Filter {
        return { inputImage in
            let parameters: [String: Any] = [
                kCIInputImageKey: inputImage,
                kCIInputRadiusKey: radius,
                "inputHighlightAmount": highligh,
                "inputShadowAmount": shadow
            ]
            return getFilter(name: "CIHighlightShadowAdjust", parameters: parameters)
        }
    }
    
    /// 马赛克效果
    ///
    /// - Parameters:
    ///   - center: 需要打码的点
    ///   - scale: 比例,数值越大越明显 1~100
    /// - Returns: (CIImage) -> CIImage
    public static func pixellate(center: CGPoint, scale: Float) -> Filter {
        return { inputImage in
            let parameters: [String: Any] = [
                kCIInputImageKey: inputImage,
                kCIInputCenterKey: CIVector(cgPoint: center),
                kCIInputScaleKey: scale
            ]
            return getFilter(name: "CIPixellate", parameters: parameters)
        }
    }
}


extension Filterformula {
    private static func getFilter(name: String, parameters: [String: Any]) -> CIImage {
        guard let filter = CIFilter(name: name,
                                    withInputParameters: parameters)
            else { fatalError() }
        guard let outputImage = filter.outputImage
            else { fatalError() }
        return outputImage
    }
}

