import CoreGraphics

/// 布局元素的结果
///
/// 与CGRext的构造函数元素相似
/// - x: 枚举类型: 未设置/value
/// - y: 枚举类型: 未设置/value
/// - width: 枚举类型: 未设置/value
/// - height: 枚举类型: 未设置/value
internal struct LayoutResult {
    private var x = Result.none
    private var y = Result.none
    private var width = Result.none
    private var height = Result.none
}

extension LayoutResult {
    enum Result {
        case none
        case value(CGFloat)
    }
}

internal extension LayoutResult {
    /// 设置frame的x值
    mutating func setX(_ value: CGFloat) {
        x = .value(value)
    }
    /// 设置frame的y值
    mutating func setY(_ value: CGFloat) {
        y = .value(value)
    }
    /// 设置frame的width值
    mutating func setWidth(_ value: CGFloat) {
        width = .value(value)
    }
    /// 设置frame的height值
    mutating func setHeight(_ value: CGFloat) {
        height = .value(value)
    }
    /// 计算界面元素的最终frame
    ///
    /// - Parameter view: 要布局的界面元素(view/calyer)
    func calculateFrame(for view: LayoutViewStyle) {
        var fx, fy, fw, fh: CGFloat
        switch view {
        case .view(let v):
            switch x {
            case .none: fx = v.jj.left
            case .value(let val): fx = val
            }
            switch y {
            case .none: fy = v.jj.top
            case .value(let val): fy = val
            }
            switch width {
            case .none: fw = v.jj.width
            case .value(let val): fw = val
            }
            switch height {
            case .none: fh = v.jj.height
            case .value(let val): fh = val
            }
            v.frame = CGRect(x: fx, y: fy, width: fw, height: fh)
        case .layer(let l):
            switch x {
            case .none: fx = l.jj.left
            case .value(let val): fx = val
            }
            switch y {
            case .none: fy = l.jj.top
            case .value(let val): fy = val
            }
            switch width {
            case .none: fw = l.jj.width
            case .value(let val): fw = val
            }
            switch height {
            case .none: fh = l.jj.height
            case .value(let val): fh = val
            }
            l.frame = CGRect(x: fx, y: fy, width: fw, height: fh)
        }
    }
}
