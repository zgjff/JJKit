import QuartzCore

extension CAKeyframeAnimation {
    public func setValues<T>(from source: T, to destination: T, using easingFuncName: EasingAnimatorFunctionName) where T: KeyFrameValueable {
        let count = 60 // 1秒60帧
        var kvalues = Array<T>()
        kvalues.reserveCapacity(count)
        let time = Float(1000) // 1000毫秒
        let avgTime = time / Float(count - 1)
        let f = easingFuncName.function
        for i in 0..<count {
            let keyTime = avgTime * Float(i)
            let value = T.getKeyFrameValue(keyTime: keyTime, from: source, to: destination, duration: time, using: f)
            kvalues.append(value)
        }
        self.values = kvalues
    }
}

public protocol KeyFrameValueable {}

extension KeyFrameValueable {
    fileprivate static func getKeyFrameValue(keyTime: Float, from source: Self, to destination: Self, duration time: Float, using easingFunction: Easings.Funtion) -> Self {
        if let f = source as? CGFloat, let t = destination as? CGFloat {
            let v = easingFunction(keyTime, Float(f), Float(t - f), time)
            return CGFloat(v) as! Self
        }
        if let f = source as? CGPoint, let t = destination as? CGPoint {
            let x = easingFunction(keyTime, Float(f.x), Float(t.x - f.x), time)
            let y = easingFunction(keyTime, Float(f.y), Float(t.y - f.y), time)
            return CGPoint(x: CGFloat(x), y: CGFloat(y)) as! Self
        }
        if let f = source as? CGSize, let t = destination as? CGSize {
            let w = easingFunction(keyTime, Float(f.width), Float(t.width - f.width), time)
            let h = easingFunction(keyTime, Float(f.height), Float(t.height - f.height), time)
            return CGSize(width: CGFloat(w), height: CGFloat(h)) as! Self
        }
        return destination
    }
}

extension CGFloat: KeyFrameValueable {}
extension CGPoint: KeyFrameValueable {}
extension CGSize: KeyFrameValueable {}

/// 缓动函数动画名称
///
/// 动画效果:  https://easings.net/
public struct EasingAnimatorFunctionName: Hashable, Equatable, RawRepresentable {
    public let rawValue: String
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension EasingAnimatorFunctionName {
    internal var function: Easings.Funtion {
        switch self {
        case .linear:                         return Easings.Linear.default
            
        case .QuadEaseIn:                      return Easings.Quad.easeIn
        case .QuadEaseOut:                     return Easings.Quad.easeOut
        case .QuadEaseInOut:                   return Easings.Quad.easeInOut
            
        case .SineEaseIn:                      return Easings.Sine.easeIn
        case .SineEaseOut:                     return Easings.Sine.easeOut
        case .SineEaseInOut:                   return Easings.Sine.easeInOut
            
        case .CubicEaseIn:                     return Easings.Cubic.easeIn
        case .CubicEaseOut:                    return Easings.Cubic.easeOut
        case .CubicEaseInOut:                  return Easings.Cubic.easeInOut
            
        case .QuartEaseIn:                     return Easings.Quart.easeIn
        case .QuartEaseOut:                    return Easings.Quart.easeOut
        case .QuartEaseInOut:                  return Easings.Quart.easeInOut
            
        case .QuintEaseIn:                     return Easings.Quint.easeIn
        case .QuintEaseOut:                    return Easings.Quint.easeOut
        case .QuintEaseInOut:                  return Easings.Quint.easeInOut
            
        case .CircEaseIn:                      return Easings.Circ.easeIn
        case .CircEaseOut:                     return Easings.Circ.easeOut
        case .CircEaseInOut:                   return Easings.Circ.easeInOut
            
        case .ExpoEaseIn:                      return Easings.Expo.easeIn
        case .ExpoEaseOut:                     return Easings.Expo.easeOut
        case .ExpoEaseInOut:                   return Easings.Expo.easeInOut
            
        case .ElasticEaseIn:                   return Easings.Elastic.easeIn
        case .ElasticEaseOut:                  return Easings.Elastic.easeOut
        case .ElasticEaseInOut:                return Easings.Elastic.easeInOut
            
        case .BackEaseIn:                     return Easings.Back.easeIn
        case .BackEaseOut:                    return Easings.Back.easeOut
        case .BackEaseInOut:                  return Easings.Back.easeInOut
            
        case .BounceEaseIn:                   return Easings.Bounce.easeIn
        case .BounceEaseOut:                  return Easings.Bounce.easeOut
        case .BounceEaseInOut:                return Easings.Bounce.easeInOut
            
        default:                           fatalError("缓动函数Easings没有此类函数")
        }
    }
}

public extension EasingAnimatorFunctionName {
    static var linear                = EasingAnimatorFunctionName(rawValue: "EasingLinerFunction")
    
    static var QuadEaseIn            = EasingAnimatorFunctionName(rawValue: "EasingQuadEaseInFunction")
    static var QuadEaseOut           = EasingAnimatorFunctionName(rawValue: "EasingQuadEaseOutFunction")
    static var QuadEaseInOut         = EasingAnimatorFunctionName(rawValue: "EasingQuadEaseInOutFunction")
    
    static var SineEaseIn            = EasingAnimatorFunctionName(rawValue: "EasingSineEaseInFunction")
    static var SineEaseOut           = EasingAnimatorFunctionName(rawValue: "EasingSineEaseOutFunction")
    static var SineEaseInOut         = EasingAnimatorFunctionName(rawValue: "EasingSineEaseInOutFunction")
    
    static var CubicEaseIn           = EasingAnimatorFunctionName(rawValue: "EasingCubicEaseInFunction")
    static var CubicEaseOut          = EasingAnimatorFunctionName(rawValue: "EasingCubicEaseOutFunction")
    static var CubicEaseInOut        = EasingAnimatorFunctionName(rawValue: "EasingCubicEaseInOutFunction")
    
    static var QuartEaseIn           = EasingAnimatorFunctionName(rawValue: "EasingQuartEaseInFunction")
    static var QuartEaseOut          = EasingAnimatorFunctionName(rawValue: "EasingQuartEaseOutFunction")
    static var QuartEaseInOut        = EasingAnimatorFunctionName(rawValue: "EasingQuartEaseInOutFunction")
    
    static var QuintEaseIn           = EasingAnimatorFunctionName(rawValue: "EasingQuintEaseInFunction")
    static var QuintEaseOut          = EasingAnimatorFunctionName(rawValue: "EasingQuintEaseOutFunction")
    static var QuintEaseInOut        = EasingAnimatorFunctionName(rawValue: "EasingQuintEaseInOutFunction")
    
    static var CircEaseIn            = EasingAnimatorFunctionName(rawValue: "EasingCircEaseInFunction")
    static var CircEaseOut           = EasingAnimatorFunctionName(rawValue: "EasingCircEaseOutFunction")
    static var CircEaseInOut         = EasingAnimatorFunctionName(rawValue: "EasingCircEaseInOutFunction")
    
    static var ExpoEaseIn            = EasingAnimatorFunctionName(rawValue: "EasingExpoEaseInFunction")
    static var ExpoEaseOut           = EasingAnimatorFunctionName(rawValue: "EasingExpoEaseOutFunction")
    static var ExpoEaseInOut         = EasingAnimatorFunctionName(rawValue: "EasingExpoEaseInOutFunction")
    
    static var ElasticEaseIn         = EasingAnimatorFunctionName(rawValue: "EasingElasticEaseInFunction")
    static var ElasticEaseOut        = EasingAnimatorFunctionName(rawValue: "EasingElasticEaseOutFunction")
    static var ElasticEaseInOut      = EasingAnimatorFunctionName(rawValue: "EasingElasticEaseInOutFunction")
    
    static var BackEaseIn            = EasingAnimatorFunctionName(rawValue: "EasingBackEaseInFunction")
    static var BackEaseOut           = EasingAnimatorFunctionName(rawValue: "EasingBackEaseOutFunction")
    static var BackEaseInOut         = EasingAnimatorFunctionName(rawValue: "EasingBackEaseInOutFunction")
    
    static var BounceEaseIn          = EasingAnimatorFunctionName(rawValue: "EasingBounceEaseInFunction")
    static var BounceEaseOut         = EasingAnimatorFunctionName(rawValue: "EasingBounceEaseOutFunction")
    static var BounceEaseInOut       = EasingAnimatorFunctionName(rawValue: "EasingBounceEaseInOutFunction")
}
