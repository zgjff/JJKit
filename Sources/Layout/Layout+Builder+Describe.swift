import UIKit

extension JJLayout.Builder {
    internal class Describe {
        /// 源目标
        let source: JJLayout.ViewStyle
        /// 要设定的item集合
        private(set) var items: Set<JJLayout.Item> = []
        /// 目标
        private(set) var target: TargetStyle = .none
        /// 关系
        private(set) var releation: JJLayout.TargetRelation.Style = .equal
        
        init(source: JJLayout.ViewStyle) {
            self.source = source
        }
        
        enum TargetStyle {
            case none
            case float(LayoutCGFloatTargetable)
            case point(LayoutPointTargetable)
            case size(LayoutSizeTargetable)
            case frame(LayoutRectTargetable)
        }
        
        enum ItemsError: Error {
            case reason(String)
        }
    }
}

internal extension JJLayout.Builder.Describe {
    func append(_ item: JJLayout.Item) {
        items.insert(item)
    }
    
    func addTarget(_ target: TargetStyle) {
        guard case let .float(t) = target  else {
            self.target = target
            return
        }
        do {
            try check(with: t)
            self.target = target
        } catch JJLayout.Builder.Describe.ItemsError.reason(let err) {
            fatalError("👿👿👿👿👿\(err) 👿👿👿👿👿")
        } catch {}
    }
    
    func setNewRelation(_ releation: JJLayout.TargetRelation.Style) {
        self.releation = releation
    }
    
    /// 检查所设置的属性是否合法
    ///
    /// - Parameter target: 设置界面元素item的参照物
    ///
    /// - 因为LayoutBuilderPoint与LayoutBuilderSize的equalTo不会返回本身,所以集合items中不会存在多个item,不用去检查
    /// - 只在target为LayoutCGFloatTargetRelation类型的时候才去检查
    /// - 另外一个意思就是 只检查LayoutItem 为width/height/top/left/right/bottom/centerX/centerY
    /// - 如果target为UIView/CALayer时,则设置item为target对应的item,不需要检查是否合格
    /// - 在设置其它类型的target时,需要检查集合items中是否有冲突的设定
    ///
    /// For example:
    /// - 同时设定[.left, .ritgh, .width]为20,是非法的；同时设定[.top, .bottom, .height]为20,也是非法的...
    /// - 同时设定[.left, .ritgh, .width]为view/calayer是合法的...
    func check(with target: LayoutTargetable) throws {
        guard let t = target as? LayoutCGFloatTargetable else { return }
        if t is UIView || t is CALayer {
            return
        }
        if JJLayout.Item.lrw_Disharmony.isSubset(of: items) {
            throw ItemsError.reason("[.left, .right, .width] 不能同时设置为同一数值")
        }
        if JJLayout.Item.lcxw_Disharmony.isSubset(of: items) {
            throw ItemsError.reason("[.right, .centerX, .width] 不能同时设置为同一数值")
        }
        if JJLayout.Item.rcxw_Disharmony.isSubset(of: items) {
            throw ItemsError.reason("[.right, .centerX, .width] 不能同时设置为同一数值")
        }
        if JJLayout.Item.tbh_Disharmony.isSubset(of: items) {
            throw ItemsError.reason("[.top, .bottom, .height] 不能同时设置为同一数值")
        }
        if JJLayout.Item.tbh_Disharmony.isSubset(of: items) {
            throw ItemsError.reason("[.top, .centerY, .height] 不能同时设置为同一数值")
        }
        if JJLayout.Item.tbh_Disharmony.isSubset(of: items) {
            throw ItemsError.reason("[.bottom, .centerY, .height] 不能同时设置为同一数值")
        }
    }
}
