import UIKit

extension AlertPresentationContext {
    /// 提供GenericPresentationContext的一些基本默认设置
    public class Default {}
}

public extension AlertPresentationContext.Default {
    /// 转场动画时,高斯模糊view作为presentedViewController view的背景
    static var blurBelowCoverView: (CGRect) -> UIView = { f in
        let v = UIVisualEffectView(frame: f)
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        v.effect = nil
        return v
    }
    
    /// 转场动画present/dismiss时,高斯模糊view的动画效果
    static var blurBelowCoverViewAnimator: (Bool) -> ((UIView, UIViewControllerTransitionCoordinator) -> ()) = { isPresenting in
        return { view, coor in
            guard let bv = view as? UIVisualEffectView else { return }
            coor.animate(alongsideTransition: { _ in
                bv.effect = isPresenting ? UIBlurEffect(style: .light) : nil
            }, completion: nil)
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
    
    /// 上部圆角圆角带阴影的presentedViewController view修饰view
    static var shadowTopRoundedCornerWrappingView: (UIView, CGRect) -> (UIView) = { presentedViewControllerView, frame in
        let presentationWrapperView = UIView(frame: frame)
        presentationWrapperView.layer.shadowOpacity = 0.44
        presentationWrapperView.layer.shadowRadius = 13
        presentationWrapperView.layer.shadowOffset = CGSize(width: 0, height: -6)
        
        let radius: CGFloat = 10
        
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
    
    /// 4个圆角带阴影的presentedViewController view修饰view
    static var shadowAllRoundedCornerWrappingView: (UIView, CGRect) -> (UIView) = { presentedViewControllerView, frame in
        let presentationWrapperView = UIView(frame: frame)
        presentationWrapperView.layer.shadowOpacity = 0.44
        presentationWrapperView.layer.shadowRadius = 13
        presentationWrapperView.layer.shadowOffset = CGSize(width: 0, height: -6)
        
        let radius: CGFloat = 10
        
        let presentationRoundedCornerView = UIView(frame: presentationWrapperView.bounds)
        presentationRoundedCornerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        presentationRoundedCornerView.layer.cornerRadius = radius
        presentationRoundedCornerView.layer.masksToBounds = true
        
        presentedViewControllerView.frame = presentationRoundedCornerView.bounds
        
        presentationRoundedCornerView.addSubview(presentedViewControllerView)
        
        presentationWrapperView.addSubview(presentationRoundedCornerView)
        
        return presentationWrapperView
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
    static var centerTransitionAnimator: (UIView, AlertPresentationContext.TransitionType, TimeInterval, UIViewControllerContextTransitioning) -> () = { view, style, duration, ctx in
        switch style {
        case .present(let f):
            view.frame = f
            view.transform = view.transform.scaledBy(x: 0.01, y: 0.01)
        case .dismiss(initial: let f):
            view.frame = f
            view.transform = CGAffineTransform.identity
        }
        UIView.animate(withDuration: duration, animations: {
            switch style {
            case .present(let f):
                view.transform = CGAffineTransform.identity
            case .dismiss(initial: let f):
                view.transform = view.transform.scaledBy(x: 0.01, y: 0.01)
            }
        }, completion: { _ in
            let wasCancelled = ctx.transitionWasCancelled
            ctx.completeTransition(!wasCancelled)
        })
    }
    
    /// 从底部弹出presentedViewController的动画效果
    static var bottomTransitionAnimator: (UIView, AlertPresentationContext.TransitionType, TimeInterval, UIViewControllerContextTransitioning) -> () = { view, style, duration, ctx in
        switch style {
        case .present(let f):
            view.frame = f.offsetBy(dx: 0, dy: f.height)
        case .dismiss(initial: let f):
            view.frame = f
        }
        UIView.animate(withDuration: duration, animations: {
            switch style {
            case .present(final: let f):
                view.frame = f
            case .dismiss(initial: let f):
                view.frame = f.offsetBy(dx: 0, dy: f.height)
            }
        }) { _ in
            let wasCancelled = ctx.transitionWasCancelled
            ctx.completeTransition(!wasCancelled)
        }
    }
}
