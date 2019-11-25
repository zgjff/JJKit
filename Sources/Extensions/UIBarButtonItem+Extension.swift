import UIKit

private var barButtonItemBlockKey = 0
extension UIBarButtonItem {
    public convenience init(image: UIImage?, style: UIBarButtonItem.Style, handler: @escaping (UIBarButtonItem) -> Void) {
        self.init(image: image, style: style, target: nil, action: nil)
        objc_setAssociatedObject(self, &barButtonItemBlockKey, handler, .OBJC_ASSOCIATION_COPY)
        target = self
        action = #selector(handlerAction(_:))
    }
    
    public convenience init(image: UIImage?, landscapeImagePhone: UIImage?, style: UIBarButtonItem.Style, handler: @escaping (UIBarButtonItem) -> Void) {
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: nil, action: nil)
        objc_setAssociatedObject(self, &barButtonItemBlockKey, handler, .OBJC_ASSOCIATION_COPY)
        target = self
        action = #selector(handlerAction(_:))
    }
    
    public convenience init(title: String?, style: UIBarButtonItem.Style, handler: @escaping (UIBarButtonItem) -> Void) {
        self.init(title: title, style: style, target: nil, action: nil)
        objc_setAssociatedObject(self, &barButtonItemBlockKey, handler, .OBJC_ASSOCIATION_COPY)
        target = self
        action = #selector(handlerAction(_:))
    }
    
    public convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem, handler: @escaping (UIBarButtonItem) -> Void) {
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
