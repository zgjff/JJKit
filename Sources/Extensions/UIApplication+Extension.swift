//
//  UIApplication+Extension.swift
//  JJKit
//
//  Created by zgjff on 2022/9/30.
//

import UIKit

extension UIApplication: JJCompatible {}

extension JJBox where Base: UIApplication {
    /// 根据系统版本获取`UIApplication`的`keyWindow`
    ///
    /// 低于13.0版本直接获取`keyWindow`
    ///
    /// 高于或等于13.0版本,从`connectedScenes`中获取
    public var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            let windows = base.connectedScenes.compactMap { screen -> UIWindow? in
                guard let wc = screen as? UIWindowScene, wc.activationState != .unattached else {
                    return nil
                }
                if #available(iOS 15.0, *) {
                    return wc.keyWindow
                }
                if let s = wc.delegate as? UIWindowSceneDelegate, let sw = s.window, let ssw = sw {
                    return ssw
                }
                return wc.windows.filter { $0.isKeyWindow }.first
            }
            return windows.first
        } else {
            return base.keyWindow
        }
    }
    
    /// 获取栈顶的控制器
    /// - Parameter top: 对应控制器
    /// - Returns: 结果
    public func topViewController(_ top: UIViewController?) -> UIViewController? {
        if let nav = top as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = top as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let page = top as? UIPageViewController {
            if let vc = page.viewControllers?.first {
                return topViewController(vc)
            }
        }
        if let presented = top?.presentedViewController {
            return topViewController(presented)
        }
        return top
    }
    
    /// 屏幕方向
    public var orientation: UIInterfaceOrientation {
        if #available(iOS 13.0, *) {
            let scenes = UIApplication.shared.connectedScenes.filter { $0.activationState != .unattached }.compactMap { $0 as? UIWindowScene }
            return scenes.first?.interfaceOrientation ?? .portrait
        } else {
            return UIApplication.shared.statusBarOrientation
        }
    }
}
