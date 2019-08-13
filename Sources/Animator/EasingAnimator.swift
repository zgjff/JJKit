import QuartzCore

public struct EasingAnimator {
    
}

extension CAKeyframeAnimation {
    func setValues(from: CGFloat, to: CGFloat, using easingFuncName: EasingAnimatorFunctionName) {
        let count = 60
        var values = Array<Float>.init(repeating: 0, count: count)
        let duration = Float(1000)
        let preTime = duration / Float(count - 1)
        for i in 0..<count {
            let value = easingFuncName.function(preTime * Float(i), Float(from), Float(to - from), duration)
            values[i] = value
        }
        self.values = values
    }
    
    func setValues(from: CGPoint, to: CGPoint, using easingFuncName: EasingAnimatorFunctionName) {
        let count = 60
        var values = Array<CGPoint>.init(repeating: .zero, count: count)
        let duration = Float(1000)
        let preTime = duration / Float(count - 1)
        let f = easingFuncName.function
        for i in 0..<count {
            let x = f(preTime * Float(i), Float(from.x), Float(to.x - from.x), duration)
            let y = f(preTime * Float(i), Float(from.y), Float(to.y - from.y), duration)
            values[i] = CGPoint(x: CGFloat(x), y: CGFloat(y))
        }
        self.values = values
    }
}


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
    internal var function: (Float, Float, Float, Float) -> Float {
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
