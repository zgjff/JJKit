import Foundation

/// 布局元素具体方面的描述类型
///
/// 具体的类型包括:
/// - 设置view CGFloat方面的: width/height/left/right/top/bottom/centerX/centerY
/// - 设置view CGPoint方面的: center
/// - 设置view CGSize 方面的: size
public struct LayoutItem: OptionSet, Hashable {
    public let rawValue: UInt
    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
}

public extension LayoutItem {
    /*********************CGFloat单位方面*******************/
    static var width     = LayoutItem(rawValue: 1 << 0)
    static var height    = LayoutItem(rawValue: 1 << 1)
    static var left      = LayoutItem(rawValue: 1 << 2)
    static var right     = LayoutItem(rawValue: 1 << 3)
    static var top       = LayoutItem(rawValue: 1 << 4)
    static var bottom    = LayoutItem(rawValue: 1 << 5)
    static var centerX   = LayoutItem(rawValue: 1 << 6)
    static var centerY   = LayoutItem(rawValue: 1 << 7)
    /*********************CGFloat单位方面*******************/
    
    /*********************CGPoint单位方面*******************/
    static var center    = LayoutItem(rawValue: 1 << 8)
    /*********************CGPoint单位方面*******************/
    
    /*********************CGSize单位方面*******************/
    static var size      = LayoutItem(rawValue: 1 << 9)
    /*********************CGSize单位方面*******************/
    
    /*********************CGRect单位方面*******************/
    static var frame     = LayoutItem(rawValue: 1 << 10)
    /*********************CGRect单位方面*******************/
}


// MARK: - 在某些情况下为不和谐的组合
internal extension LayoutItem {
    static var lrw_Disharmony: Set<LayoutItem> = [.left, .right, .width]
    static var lcxw_Disharmony: Set<LayoutItem> = [.left, .centerX, .width]
    static var rcxw_Disharmony: Set<LayoutItem> = [.right, .centerX, .width]
    
    static var tbh_Disharmony: Set<LayoutItem> = [.top, .bottom, .height]
    static var tcyh_Disharmony: Set<LayoutItem> = [.top, .centerY, .height]
    static var bcyh_Disharmony: Set<LayoutItem> = [.bottom, .centerY, .height]
}
