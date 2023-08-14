//
//  JJAddDirectlyToastStrategy.swift
//  JJKit
//
//  Created by zgjff on 2023/8/14.
//

import UIKit

/// 直接添加`toast`, 不论是否存在相同的
public struct JJAddDirectlyToastStrategy: JJSameToastItemTypeStrategy {
    public func toatContainer(_ container: some JJToastContainer, willPresentIn viewToShow: UIView, animated animatedFlag: Bool) {
        container.dealShow(in: viewToShow, animated: animatedFlag)
    }
}
