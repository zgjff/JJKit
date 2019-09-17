import Foundation

extension JJLayout {
    /// 布局元素具体方面的描述类型
    ///
    /// 具体的类型包括:
    /// - 设置view CGFloat方面的: width/height/left/right/top/bottom/centerX/centerY
    /// - 设置view CGPoint方面的: center
    /// - 设置view CGSize 方面的: size
    public struct Item: OptionSet, Hashable {
        public let rawValue: UInt
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
    }
}

public extension JJLayout.Item {
    /*********************CGFloat单位方面*******************/
    static var width     = JJLayout.Item(rawValue: 1 << 0)
    static var height    = JJLayout.Item(rawValue: 1 << 1)
    static var left      = JJLayout.Item(rawValue: 1 << 2)
    static var right     = JJLayout.Item(rawValue: 1 << 3)
    static var top       = JJLayout.Item(rawValue: 1 << 4)
    static var bottom    = JJLayout.Item(rawValue: 1 << 5)
    static var centerX   = JJLayout.Item(rawValue: 1 << 6)
    static var centerY   = JJLayout.Item(rawValue: 1 << 7)
    /*********************CGFloat单位方面*******************/
    
    /*********************CGPoint单位方面*******************/
    static var center    = JJLayout.Item(rawValue: 1 << 8)
    /*********************CGPoint单位方面*******************/
    
    /*********************CGSize单位方面*******************/
    static var size      = JJLayout.Item(rawValue: 1 << 9)
    /*********************CGSize单位方面*******************/
    
    /*********************CGRect单位方面*******************/
    static var frame     = JJLayout.Item(rawValue: 1 << 10)
    /*********************CGRect单位方面*******************/
}

// MARK: - 在某些情况下为不和谐的组合
internal extension JJLayout.Item {
    static var lrw_Disharmony: Set<JJLayout.Item> = [.left, .right, .width]
    static var lcxw_Disharmony: Set<JJLayout.Item> = [.left, .centerX, .width]
    static var rcxw_Disharmony: Set<JJLayout.Item> = [.right, .centerX, .width]
    
    static var tbh_Disharmony: Set<JJLayout.Item> = [.top, .bottom, .height]
    static var tcyh_Disharmony: Set<JJLayout.Item> = [.top, .centerY, .height]
    static var bcyh_Disharmony: Set<JJLayout.Item> = [.bottom, .centerY, .height]
}
