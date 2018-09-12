// IconData unicode 协议
// 使用方法：
// string:
//  let font = UIFont(custom: Material.self, size: 24)
//  label.font = font
//  label.text = MaterialIcons.ac_unit.string()
//
// NSAttributedString:
// let att = MaterialIcons.adjust.attributeStringWith { maker in
//    maker.tintColor(.cyan).backgroundColor(.orange)
// }
// label.attributedText = att
//
// image:
// let close = MaterialIcons.close.imageWith { maker in
//    maker.tintColor(.cyan)
//  }
// navigationItem.rightBarButtonItem = UIBarButtonItem(image: close, style: .done,  block: { [unowned self] _ in
//     self.dis()
// })

import UIKit
public protocol IconData: CustomStringConvertible {
    associatedtype Font: Fontloadable
    var codePoint: UInt16 { get }
    init(codePoint: UInt16)
}

extension IconData {
    public var description: String {
        let m = Mirror(reflecting: self).subjectType
        let radix16 = String(codePoint, radix: 16, uppercase: true)
        return "\(m)" + " U+{0x" + radix16 + "}"
    }
    /// IconData转换为字符串
    ///
    /// - Returns: 字符串IconData
    public func string() -> String? {
        guard let scalar = Unicode.Scalar.init(codePoint) else {
            return nil
        }
        return String(scalar)
    }
    /// IconData转换为UIImage
    ///
    /// - Parameters:
    ///   - size: Icon的大小,默认CGSize(width: 30, height: 30)
    ///   - transform: block为icon增加各种样式
    /// - Returns: UIImage
    public func imageWith(size: CGSize = CGSize(width: 30, height: 30), transform: ((IconDataMaker<Self>) -> ())?) -> UIImage? {
        guard let maker = IconDataMaker(icon: self, size: size) else { return nil }
        transform?(maker)
        return maker.image()
    }
    /// IconData转换为NSAttributedString
    ///
    /// - Parameters:
    ///   - size: Icon的大小,默认24
    ///   - transform: block为icon增加各种样式
    /// - Returns: NSAttributedString
    public func attributeStringWith(size: CGFloat = 24, transform: ((IconDataMaker<Self>) -> ())?) -> NSAttributedString? {
        guard let maker = IconDataMaker(icon: self, size: size) else { return nil }
        transform?(maker)
        return maker.attributeString()
    }
}

/// 为IconData增加各种样式,最后组合成image/attributeString,默认提供了tintColor/backgroundColor,
/// 您也可以增加extension,来扩展样式,比如超链接/描边等等
public final class IconDataMaker<Icon: IconData> {
    private let icon: Icon
    private let size: IconSizeable
    private var attributes: [NSAttributedStringKey: Any]
    init?(icon: Icon, size: IconSizeable) {
        guard let font = UIFont(custom: Icon.Font.self, size: size.fontSize()) else {
            return nil
        }
        print(size.fontSize())
        self.icon = icon
        self.size = size
        attributes = [.font: font]
    }
    
    /// 为IconData增加tintColor
    ///
    /// - Parameter color: tintColor
    /// - Returns: IconDataMaker,方便链式调用
    @discardableResult
    public func tintColor(_ color: UIColor = .black) -> Self {
        attributes.updateValue(color, forKey: .foregroundColor)
        return self
    }
    
    /// 为IconData增加backgroundColor
    ///
    /// - Parameter color: backgroundColor
    /// - Returns: IconDataMaker,方便链式调用
    @discardableResult
    public func backgroundColor(_ color: UIColor = .clear) -> Self {
        attributes.updateValue(color, forKey: .backgroundColor)
        return self
    }
    fileprivate func image() -> UIImage? {
        guard let string = icon.string() else { return nil }
        let par = NSMutableParagraphStyle()
        par.alignment = .center
        attributes.updateValue(par, forKey: .paragraphStyle)
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        let s = size.imageSize()
        return UIImage(size: s) { context in
            attributedString.draw(in: CGRect(origin: .zero, size: s))
            }?.withRenderingMode(.alwaysOriginal)
    }
    
    fileprivate func attributeString() -> NSAttributedString? {
        guard let string = icon.string() else { return nil }
        return NSAttributedString(string: string, attributes: attributes)
    }
}
/// IconData的大小,CGSize/CGFloat已经实现了此协议
public protocol IconSizeable {
    func fontSize() -> CGFloat
    func imageSize() -> CGSize
}

extension CGSize: IconSizeable {
    public func fontSize() -> CGFloat {
        var newSize = self
        newSize.width = (width >= 3) ? width : 3
        newSize.height = (height >= 3) ? height : 3
        return min(newSize.width, newSize.height)
    }
    public func imageSize() -> CGSize {
        var newSize = self
        newSize.width = (width >= 3) ? width : 3
        newSize.height = (height >= 3) ? height : 3
        return newSize
    }
}

extension CGFloat: IconSizeable {
    public func fontSize() -> CGFloat {
        return self > 3 ? self : 3
    }
    public func imageSize() -> CGSize {
        let wh = self > 3 ? self : 3
        return CGSize(width: wh, height: wh)
    }
}

/// Unicode 的协议
public protocol Fontloadable {
    static var url: URL { get }
    static var familyName: String { get }
}

extension Fontloadable {
    public static func hasRegister() -> Bool {
        return UIFont.familyNames.contains(familyName)
    }
    @discardableResult
    public static func register() -> Bool {
        guard !hasRegister() else { return true }
        return CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
    @discardableResult
    public static func unregister() -> Bool {
        guard hasRegister() else { return true }
        return CTFontManagerUnregisterFontsForURL(url as CFURL, .process, nil)
    }
}

extension UIFont {
    public convenience init?(custom: Fontloadable.Type, size: CGFloat) {
        if custom.hasRegister() {
            self.init(name: custom.familyName, size: size)
            return
        }
        if custom.register() {
            self.init(name: custom.familyName, size: size)
        } else {
            return nil
        }
    }
}
