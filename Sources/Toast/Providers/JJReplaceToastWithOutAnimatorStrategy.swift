//
//  JJReplaceToastWithOutAnimatorStrategy.swift
//  JJKit
//
//  Created by zgjff on 2023/8/14.
//

import UIKit

/// 直接所有相同的都隐藏,并展示新的,且无需隐藏/显示动画
public struct JJReplaceToastWithOutAnimatorStrategy: JJSameToastItemTypeStrategy {
    public init() {}
    
    public func toatContainer(_ container: some JJToastContainer, willPresentIn viewToShow: UIView, animated animatedFlag: Bool) {
        let showToasts = viewToShow.shownContaienrQueue.all
        if showToasts.isEmpty {
            container.dealShow(in: viewToShow, animated: animatedFlag)
            return
        }
        for toast in showToasts {
            toast.dismiss(animated: false)
        }
        container.dealShow(in: viewToShow, animated: false)
    }
}
