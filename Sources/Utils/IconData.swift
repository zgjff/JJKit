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
    public func toString() -> String? {
        guard let scalar = Unicode.Scalar.init(codePoint) else {
            return nil
        }
        return String(scalar)
    }
    /// 生成对应的IconDataMaker,可以链式为iconData增加各种NSAttributedStringKey来调试Icon,
    /// 最后需要调用image()/attributeString(),来生成image/attributeString,
    /// - Parameter size: Icon的大小--此为协议,默认CGSize/CGFloat实现了此协议,默认为CGSize(width: 30, height: 30)
    /// - Returns: IconDataMaker
    public func size(_ size: IconSizeable = CGSize(width: 30, height: 30)) -> IconDataMaker<Self>? {
        guard let _ = UIFont(custom: Font.self, size: size.fontSize()) else {
            return nil
        }
        return IconDataMaker(icon: self, size: size)
    }
}

/// 为IconData增加各种样式,最后组合成image/attributeString,默认提供了tintColor/backgroundColor,
/// 您也可以增加extension,来扩展样式,比如超链接/描边等等
public final class IconDataMaker<Icon: IconData> {
    private let icon: Icon
    private let size: IconSizeable
    private var attributes: [NSAttributedStringKey: Any]
    
    public init(icon: Icon, size: IconSizeable) {
        self.icon = icon
        self.size = size
        let font = UIFont(custom: Icon.Font.self, size: size.fontSize())!
        attributes = [.font: font]
    }
    /// 为IconData增加tintColor
    ///
    /// - Parameter color: tintColor
    /// - Returns: IconDataMaker
    public func tintColor(_ color: UIColor = .black) -> Self {
        attributes.updateValue(color, forKey: .foregroundColor)
        return self
    }
    /// 为IconData增加backgroundColor
    ///
    /// - Parameter color: backgroundColor
    /// - Returns: IconDataMaker
    public func backgroundColor(_ color: UIColor = .clear) -> Self {
        attributes.updateValue(color, forKey: .backgroundColor)
        return self
    }
    public func image() -> UIImage? {
        guard let string = icon.toString() else { return nil }
        let par = NSMutableParagraphStyle()
        par.alignment = .center
        attributes.updateValue(par, forKey: .paragraphStyle)
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        let s = size.imageSize()
        return UIImage(size: s) { context in
            attributedString.draw(in: CGRect(origin: .zero, size: s))
            }?.withRenderingMode(.alwaysOriginal)
    }
    public func attributeString() -> NSAttributedString? {
        guard let string = icon.toString() else { return nil }
        return NSAttributedString(string: string, attributes: attributes)
    }
}

/// Icon 的大小,已经默认实现了CGSize/CGFloat
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
