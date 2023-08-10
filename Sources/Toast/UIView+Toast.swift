//
//  UIView+Toast.swift
//  JJKit
//
//  Created by zgjff on 2023/8/8.
//

import UIKit

// MARK: - 操作 `Toast`,通用方法
public extension UIView {
    func makeToast(_ item: some JJToastItemable) -> JJToastDSL<some JJToastItemable> {
        JJToastDSL(view: self, item: item)
    }
}
