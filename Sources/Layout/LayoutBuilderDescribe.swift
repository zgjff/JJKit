import UIKit

/// 设置view/layer的目标类型
internal class LayoutBuilderDescribe {
    /// 源目标
    let source: LayoutViewStyle
    /// 要设定的item集合
    private(set) var items: Set<LayoutItem> = []
    /// 目标
    private(set) var target: TargetStyle = .none
    /// 关系
    private(set) var releation: LayoutTargetRelation.Style = .equal
    
    init(source: LayoutViewStyle) {
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

internal extension LayoutBuilderDescribe {
    func append(_ item: LayoutItem) {
        items.insert(item)
    }
    
    func addTarget(_ target: TargetStyle, from callFrom: (String, Int)) {
        guard case let .float(t) = target  else {
            self.target = target
            return
        }
        do {
            try check(with: t)
            self.target = target
        } catch LayoutBuilderDescribe.ItemsError.reason(let err) {
            let filestr = callFrom.0.split(separator: "/").last ?? ""
            fatalError("👿👿👿👿👿\(filestr):\(callFrom.1)👿👿👿👿👿 \(err) 👿👿👿👿👿")
        } catch {}
    }
    
    func setNewRelation(_ releation: LayoutTargetRelation.Style) {
        self.releation = releation
    }
}

internal extension LayoutBuilderDescribe {
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
        if LayoutItem.lrw_Disharmony.isSubset(of: items) {
            throw ItemsError.reason("[.left, .right, .width] 不能同时设置为同一数值")
        }
        if LayoutItem.lcxw_Disharmony.isSubset(of: items) {
            throw ItemsError.reason("[.right, .centerX, .width] 不能同时设置为同一数值")
        }
        if LayoutItem.rcxw_Disharmony.isSubset(of: items) {
            throw ItemsError.reason("[.right, .centerX, .width] 不能同时设置为同一数值")
        }
        if LayoutItem.tbh_Disharmony.isSubset(of: items) {
            throw ItemsError.reason("[.top, .bottom, .height] 不能同时设置为同一数值")
        }
        if LayoutItem.tbh_Disharmony.isSubset(of: items) {
            throw ItemsError.reason("[.top, .centerY, .height] 不能同时设置为同一数值")
        }
        if LayoutItem.tbh_Disharmony.isSubset(of: items) {
            throw ItemsError.reason("[.bottom, .centerY, .height] 不能同时设置为同一数值")
        }
    }
}
