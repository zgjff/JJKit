//
//  UIGesture+Extension.swift
//  JJKit
//
//  Created by 郑桂杰 on 2022/9/30.
//

import UIKit

private var tapGestureRecognizerBlockKey = 0
extension UITapGestureRecognizer {
    public convenience init(handler: @escaping (_ tapGesture: UITapGestureRecognizer) -> Void) {
        self.init(target: nil, action: nil)
        objc_setAssociatedObject(self, &tapGestureRecognizerBlockKey, handler, .OBJC_ASSOCIATION_COPY)
        addTarget(self, action: #selector(handlerAction(_:)))
    }
    
    @IBAction private func handlerAction(_ sender: UITapGestureRecognizer) {
        if let handler = objc_getAssociatedObject(self, &tapGestureRecognizerBlockKey) as? ((UITapGestureRecognizer) -> Void) {
            handler(sender)
        }
    }
}

private var longPressGestureRecognizerBlockKey = 0
extension UILongPressGestureRecognizer {
    public convenience init(handler: @escaping (_ longPressGesture: UILongPressGestureRecognizer) -> Void) {
        self.init(target: nil, action: nil)
        objc_setAssociatedObject(self, &longPressGestureRecognizerBlockKey, handler, .OBJC_ASSOCIATION_COPY)
        addTarget(self, action: #selector(handlerAction(_:)))
    }
    
    @IBAction private func handlerAction(_ sender: UILongPressGestureRecognizer) {
        if let handler = objc_getAssociatedObject(self, &longPressGestureRecognizerBlockKey) as? ((UILongPressGestureRecognizer) -> Void) {
            handler(sender)
        }
    }
}

private var swipeGestureRecognizerBlockKey = 0
extension UISwipeGestureRecognizer {
    public convenience init(handler: @escaping (_ swipeGesture: UISwipeGestureRecognizer) -> Void) {
        self.init(target: nil, action: nil)
        objc_setAssociatedObject(self, &swipeGestureRecognizerBlockKey, handler, .OBJC_ASSOCIATION_COPY)
        addTarget(self, action: #selector(handlerAction(_:)))
    }
    
    @IBAction private func handlerAction(_ sender: UISwipeGestureRecognizer) {
        if let handler = objc_getAssociatedObject(self, &swipeGestureRecognizerBlockKey) as? ((UISwipeGestureRecognizer) -> Void) {
            handler(sender)
        }
    }
}

private var rotationGestureRecognizerBlockKey = 0
extension UIRotationGestureRecognizer {
    public convenience init(handler: @escaping (_ rotationGesture: UIRotationGestureRecognizer) -> Void) {
        self.init(target: nil, action: nil)
        objc_setAssociatedObject(self, &rotationGestureRecognizerBlockKey, handler, .OBJC_ASSOCIATION_COPY)
        addTarget(self, action: #selector(handlerAction(_:)))
    }
    
    @IBAction private func handlerAction(_ sender: UIRotationGestureRecognizer) {
        if let handler = objc_getAssociatedObject(self, &rotationGestureRecognizerBlockKey) as? ((UIRotationGestureRecognizer) -> Void) {
            handler(sender)
        }
    }
}

private var panGestureRecognizerBlockKey = 0
extension UIPanGestureRecognizer {
    public convenience init(handler: @escaping (_ panGesture: UIPanGestureRecognizer) -> Void) {
        self.init(target: nil, action: nil)
        objc_setAssociatedObject(self, &panGestureRecognizerBlockKey, handler, .OBJC_ASSOCIATION_COPY)
        addTarget(self, action: #selector(handlerAction(_:)))
    }
    
    @IBAction private func handlerAction(_ sender: UIPanGestureRecognizer) {
        if let handler = objc_getAssociatedObject(self, &panGestureRecognizerBlockKey) as? ((UIPanGestureRecognizer) -> Void) {
            handler(sender)
        }
    }
}

private var pinchGestureRecognizerBlockKey = 0
extension UIPinchGestureRecognizer {
    public convenience init(handler: @escaping (_ pinchGesture: UIPinchGestureRecognizer) -> Void) {
        self.init(target: nil, action: nil)
        objc_setAssociatedObject(self, &pinchGestureRecognizerBlockKey, handler, .OBJC_ASSOCIATION_COPY)
        addTarget(self, action: #selector(handlerAction(_:)))
    }
    
    @IBAction private func handlerAction(_ sender: UIPinchGestureRecognizer) {
        if let handler = objc_getAssociatedObject(self, &pinchGestureRecognizerBlockKey) as? ((UIPinchGestureRecognizer) -> Void) {
            handler(sender)
        }
    }
}
