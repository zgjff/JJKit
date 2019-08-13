/// 缓动公式数学原理  http://blog.cgsdream.org/2015/09/19/tweenslow-motion-formula/
/// 参数解析
/// t:timestamp,动画执行到当前帧所进过的时间
/// b:begining,起始值
/// c:change,需要变化的量
/// d:duration，动画的总时间

/// 首先要清楚的是所做的动画其实是帧动画，每一帧所经过的时间相同，只是由于上一帧与下一帧的位移量不同，因此速度在视觉上感受不同，位移量小，感觉上速度就慢了。
/// 1.动画执行时间的变化可表达为0 -> d，提取出常数d，就变成d*(0 -> 1)，变化部分为(0->1),记为x轴变化；
/// 2. 动画总的变化量和开始值是已知的，其变化可以表达为b -> b+c,提取一下变为b+c*(0 -> 1)，变化部分也是(0->1)，记为y轴变化;
/// 3. t用来指示事件当前的时间点，将其变为指示动画完成的百分比，即t/d；
/// 4. 通过上面的变换，我们需要做的事情就是构造x轴区间为[0,1],y轴区间也为[0,1]的线性
///    或者非线性关系了（也可以说是经过(0,0)和(1,1)点的线性或非线性关系），线性关系
///    太就是y=x，也就是常用的linear了，非线性复杂一点。
/// 5. 非线性关系函数
/// 5.1 利用指数函数(x的n次方)可以构造一大堆easein的效果，再根据他们的轴对称或者中心对称做翻转和位移，又可以构造出其对应的easeout效果
/// 5.2 利用平方根(Math.sqrt)或者立方根来实现这种非线性关系：
/// 5.3 sin或者cos函数可以通过调节参数构造两种运动趋势(下面主要给函数表达式):
/// 5.4 通过幂函数或者对数函数：
/// 5.5 效果还可以叠加呀，叠加的结果除以2，就能创造弹簧效果了。
/// 6.  下面来看看缓动公式运用了哪些吧：
///     Sine表示由三角函数实现
///     Quad是二次方，Cubic是三次方，Quart是四次方，Quint是五次方
///     Circ是开平方根(Math.sqit)，Expo是幂函数Math.pow)
///     Elastic是结合三角函数和开立方根
///     Back则引入了常数1.70158
///
///     缓动动画效果: https://easings.net/

import Foundation

internal struct Easings {
    struct Quad {
        private init() {}
    }
    struct Sine {
        private init() {}
    }
    struct Cubic {
        private init() {}
    }
    struct Quart {
        private init() {}
    }
    struct Quint {
        private init() {}
    }
    struct Circ {
        private init() {}
    }
    struct Expo {
        private init() {}
    }
    struct Elastic {
        private init() {}
    }
    struct Back {
        private init() {}
    }
    struct Bounce {
        private init() {}
    }
    struct Linear {
        private init() {}
    }
}

extension Easings.Quad {
    static var easeIn: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            let x = t / d //x值
            let y = powf(x, 2) // y值
            return c * y + b //套入最初的公式
        }
    }
    static var easeOut: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            let x = t / d //x值
            let y = -powf(x, 2) + 2 * x //y值
            return c * y + b //套入最初的公式
        }
    }
    static var easeInOut: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            var x = t / (d * 0.5)
            if x < 1 {
                return c * 0.5 * powf(x, 2) + b
            }
            x -= 1
            return -c * 0.5 * (x * (x - 2) - 1) + b
        }
    }
}

extension Easings.Sine {
    static var easeIn: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            return -c * cos(.pi * 0.5 * t / d) + c + b
        }
    }
    static var easeOut: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            return c * sin(.pi * 0.5 * t / d) + b
        }
    }
    static var easeInOut: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            return -c * 0.5 * (cos(.pi * t / d) - 1) + b
        }
    }
}

extension Easings.Cubic {
    static var easeIn: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            let x = t / d
            return c * powf(x, 3) + b
        }
    }
    static var easeOut: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            let x = t / d - 1
            return c * (powf(x, 3) + 1) + b
        }
    }
    static var easeInOut: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            var x = t / (d * 0.5)
            if x < 1 {
                return c * 0.5 * powf(x, 3) + b
            }
            x -= 2
            return c * 0.5 * (powf(x, 3) + 2) + b
        }
    }
}

extension Easings.Quart {
    static var easeIn: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            let x = t / d
            return c * powf(x, 4) + b
        }
    }
    static var easeOut: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            let x = t / d - 1
            return -c * (powf(x, 4) - 1) + b
        }
    }
    static var easeInOut: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            var x = t / (d * 0.5)
            if x < 1 {
                return c * 0.5 * powf(x, 4) + b
            }
            x -= 2
            return -c * 0.5 * (powf(x, 4) - 2) + b
        }
    }
}

extension Easings.Quint {
    static var easeIn: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            let x = t / d
            return c * powf(x, 5) + b
        }
    }
    static var easeOut: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            let x = t / d - 1
            return c * (powf(x, 5) + 1) + b
        }
    }
    static var easeInOut: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            var x = t / (d * 0.5)
            if x < 1 {
                return c * 0.5 * powf(x, 5) + b
            }
            x -= 2
            return c * 0.5 * (powf(x, 5) + 2) + b
        }
    }
}

extension Easings.Circ {
    static var easeIn: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            let x = t / d
            return -c * (sqrtf(1 - powf(x, 2)) - 1) + b
        }
    }
    static var easeOut: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            let x = t / d - 1
            return c * sqrtf(1 - powf(x, 2)) + b
        }
    }
    static var easeInOut: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            var x = t / (d * 0.5)
            if x < 1 {
                return -c * 0.5 * (sqrtf(1 - powf(x, 2)) - 1) + b
            }
            x -= 2
            return c * 0.5 * (sqrtf(1 - powf(x, 2)) + 1) + b
        }
    }
}

extension Easings.Expo {
    static var easeIn: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            return t == 0 ? b : (c * powf(2, 10 * (t / d - 1)) + b)
        }
    }
    static var easeOut: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            return t == d ? (b + c) : (c * (1 - powf(2, -10 * (t / d))) + b)
        }
    }
    static var easeInOut: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            if t == 0 { return b }
            if t == d { return b + c }
            var x = t / (d * 0.5)
            if x < 1 {
                return c * 0.5 * powf(2, 10 * (x - 1)) + b
            }
            x -= 1
            return c * 0.5 * (2 - powf(2, -10 * x)) + b
        }
    }
}

extension Easings.Elastic {
    static var easeIn: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            if t == 0 { return b }
            if t == d { return b + c }
            let x = t / d - 1
            let p = d * 0.3
            let s = p * 0.25
            let postFix = c * powf(2, 10 * x)
            return b - postFix * sinf(.pi * 2 * (x * d - s) / p)
        }
    }
    static var easeOut: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            if t == 0 { return b }
            if t == d { return b + c }
            let x = t / d
            let p = d * 0.3
            let s = p * 0.25
            return c * powf(2, -10 * x) * sinf(.pi * 2 * (x * d - s) / p) + b + c
        }
    }
    static var easeInOut: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            if t == 0 { return b }
            var x = t / (d * 0.5)
            if x == 2 { return b + c }
            let p = d * 0.45
            let s = p * 0.25
            if (x < 1) {
                x -= 1
                let fx = c * powf(2, 10 * x)
                return -0.5 * (fx * sinf(.pi * 2 * (x * d - s) / p)) + b
            }
            x -= 1
            let fx = c * powf(2, -10 * x)
            return fx * sinf(.pi * 2 * (x * d - s) / p) * 0.5 + c + b
        }
    }
}

extension Easings.Back {
    static var easeIn: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            let s: Float = 1.70158
            let x = t / d
            let sx = (s + 1) * x - s
            return c * powf(x, 2) * sx + b
        }
    }
    static var easeOut: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            let s: Float = 1.70158
            let x = t / d - 1
            let sx = (s + 1) * x + s
            return c * (pow(x, 2) * sx + 1) + b
        }
    }
    static var easeInOut: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            let s: Float = 1.70158 * 1.525;
            var x = t / (d * 0.5)
            if x < 1 {
                let sx = (s + 1) * x - s
                return c * 0.5 * (x * x * sx) + b
            }
            x -= 2
            let sx = (s + 1) * x + s
            return c * 0.5 * (x * x * sx + 2) + b
        }
    }
}

extension Easings.Bounce {
    static var easeIn: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            return c - Easings.Bounce.easeOut(d - t, 0, c, d) + b
        }
    }
    static var easeOut: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            let x = t / d
            let t0: Float = 2.75
            let x0: Float = 7.5625
            if x < (1 / t0) {
                return c * x0 * powf(x, 2) + b
            }
            if x < (2 / t0) {
                let fx = x - 1.5 / t0
                return c * (x0 * powf(fx, 2) + 0.75) + b
            }
            if x < (2.5 / t0) {
                let fx = x - 2.25 / t0
                return c * (x0 * powf(fx, 2) + 0.9375) + b
            }
            let fx = x - 2.625 / t0
            return c * (x0 * powf(fx, 2) + 0.984375) + b
        }
    }
    static var easeInOut: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            if (t < (d * 0.5)) {
                return Easings.Bounce.easeIn(t * 2, 0, c, d) * 0.5 + b
            }
            return Easings.Bounce.easeOut(t * 2 - d, 0, c, d) * 0.5 + c * 0.5 + b
        }
    }
}

extension Easings.Linear {
    static var `default`: (_ t: Float, _ b: Float, _ c: Float, _ d: Float) -> Float {
        return { t, b, c, d in
            return c * t / d + b
        }
    }
}
