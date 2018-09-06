import UIKit

public struct IconData<Font: Fontloadable>: CustomStringConvertible {
    public typealias CodeUnit = UInt16
    private let codePoint: CodeUnit
    
    public init(codePoint: CodeUnit) {
        self.codePoint = codePoint
    }
}

extension IconData {
    public var description: String {
        let radix16 = String(codePoint, radix: 16, uppercase: true)
        return Font.familyName + "+U{0x" + radix16 + "}"
    }
}

extension IconData {
    public func toString() -> String? {
        guard let scalar = Unicode.Scalar.init(codePoint) else {
            return nil
        }
        return String(scalar)
    }
    public func toAttributeString(size: CGFloat, tintColor: UIColor = .black, backgroundColor: UIColor = .clear) -> NSAttributedString? {
        guard let string = toString() else { return nil }
        let s = size >= 3 ? size : 3
        guard let font = UIFont(custom: Font.self, size: s) else { return nil }
        let attributes: [NSAttributedStringKey: Any] = [
            .font: font,
            .foregroundColor: tintColor,
            .backgroundColor: backgroundColor
        ]
        return NSAttributedString(string: string, attributes: attributes)
    }
    public func toImage(size: CGSize = CGSize(width: 30, height: 30), tintColor: UIColor = .black, backgroundColor: UIColor = .clear) -> UIImage? {
        guard let string = toString() else { return nil }
        var newSize = size
        newSize.width = (size.width >= 3) ? size.width : 3
        newSize.height = (size.height >= 3) ? size.height : 3
        let s = min(newSize.width, newSize.height)
        guard let font = UIFont(custom: Font.self, size: s) else { return nil }
        let par = NSMutableParagraphStyle()
        par.alignment = .center
        let attributes: [NSAttributedStringKey: Any] = [
            .font: font,
            .paragraphStyle: par,
            .foregroundColor: tintColor,
            .backgroundColor: backgroundColor
        ]
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        return UIImage(size: size) { context in
            attributedString.draw(in: CGRect(origin: .zero, size: newSize))
        }
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
