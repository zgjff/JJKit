import Foundation
/// LayoutBuilder的扩展
///
/// 不能直接使用,可以使用它的子类LayoutBuilderPoint/LayoutBuilderSize/LayoutBuilderRect/LayoutCGFloatBuilder
public class LayoutBuilderExtendable {
    internal let describe: LayoutBuilderDescribe
    
    internal required init(view: LayoutViewStyle, item: LayoutItem) {
        describe = LayoutBuilderDescribe(source: view)
        describe.append(item)
    }
    
    internal func configTargetAndReturnRelation<T>(target: LayoutTargetable) -> T where T: LayoutTargetRelation  {
        let re = T.init()
        re.change = { r in
            self.describe.setNewRelation(r)
        }
        return re
    }
}

/// 设置view/layer的center的layoutBuilder
public class LayoutBuilderPoint: LayoutBuilderExtendable {
    @discardableResult
    public func equalTo(_ target: LayoutPointTargetable, file: String = #file, line: Int = #line) -> LayoutPointTargetRelation {
        describe.addTarget(.point(target), from: (file, line))
        return configTargetAndReturnRelation(target: target)
    }
}

/// 设置view/layer的size的layoutBuilder
public class LayoutBuilderSize: LayoutBuilderExtendable {
    @discardableResult
    public func equalTo(_ target: LayoutSizeTargetable, file: String = #file, line: Int = #line) -> LayoutSizeTargetRelation {
        describe.addTarget(.size(target), from: (file, line))
        return configTargetAndReturnRelation(target: target)
    }
}

/// 设置view/layer的edges的layoutBuilder
public class LayoutBuilderRect: LayoutBuilderExtendable {
    /// edges的后续链式函数----直接设置view/layer的frame等于LayoutRectTargetable(view/layer/cgrect)
    ///
    /// - Parameters:
    ///   - target: 设置frame值的目标
    ///
    ///     ⚠️注意:当要设置的界面A为: UIView/CALayer时,而目标B: (target)为UIView/CAlayer时，需要确认A与B的关系----或者说在调用此函数之前A与B的关系,影响了最终的frame
    ///
    ///     for example1:
    ///
    ///         let v1 = UIView(frame: CGRect(x: 50, y: 50, width: 300, height: 300))
    ///         let v2 = UIView()
    ///         v2.jj.layout { make in
    ///             make.edges.equalTo(v1).offsetBy(10, 10) // 运行到这里时,因为1不是v2的SupreView,所以v2此时参考的是v1的frame
    ///         }
    ///         v1.addSubview(v2)
    ///
    ///     for example2:
    ///
    ///         let v1 = UIView(frame: CGRect(x: 50, y: 50, width: 300, height: 300))
    ///         let v2 = UIView()
    ///         v1.addSubview(v2)
    ///         v2.jj.layout { make in
    ///             make.edges.equalTo(v1).offsetBy(10, 10) // 运行到这里时,因为v1是v2的SupreView,所以v2此时参考的是v1的bounds
    ///         }
    ///
    ///   - file: 调用此函数所在的的文件---方便调试
    ///   - line: 调用此函数所在的的行数---方便调试
    /// - Returns: 设置CGRect的后续方法对象
    @discardableResult
    public func equalTo(_ target: LayoutRectTargetable, file: String = #file, line: Int = #line) -> LayoutRectTargetRelation {
        describe.addTarget(.frame(target), from: (file, line))
        return configTargetAndReturnRelation(target: target)
    }
}

/// 设置view/layer的left/top/right/bottom/centerX/centerY/width/height的layoutBuilder
public class LayoutCGFloatBuilder: LayoutBuilderExtendable {
    public var width: LayoutCGFloatBuilder {
        describe.append(.width)
        return self
    }
    public var height: LayoutCGFloatBuilder {
        describe.append(.height)
        return self
    }
    public var top: LayoutCGFloatBuilder {
        describe.append(.top)
        return self
    }
    public var left: LayoutCGFloatBuilder {
        describe.append(.left)
        return self
    }
    public var right: LayoutCGFloatBuilder {
        describe.append(.right)
        return self
    }
    public var bottom: LayoutCGFloatBuilder {
        describe.append(.bottom)
        return self
    }
    public var centerX: LayoutCGFloatBuilder {
        describe.append(.centerX)
        return self
    }
    public var centerY: LayoutCGFloatBuilder {
        describe.append(.centerY)
        return self
    }
    
    @discardableResult
    public func equalTo(_ target: LayoutCGFloatTargetable, file: String = #file, line: Int = #line) -> LayoutCGFloatTargetRelation {
        describe.addTarget(.float(target), from: (file, line))
        return configTargetAndReturnRelation(target: target)
    }
}
