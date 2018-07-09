//
//  AttributMaker.swift
//  Demo
//
//  Created by 123 on 2018/7/9.
//  Copyright © 2018年 郑桂杰. All rights reserved.
//

import UIKit


public final class AttributMaker {
    private var dic: [NSRange: AttributMakerExtendable] = [:]
    
    private let string: String
    public init(string: String) {
        self.string = string
    }
    
    public func `for`(_ ranges: Rangeable...) -> AttributMakerExtendable {
        let rs = ranges.map { $0.rangeFrom(parent: string) }
        let e = AttributMakerExtendable()
        rs.forEach { dic.updateValue(e, forKey: $0) }
        return e
    }
    
    public func build() -> NSAttributedString {
        let att = NSMutableAttributedString(string: string)
        for (_, e) in dic.enumerated() {
            if e.key.length > 0 {
                att.addAttributes(e.value.attrs, range: e.key)
            }
        }
        return att
    }
}

public final class AttributMakerExtendable {
    fileprivate var attrs: [NSAttributedStringKey: Any] {
        let initial: [NSAttributedStringKey: Any] = [:]
        return styles.reduce(initial) { result, style in
            var temp = result
            temp.updateValue(style.value, forKey: style.key)
            return temp
        }
    }
    
    private var styles: Set<Attribute> = []
    
    private func setNewAttribute(_ attribute: Attribute) -> Self {
        if styles.contains(attribute) {
            styles.update(with: attribute)
        } else {
            styles.insert(attribute)
        }
        return self
    }
}

extension AttributMakerExtendable {
    
    /// 设置字体
    ///
    /// - Parameter font: 字体
    /// - Returns: AttributMakerExtendable
    @discardableResult
    public func font(_ font: UIFont) -> Self {
        return setNewAttribute(Attribute(key: .font, value: font))
    }
    
    /// 字体颜色
    ///
    /// - Parameter color: 颜色
    /// - Returns: AttributMakerExtendable
    @discardableResult
    public func foregroundColor(_ color: UIColor) -> Self {
        return setNewAttribute(Attribute(key: .foregroundColor, value: color))
    }
    
    /// 背景色
    ///
    /// - Parameter color: 颜色
    /// - Returns: AttributMakerExtendable
    @discardableResult
    public func backgroundColor(_ color: UIColor) -> Self {
        return setNewAttribute(Attribute(key: .backgroundColor, value: color))
    }
    
    /// 字符间距
    ///
    /// - Parameter space: 正值间距加宽,负值间距变窄,0表示默认效果
    /// - Returns: AttributMakerExtendable
    @discardableResult
    public func kern(_ space: Double) -> Self {
        return setNewAttribute(Attribute(key: .kern, value: space))
    }
    
    /// 设置段落格式
    ///
    /// - Parameter style: 段落格式
    /// - Returns: AttributMakerExtendable
    @discardableResult
    public func paragraphStyle(_ style: NSParagraphStyle) -> Self {
        return setNewAttribute(Attribute(key: .paragraphStyle, value: style))
    }
    
    /// 设置超链接
    ///
    /// - Parameter url: 超链接地址
    /// - Returns: AttributMakerExtendable
    @discardableResult
    public func link(_ url: URL) -> Self {
        return setNewAttribute(Attribute(key: .link, value: url))
    }
    
    /// 设置下划线
    ///
    /// - Parameter style: 下划线类型
    /// - Returns: AttributMakerExtendable
    @discardableResult
    public func underlineStyle(_ style: NSUnderlineStyle) -> Self {
        return setNewAttribute(Attribute(key: .underlineStyle, value: style.rawValue))
    }
    
    /// 设置删除线
    ///
    /// - Parameter color: 删除线类型
    /// - Returns: AttributMakerExtendable
    @discardableResult
    public func strikethroughStyle(_ style: NSUnderlineStyle) -> Self {
        return setNewAttribute(Attribute(key: .strikethroughStyle, value: style.rawValue))
    }
    
    /// 设置删除线颜色
    ///
    /// - Parameter color: 颜色
    /// - Returns: AttributMakerExtendable
    @discardableResult
    public func strikethroughColor(_ color: UIColor) -> Self {
        return setNewAttribute(Attribute(key: .strikethroughColor, value: color))
    }
    
    /// 设置描边颜色
    ///
    /// - Parameter color: 颜色---需要跟strokeWidth(描边宽度搭配使用才有效)
    /// - Returns: AttributMakerExtendable
    @discardableResult
    public func strokeColor(_ color: UIColor) -> Self {
        return setNewAttribute(Attribute(key: .strokeColor, value: color))
    }
    
    /// 设置描边宽度
    ///
    /// - Parameter width: 宽度--只有在宽度大于0的时候才有空心效果(因为正树不对文字内部进行填充),当无描边颜色时，描边颜色默认成字体本来的颜色
    /// - Returns: AttributMakerExtendable
    @discardableResult
    public func strokeWidth(_ width: Double) -> Self {
        return setNewAttribute(Attribute(key: .strokeWidth, value: width))
    }
    
    /// 文本阴影
    ///
    /// - Parameter shadow: 阴影
    /// - Returns: AttributMakerExtendable
    @discardableResult
    public func shadow(_ shadow: NSShadow) -> Self {
        return setNewAttribute(Attribute(key: .shadow, value: shadow))
    }
    
    
    /// 设置基础偏移量
    ///
    /// - Parameter offset: 偏移值: 正值向上偏移,负值向下偏移,默认0(不偏移)
    /// - Returns: AttributMakerExtendable
    @discardableResult
    public func baselineOffset(_ offset: Double) -> Self {
        return setNewAttribute(Attribute(key: .baselineOffset, value: offset))
    }
    
    /// 设置字体倾斜
    ///
    /// - Parameter offset: 倾斜值: 正值向右倾斜,负值向左倾斜
    /// - Returns: AttributMakerExtendable
    @discardableResult
    public func obliqueness(_ oblique: Double) -> Self {
        return setNewAttribute(Attribute(key: .obliqueness, value: oblique))
    }
    
    
    /// 设置文本扁平化(横向拉伸)
    ///
    /// - Parameter oblique: 正值横向拉伸,负值横向压缩,默认0(无扁平效果)
    /// - Returns: AttributMakerExtendable
    @discardableResult
    public func expansion(_ oblique: Double) -> Self {
        return setNewAttribute(Attribute(key: .expansion, value: oblique))
    }
}

fileprivate struct Attribute: Hashable, Equatable {
    var hashValue: Int {
        return key.hashValue
    }
    
    static func == (lhs: Attribute, rhs: Attribute) -> Bool {
        return lhs.key == rhs.key
    }
    
    private(set) var key: NSAttributedStringKey
    private(set) var value: Any
    init(key: NSAttributedStringKey, value: Any) {
        self.key = key
        self.value = value
    }
}


public protocol Rangeable {
    func rangeFrom(parent: String) -> NSRange
}

extension String: Rangeable {
    public func rangeFrom(parent: String) -> NSRange {
        return (parent as NSString).range(of: self)
    }
}

extension Int: Rangeable {
    public func rangeFrom(parent: String) -> NSRange {
        guard self - 1 < parent.count, self >= 0 else {
            return NSMakeRange(0, 0)
        }
        return NSMakeRange(self - 1, 1)
    }
}

extension NSRange: Rangeable {
    public func rangeFrom(parent: String) -> NSRange {
        let low = lowerBound
        let up = upperBound
        let count = parent.count
        guard low <= (count - 1) && up > 0 else {
            return NSMakeRange(0, 0)
        }
        if up > count - 1 {
            return NSMakeRange(low, count - low)
        }
        return self
    }
}

extension CountableRange: Rangeable where Element == Int {
    public func rangeFrom(parent: String) -> NSRange {
        let low = lowerBound - 1
        let up = upperBound
        let count = parent.count
        guard low <= (count - 1) && up > 0 else {
            return NSMakeRange(0, 0)
        }
        if up > count {
            return NSMakeRange(low, count - low)
        }
        return NSMakeRange(low, self.count)
    }
}

extension CountableClosedRange: Rangeable where Element == Int {
    public func rangeFrom(parent: String) -> NSRange {
        let low = lowerBound - 1
        let up = upperBound
        let count = parent.count
        guard low <= (count - 1) && up > 0 else {
            return NSMakeRange(0, 0)
        }
        if up > count {
            return NSMakeRange(low, count - low)
        }
        return NSMakeRange(low, self.count)
    }
}
