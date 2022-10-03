//
//  JJAlertPresentationContext+Default.swift
//  JJKit
//
//  Created by zgjff on 2022/9/30.
//

import UIKit

extension JJAlertPresentationContext {
    /// 提供GenericPresentationContext的一些基本默认设置
    public struct Default {}
}

public extension JJAlertPresentationContext.Default {
    /// 转场动画时,高斯模糊view作为presentedViewController view的背景
    static var blurBelowCoverView: (CGRect) -> UIView = { f in
        let v = UIVisualEffectView(frame: f)
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        v.effect = nil
        return v
    }
    
    /// 转场动画present/dismiss时,高斯模糊view的动画效果
    static var blurBelowCoverViewAnimator: (UIBlurEffect.Style) -> (Bool) -> ((UIView, UIViewControllerTransitionCoordinator) -> ()) = { style in
        return { isPresenting in
            return { view, coor in
                guard let bv = view as? UIVisualEffectView else { return }
                coor.animate(alongsideTransition: { _ in
                    bv.effect = isPresenting ? UIBlurEffect(style: style) : nil
                }, completion: nil)
            }
        }
    }
    
    /// 转场动画时,暗灰色view作为presentedViewController view的背景
    static var dimmingBelowCoverView: (CGRect) -> UIView = { f in
        let v = UIView(frame: f)
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        v.backgroundColor = .black
        v.isOpaque = false
        return v
    }
    
    /// 转场动画present/dismiss时,暗灰色view的动画效果
    static var dimmingBelowCoverViewAnimator: (Bool) -> ((UIView, UIViewControllerTransitionCoordinator) -> ()) = { isPresenting in
        return { view, coor in
            if isPresenting {
                view.alpha = 0
            }
            coor.animate(alongsideTransition: { _ in
                view.alpha = isPresenting ? 0.5 : 0.0
            }, completion: nil)
        }
    }
    
    /// 转场动画时,clear view作为presentedViewController view的背景
    static var clearBelowCoverView: (CGRect) -> UIView = { f in
        let v = UIView(frame: f)
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        v.backgroundColor = .clear
        return v
    }
    
    /// 转场动画present/dismiss时,clear色view的动画效果
    static var clearBelowCoverViewAnimator: (Bool) -> ((UIView, UIViewControllerTransitionCoordinator) -> ()) = { isPresenting in
        return { _, _ in}
    }
    
    /// 上部圆角圆角带阴影的presentedViewController view修饰view
    static var shadowTopRoundedCornerWrappingView: (CGFloat) -> (UIView, CGRect) -> (UIView) = { radius in
        return { presentedViewControllerView, frame in
            let presentationWrapperView = UIView(frame: frame)
            presentationWrapperView.layer.shadowOpacity = 0.44
            presentationWrapperView.layer.shadowRadius = 13
            presentationWrapperView.layer.shadowOffset = CGSize(width: 0, height: -6)
            
            let presentationRoundedCornerView = UIView(frame: presentationWrapperView.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: -radius, right: 0)))
            presentationRoundedCornerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            presentationRoundedCornerView.layer.cornerRadius = radius
            presentationRoundedCornerView.layer.masksToBounds = true
            
            let presentedViewControllerWrapperView = UIView(frame: presentationRoundedCornerView.bounds.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: radius, right: 0)))
            presentedViewControllerWrapperView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            
            presentedViewControllerView.frame = presentedViewControllerWrapperView.bounds
            presentedViewControllerWrapperView.addSubview(presentedViewControllerView)

            presentationRoundedCornerView.addSubview(presentedViewControllerWrapperView)
            
            presentationWrapperView.addSubview(presentationRoundedCornerView)
            
            return presentationWrapperView
        }
    }
    
    /// 4个圆角带阴影的presentedViewController view修饰view
    static var shadowAllRoundedCornerWrappingView: (CGFloat) -> (UIView, CGRect) -> (UIView) = { radius in
        return { presentedViewControllerView, frame in
            let presentationWrapperView = UIView(frame: frame)
            presentationWrapperView.layer.shadowOpacity = 0.44
            presentationWrapperView.layer.shadowRadius = 13
            presentationWrapperView.layer.shadowOffset = CGSize(width: 0, height: -6)
            let presentationRoundedCornerView = UIView(frame: presentationWrapperView.bounds)
            presentationRoundedCornerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            presentationRoundedCornerView.layer.cornerRadius = radius
            presentationRoundedCornerView.layer.masksToBounds = true
            
            presentedViewControllerView.frame = presentationRoundedCornerView.bounds
            
            presentationRoundedCornerView.addSubview(presentedViewControllerView)
            
            presentationWrapperView.addSubview(presentationRoundedCornerView)
            
            return presentationWrapperView
        }
    }
    
    /// 4个圆角不带阴影的presentedViewController view修饰view
    static var allRoundedCornerWrappingView: (CGFloat) -> (UIView, CGRect) -> (UIView) = { radius in
        return { presentedViewControllerView, frame in
                let presentationRoundedCornerView = UIView(frame: frame)
                presentationRoundedCornerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
                presentationRoundedCornerView.layer.cornerRadius = radius
                presentationRoundedCornerView.layer.masksToBounds = true
                
                presentedViewControllerView.frame = presentationRoundedCornerView.bounds
                
                presentationRoundedCornerView.addSubview(presentedViewControllerView)
                
                return presentationRoundedCornerView
        }
    }
    
    /// 上部圆角圆角不带阴影的presentedViewController view修饰view
    static var topRoundedCornerWrappingView: (CGFloat) -> (UIView, CGRect) -> (UIView) = { radius in
        return { presentedViewControllerView, frame in
            let presentationRoundedCornerView = UIView(frame: frame)
            presentationRoundedCornerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            presentationRoundedCornerView.layer.cornerRadius = radius
            if #available(iOS 11.0, *) {
                presentationRoundedCornerView.layer.masksToBounds = true
                presentationRoundedCornerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else {
                let maskLayer = CAShapeLayer()
                maskLayer.frame = presentationRoundedCornerView.bounds
                maskLayer.path = UIBezierPath(roundedRect: presentationRoundedCornerView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: radius, height: radius)).cgPath
                presentationRoundedCornerView.layer.mask = maskLayer
            }
            presentedViewControllerView.frame = presentationRoundedCornerView.bounds
            presentationRoundedCornerView.addSubview(presentedViewControllerView)
            return presentationRoundedCornerView
        }
    }
    
    /// 无效果的presentedViewController view修饰view
    static var emptyWrappingView: (UIView, CGRect) -> (UIView) = { presentedViewControllerView, frame in
        let presentationWrapperView = UIView(frame: frame)
        presentedViewControllerView.frame = presentationWrapperView.bounds
        presentationWrapperView.addSubview(presentedViewControllerView)
        return presentationWrapperView
    }
    
    /// 使presentedViewController的view居中显示的frame
    static var centerFrameOfPresentedView: (CGRect, CGSize) -> (CGRect) = {
        bounds, size in
        let x = (bounds.width - size.width) * 0.5
        let y = (bounds.height - size.height) * 0.5
        return CGRect(origin: CGPoint(x: x, y: y), size: size)
    }
    
    /// 使presentedViewController的view在底部显示的frame
    static var bottomFrameOfPresentedView: (CGRect, CGSize) -> (CGRect) = {
        bounds, size in
        let x = bounds.midX - size.width * 0.5
        let y = bounds.maxY - size.height
        return CGRect(origin: CGPoint(x: x, y: y), size: size)
    }
    
    /// 居中弹出presentedViewController的动画效果
    static var centerTransitionAnimator: (UIView, UIView, JJAlertPresentationContext.TransitionType, TimeInterval, UIViewControllerContextTransitioning) -> () = { fromView, toView, style, duration, ctx in
        switch style {
        case .present(frames: let frames):
            toView.frame = frames.toFinalFrame
            toView.transform = toView.transform.scaledBy(x: 0.01, y: 0.01)
        case .dismiss(frames: let frames):
            fromView.frame = frames.fromInitialFrame
            fromView.transform = CGAffineTransform.identity
        }
        UIView.animate(withDuration: duration, animations: {
            switch style {
            case .present:
                toView.transform = CGAffineTransform.identity
            case .dismiss:
                fromView.transform = fromView.transform.scaledBy(x: 0.01, y: 0.01)
            }
        }, completion: { _ in
            let wasCancelled = ctx.transitionWasCancelled
            ctx.completeTransition(!wasCancelled)
        })
    }
    
    /// 从底部弹出presentedViewController的动画效果
    static var bottomTransitionAnimator: (UIView, UIView, JJAlertPresentationContext.TransitionType, TimeInterval, UIViewControllerContextTransitioning) -> () = { fromView, toView, style, duration, ctx in
        switch style {
        case .present(frames: let frames):
            let f = frames.toFinalFrame
            toView.frame = f.offsetBy(dx: 0, dy: f.height)
        case .dismiss(frames: let frames):
            let f = frames.fromInitialFrame
            fromView.frame = f
        }
        UIView.animate(withDuration: duration, animations: {
            switch style {
            case .present(frames: let frames):
                toView.frame = frames.toFinalFrame
            case .dismiss(frames: let frames):
                let f = frames.fromInitialFrame
                fromView.frame = f.offsetBy(dx: 0, dy: f.height)
            }
        }) { _ in
            let wasCancelled = ctx.transitionWasCancelled
            ctx.completeTransition(!wasCancelled)
        }
    }
}
