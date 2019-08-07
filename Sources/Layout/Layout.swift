import UIKit

extension JJ where Object: UIView {
    /// 为UIView设置frame
    ///
    /// - Parameters:
    ///   - file: 调用此函数所在的的文件---方便调试
    ///   - line: 调用此函数所在的的行数---方便调试
    ///   - build: 设置frame的闭包,可以在此闭包内设置view的left/top/right/bottom/centerX/centerY/center/size
    ///
    /// - 设置view同种类型的item时,可以链式调用.
    /// - 设置CGFloat的top/left/right/bottom/centerX/centerY是同一类型
    /// - 设置CGPoint的center类型
    /// - 设置CGSize的size类型
    ///
    /// 例如
    ///
    ///     v.jj.layout { make in
    ///         make.left.top.equalTo(100)
    ///         make.right.equalTo(view).offsetBy(-50)
    ///         make.height.equalTo(view).multipliedBy(0.5)
    ///     }
    ///
    public func layout(file: String = #file, line: Int = #line, build: (LayoutBuilder) -> ()) {
        let builder = LayoutBuilder(style: .view(object))
        build(builder)
        builder.build(from: (file, line))
    }
}

extension JJ where Object: CALayer {
    /// 为CALayer设置frame
    ///
    /// - Parameters:
    ///   - file: 调用此函数所在的的文件---方便调试
    ///   - line: 调用此函数所在的的行数---方便调试
    ///   - build: 设置frame的闭包,可以在此闭包内设置view的left/top/right/bottom/centerX/centerY/center/size
    ///
    /// - 设置layer同种类型的item时,可以链式调用.
    /// - 设置CGFloat的top/left/right/bottom/centerX/centerY是同一类型
    /// - 设置CGPoint的center类型
    /// - 设置CGSize的size类型
    ///
    /// 例如
    ///
    ///     l.jj.layout { make in
    ///         make.left.top.equalTo(100)
    ///         make.right.equalTo(view).offsetBy(-50)
    ///         make.height.equalTo(view).multipliedBy(0.5)
    ///     }
    ///
    public func layout(file: String = #file, line: Int = #line, build: (LayoutBuilder) -> ()) {
        let builder = LayoutBuilder(style: .layer(object))
        build(builder)
        builder.build(from: (file, line))
    }
}


/// 布局元素的类型
///
/// - view: UIView及其子类
/// - layer: CALayer及其子类
internal enum LayoutViewStyle {
    case view(UIView)
    case layer(CALayer)
    
    var size: CGSize {
        switch self {
        case .view(let v): return v.jj.size
        case .layer(let l): return l.jj.size
        }
    }
}
