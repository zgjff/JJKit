//
//  String+Extension.swift
//  Demo
//
//  Created by 123 on 2018/6/29.
//  Copyright © 2018年 郑桂杰. All rights reserved.
//

import UIKit

extension String: JJCompatible {}

extension JJ where Original == String {
    
    public func attribute(make: (AttributMaker) -> ()) -> NSAttributedString {
        let maker = AttributMaker(string: original)
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
    public func sizeForFont(_ font: UIFont, size: CGSize, lineBreakMode mode: NSLineBreakMode) -> CGSize {
        
        let text = original as NSString
        var atts: [NSAttributedStringKey: Any]? = nil
        if mode != .byWordWrapping {
            let par = NSMutableParagraphStyle()
            par.lineBreakMode = mode
            atts = [NSAttributedStringKey.paragraphStyle: par]
        }
        return text.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: atts, context: nil).size
    }
    
    
    /// 用于计算一行字体时的宽度
    ///
    /// - Parameter font: 用于计算字符串宽度的字体
    /// - Returns: 生成的字符串边界框的宽度。
    func widthForFont(_ font: UIFont) -> CGFloat {
        return sizeForFont(font, size: CGSize(width: CGFloat(HUGE), height: CGFloat(HUGE)), lineBreakMode: .byWordWrapping).width
    }
    
    
    /// 用于计算一行字体时的高度
    ///
    /// - Parameter font: 用于计算字符串高度的字体
    /// - Returns: 生成的字符串边界框的高度
    func heightForFont(_ font: UIFont) -> CGFloat {
        return sizeForFont(font, size: CGSize(width: CGFloat(HUGE), height: CGFloat(HUGE)), lineBreakMode: .byWordWrapping).height
    }
}
