import UIKit

extension String: JJCompatible {}

extension JJ where Object == String {
    
    public func attributeMake(_ make: (AttributMaker) -> ()) -> NSAttributedString {
        let maker = AttributMaker(string: object)
        make(maker)
        return maker.build()
    }
    
    /// 如果使用指定的约束呈现字符串，则返回字符串的大小
    ///
    /// - Parameters:
    ///   - font: 用于计算字符串大小的字体
    ///   - size: 字符串的最大可接受大小。 这个值是用于计算哪里会发生换行和换行
    ///   - mode: 用于计算字符串大小的换行符选项
    /// - Returns: 生成的字符串的边界框的宽度和高度
    public func sizeForFont(_ font: UIFont, size: CGSize, lineBreakMode mode: NSLineBreakMode = .byWordWrapping) -> CGSize {
        
        let text = object as NSString
        var atts: [NSAttributedString.Key: Any] = [.font: font]
        if mode != .byWordWrapping {
            let par = NSMutableParagraphStyle()
            par.lineBreakMode = mode
            atts.updateValue(par, forKey: .paragraphStyle)
        }
        let s = text.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: atts, context: nil).size
        return CGSize(width: ceil(s.width), height: ceil(s.height))
    }
}
