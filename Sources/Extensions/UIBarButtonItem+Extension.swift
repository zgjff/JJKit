//
//  UIBarButtonItem+Extension.swift
//  JJKit
//
//  Created by zgjff on 2022/9/30.
//

import UIKit

private var barButtonItemBlockKey = 0
extension UIBarButtonItem {
    /// 初始化.  ⚠️注意循环引用
    public convenience init(image: UIImage?, style: UIBarButtonItem.Style, handler: @escaping (_ item: UIBarButtonItem) -> Void) {
        self.init(image: image, style: style, target: nil, action: nil)
        objc_setAssociatedObject(self, &barButtonItemBlockKey, handler, .OBJC_ASSOCIATION_COPY)
        target = self
        action = #selector(handlerAction(_:))
    }
    
    /// 初始化.  ⚠️注意循环引用
    public convenience init(image: UIImage?, landscapeImagePhone: UIImage?, style: UIBarButtonItem.Style, handler: @escaping (_ item: UIBarButtonItem) -> Void) {
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: nil, action: nil)
        objc_setAssociatedObject(self, &barButtonItemBlockKey, handler, .OBJC_ASSOCIATION_COPY)
        target = self
        action = #selector(handlerAction(_:))
    }
    
    /// 初始化.  ⚠️注意循环引用
    public convenience init(title: String?, style: UIBarButtonItem.Style, handler: @escaping (_ item: UIBarButtonItem) -> Void) {
        self.init(title: title, style: style, target: nil, action: nil)
        objc_setAssociatedObject(self, &barButtonItemBlockKey, handler, .OBJC_ASSOCIATION_COPY)
        target = self
        action = #selector(handlerAction(_:))
    }
    
    /// 初始化.  ⚠️注意循环引用
    public convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem, handler: @escaping (_ item: UIBarButtonItem) -> Void) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
        objc_setAssociatedObject(self, &barButtonItemBlockKey, handler, .OBJC_ASSOCIATION_COPY)
        target = self
        action = #selector(handlerAction(_:))
    }
    
    @IBAction private func handlerAction(_ sender: UIBarButtonItem) {
        if let handler = objc_getAssociatedObject(self, &barButtonItemBlockKey) as? ((UIBarButtonItem) -> Void) {
            handler(sender)
        }
    }
}
