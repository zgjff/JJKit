//
//  UIApplication+Extension.swift
//  Demo
//
//  Created by 123 on 2018/6/29.
//  Copyright © 2018年 郑桂杰. All rights reserved.
//

import UIKit

extension UIApplication: JJCompatible {}

extension JJ where Base: UIApplication {
    public func topViewController(_ top: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = top as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = top as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = top?.presentedViewController {
            return topViewController(presented)
        }
        return top
    }
}

