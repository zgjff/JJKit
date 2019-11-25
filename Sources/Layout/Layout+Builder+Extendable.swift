import Foundation

extension JJLayout.Builder {
    /// Layout.Builder的扩展
    ///
    /// 不能直接使用,可以使用它的子类LayoutBuilderPoint/LayoutBuilderSize/LayoutBuilderRect/LayoutCGFloatBuilder
    public class Extendable {
        internal let describe: JJLayout.Builder.Describe
        
        internal required init(view: JJLayout.ViewStyle, item: JJLayout.Item) {
            describe = JJLayout.Builder.Describe(source: view)
            describe.append(item)
        }
        
        internal func configTargetAndReturnRelation<T>(target: LayoutTargetable) -> T where T: JJLayout.TargetRelation  {
            let re = T.init()
            re.change = { r in
                self.describe.setNewRelation(r)
            }
            return re
        }
    }
}

extension JJLayout.Builder.Extendable {
    /// 设置view/layer的center的layoutBuilder
    public class Point: JJLayout.Builder.Extendable {
        @discardableResult
        public func equalTo(_ target: LayoutPointTargetable) -> JJLayout.TargetRelation.Point {
            describe.addTarget(.point(target))
            return configTargetAndReturnRelation(target: target)
        }
    }
}

extension JJLayout.Builder.Extendable {
    /// 设置view/layer的size的layoutBuilder
    public class Size: JJLayout.Builder.Extendable {
        @discardableResult
        public func equalTo(_ target: LayoutSizeTargetable) -> JJLayout.TargetRelation.Size {
            describe.addTarget(.size(target))
            return configTargetAndReturnRelation(target: target)
        }
    }
}

extension JJLayout.Builder.Extendable {
    /// 设置view/layer的edges的layoutBuilder
    public class Rect: JJLayout.Builder.Extendable {
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
        public func equalTo(_ target: LayoutRectTargetable) -> JJLayout.TargetRelation.Rect {
            describe.addTarget(.frame(target))
            return configTargetAndReturnRelation(target: target)
        }
    }
}

extension JJLayout.Builder.Extendable {
    /// 设置view/layer的left/top/right/bottom/centerX/centerY/width/height的layoutBuilder
    public class CGFloat: JJLayout.Builder.Extendable {
        public var width: JJLayout.Builder.Extendable.CGFloat {
            describe.append(.width)
            return self
        }
        public var height: JJLayout.Builder.Extendable.CGFloat {
            describe.append(.height)
            return self
        }
        public var top: JJLayout.Builder.Extendable.CGFloat {
            describe.append(.top)
            return self
        }
        public var left: JJLayout.Builder.Extendable.CGFloat {
            describe.append(.left)
            return self
        }
        public var right: JJLayout.Builder.Extendable.CGFloat {
            describe.append(.right)
            return self
        }
        public var bottom: JJLayout.Builder.Extendable.CGFloat {
            describe.append(.bottom)
            return self
        }
        public var centerX: JJLayout.Builder.Extendable.CGFloat {
            describe.append(.centerX)
            return self
        }
        public var centerY: JJLayout.Builder.Extendable.CGFloat {
            describe.append(.centerY)
            return self
        }
        @discardableResult
        public func equalTo(_ target: LayoutCGFloatTargetable) -> JJLayout.TargetRelation.TFloat {
            describe.addTarget(.float(target))
            return configTargetAndReturnRelation(target: target)
        }
    }
}
