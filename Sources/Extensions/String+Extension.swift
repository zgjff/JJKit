//
//  String+Extension.swift
//  JJKit
//
//  Created by zgjff on 2022/9/30.
//

import UIKit

extension String: JJCompatible {}

extension JJBox where Base == String {
    /// DSL方式创建富文本
    /// - Parameter make: 创建方式
    /// - Returns: 格式化后的富文本
    public func attributeMake(_ make: (_ make: JJAttributMaker) -> ()) -> NSAttributedString {
        let maker = JJAttributMaker(string: base)
        make(maker)
        return maker.build()
    }
}

/// 富文本助手
public final class JJAttributMaker {
    private let string: String
    internal init(string: String) {
        self.string = string
    }
    fileprivate var dic: [NSRange: JJAttributMakerExtendable] = [:]
}

extension JJAttributMaker {
    /// 创建描述范围内的富文本的DSL
    /// - Parameter ranges: 要设置的范围列表
    /// - Returns: 描述富文本的DSL
    public func `for`(_ ranges: Rangeable...) -> JJAttributMakerExtendable? {
        let rs = ranges.map { $0.rangeFrom(parent: string) }.filter { !$0.isEmpty }
        if rs.isEmpty {
            return nil
        }
        let e = JJAttributMakerExtendable(sort: dic.count)
        rs.forEach { $0.filter { $0.length > 0 }.forEach { dic.updateValue(e, forKey: $0) } }
        return e
    }
    
    public func all() -> JJAttributMakerExtendable? {
        return self.for(string)
    }
    
    internal func build() -> NSAttributedString {
        if (string.isEmpty || string.count == 0) {
            return NSAttributedString(string: "")
        }
        let att = NSMutableAttributedString(string: string)
        dic.sorted(by: { $0.value.sort < $1.value.sort })
            .forEach { att.setAttributes($0.value.attrs, range: $0.key) }
        return att
    }
}

public final class JJAttributMakerExtendable {
    fileprivate let sort: Int
    init(sort: Int) {
        self.sort = sort
    }
    private var styles: Set<Attribute> = []
    
    fileprivate var attrs: [NSAttributedString.Key: Any] {
        let initial: [NSAttributedString.Key: Any] = [:]
        return styles.reduce(initial, { (result, style) in
            var temp = result
            temp.updateValue(style.value, forKey: style.key)
            return temp
        })
    }
    
    private func setNewAttribute(_ attribute: Attribute) -> Self {
        if styles.contains(attribute) {
            styles.update(with: attribute)
        } else {
            styles.insert(attribute)
        }
        return self
    }
}

extension JJAttributMakerExtendable {
    /// 设置字体
    ///
    /// - Parameter font: 字体
    /// - Returns: JJAttributMakerExtendable
    @discardableResult
    public func font(_ font: UIFont) -> Self {
        return setNewAttribute(Attribute(key: .font, value: font))
    }
    
    /// 字体颜色
    ///
    /// - Parameter color: 颜色
    /// - Returns: JJAttributMakerExtendable
    @discardableResult
    public func foregroundColor(_ color: UIColor) -> Self {
        return setNewAttribute(Attribute(key: .foregroundColor, value: color))
    }
    
    /// 背景色
    ///
    /// - Parameter color: 颜色
    /// - Returns: JJAttributMakerExtendable
    @discardableResult
    public func backgroundColor(_ color: UIColor) -> Self {
        return setNewAttribute(Attribute(key: .backgroundColor, value: color))
    }
    
    /// 字符间距
    ///
    /// - Parameter space: 正值间距加宽,负值间距变窄,0表示默认效果
    /// - Returns: JJAttributMakerExtendable
    @discardableResult
    public func kern(_ space: Double) -> Self {
        return setNewAttribute(Attribute(key: .kern, value: space))
    }
    
    /// 设置段落格式
    ///
    /// - Parameter style: 段落格式
    /// - Returns: JJAttributMakerExtendable
    @discardableResult
    public func paragraphStyle(_ style: NSParagraphStyle) -> Self {
        return setNewAttribute(Attribute(key: .paragraphStyle, value: style))
    }
    
    /// 设置超链接
    ///
    /// - Parameter url: 超链接地址
    /// - Returns: JJAttributMakerExtendable
    @discardableResult
    public func link(_ url: URL) -> Self {
        return setNewAttribute(Attribute(key: .link, value: url))
    }
    
    /// 设置下划线
    ///
    /// - Parameter style: 下划线类型
    /// - Returns: JJAttributMakerExtendable
    @discardableResult
    public func underlineStyle(_ style: NSUnderlineStyle) -> Self {
        return setNewAttribute(Attribute(key: .underlineStyle, value: style.rawValue))
    }
    
    /// 设置删除线
    ///
    /// - Parameter color: 删除线类型
    /// - Returns: JJAttributMakerExtendable
    @discardableResult
    public func strikethroughStyle(_ style: NSUnderlineStyle) -> Self {
        return setNewAttribute(Attribute(key: .strikethroughStyle, value: style.rawValue))
    }
    
    /// 设置删除线颜色
    ///
    /// - Parameter color: 颜色
    /// - Returns: JJAttributMakerExtendable
    @discardableResult
    public func strikethroughColor(_ color: UIColor) -> Self {
        return setNewAttribute(Attribute(key: .strikethroughColor, value: color))
    }
    
    /// 设置描边颜色
    ///
    /// - Parameter color: 颜色---需要跟strokeWidth(描边宽度搭配使用才有效)
    /// - Returns: JJAttributMakerExtendable
    @discardableResult
    public func strokeColor(_ color: UIColor) -> Self {
        return setNewAttribute(Attribute(key: .strokeColor, value: color))
    }
    
    /// 设置描边宽度
    ///
    /// - Parameter width: 宽度--只有在宽度大于0的时候才有空心效果(因为正树不对文字内部进行填充),当无描边颜色时，描边颜色默认成字体本来的颜色
    /// - Returns: JJAttributMakerExtendable
    @discardableResult
    public func strokeWidth(_ width: Double) -> Self {
        return setNewAttribute(Attribute(key: .strokeWidth, value: width))
    }
    
    /// 文本阴影
    ///
    /// - Parameter shadow: 阴影
    /// - Returns: JJAttributMakerExtendable
    @discardableResult
    public func shadow(_ shadow: NSShadow) -> Self {
        return setNewAttribute(Attribute(key: .shadow, value: shadow))
    }
    
    /// 设置基础偏移量
    ///
    /// - Parameter offset: 偏移值: 正值向上偏移,负值向下偏移,默认0(不偏移)
    /// - Returns: JJAttributMakerExtendable
    @discardableResult
    public func baselineOffset(_ offset: Double) -> Self {
        return setNewAttribute(Attribute(key: .baselineOffset, value: offset))
    }
    
    /// 设置字体倾斜
    ///
    /// - Parameter offset: 倾斜值: 正值向右倾斜,负值向左倾斜
    /// - Returns: JJAttributMakerExtendable
    @discardableResult
    public func obliqueness(_ oblique: Double) -> Self {
        return setNewAttribute(Attribute(key: .obliqueness, value: oblique))
    }
    
    /// 设置文本扁平化(横向拉伸)
    ///
    /// - Parameter oblique: 正值横向拉伸,负值横向压缩,默认0(无扁平效果)
    /// - Returns: JJAttributMakerExtendable
    @discardableResult
    public func expansion(_ oblique: Double) -> Self {
        return setNewAttribute(Attribute(key: .expansion, value: oblique))
    }
}

struct Attribute: Hashable, Equatable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(key.hashValue)
    }
    
    private(set) var key: NSAttributedString.Key
    private(set) var value: Any
    init(key: NSAttributedString.Key, value: Any) {
        self.key = key
        self.value = value
    }
    
    static func == (lhs: Attribute, rhs: Attribute) -> Bool {
        return lhs.key == rhs.key
    }
}

/// 获取在给定字符串中的range(NSRange)
public protocol Rangeable {
    func rangeFrom(parent: String) -> Set<NSRange>
}

extension String: Rangeable {
    public func rangeFrom(parent: String) -> Set<NSRange> {
        guard !isEmpty && count > 0 else {
            return []
        }
        guard !parent.isEmpty && parent.count > 0 else {
            return []
        }
        guard let regex = try? NSRegularExpression(pattern: self, options: .caseInsensitive) else {
            return []
        }
        let cs = regex.matches(in: parent, options: [], range: NSRange(location: 0, length: parent.count))
        let initi: Set<NSRange> = []
        return cs.reduce(initi) { (re, result) in
            var temp = re
            temp.insert(result.range)
            return temp
        }
    }
}

extension Int: Rangeable {
    public func rangeFrom(parent: String) -> Set<NSRange> {
        guard !parent.isEmpty && parent.count > 0 else {
            return []
        }
        guard self < parent.count, self >= 0 else {
            return []
        }
        return [NSMakeRange(self, 1)]
    }
}

extension NSRange: Rangeable {
    public func rangeFrom(parent: String) -> Set<NSRange> {
        guard !parent.isEmpty && parent.count > 0 else {
            return []
        }
        let low = lowerBound
        let up = upperBound
        let count = parent.count
        guard low <= (count - 1) && up > 0 else {
            return []
        }
        if up > count - 1 {
            return [NSMakeRange(low, count - low)]
        }
        return [self]
    }
}

extension CountableRange: Rangeable where Element == Int {
    public func rangeFrom(parent: String) -> Set<NSRange> {
        guard !parent.isEmpty && parent.count > 0 else {
            return []
        }
        let low = lowerBound >= 0 ? lowerBound : 0
        let up = upperBound
        let count = parent.count
        guard low <= count && up > 0 else {
            return [NSMakeRange(0, 0)]
        }
        if up > count {
            return [NSMakeRange(low, count - low)]
        }
        return [NSMakeRange(low, self.count)]
    }
}

extension CountableClosedRange: Rangeable where Element == Int {
    public func rangeFrom(parent: String) -> Set<NSRange> {
        guard !parent.isEmpty && parent.count > 0 else {
            return []
        }
        let low = lowerBound >= 0 ? lowerBound : 0
        let up = upperBound
        let count = parent.count
        guard low <= count && up > 0 else {
            return [NSMakeRange(0, 0)]
        }
        if up > count {
            return [NSMakeRange(low, count - low)]
        }
        return [NSMakeRange(low, self.count)]
    }
}

/// 根据正则查找字符串中符合正则的范围Rnage
public struct JJAttributedRegexp {
    private let regular: NSRegularExpression
    private let matching: NSRegularExpression.MatchingOptions
    private let stopCondition: ((Set<NSRange>, NSTextCheckingResult) -> Bool)?
    public init?(pattern: String, options: NSRegularExpression.Options = [], matching: NSRegularExpression.MatchingOptions = .reportCompletion, stopCondition: ((Set<NSRange>, NSTextCheckingResult) -> Bool)? = nil) {
        guard let regular = try? NSRegularExpression(pattern: pattern, options: options) else { return nil }
        self.matching = matching
        self.regular = regular
        self.stopCondition = stopCondition
    }
}

extension JJAttributedRegexp: Rangeable {
    public func rangeFrom(parent: String) -> Set<NSRange> {
        var result: Set<NSRange> = []
        regular.enumerateMatches(in: parent, options: matching, range: NSRange(location: 0, length: parent.count)) { (match, _, stopPointer) in
            guard let match = match else { return }
            result.insert(match.range)
            if let sc = stopCondition {
                stopPointer.pointee = ObjCBool(sc(result, match))
            }
        }
        return result
    }
}
