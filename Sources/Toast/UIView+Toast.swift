//
//  UIView+Toast.swift
//  JJKit
//
//  Created by zgjff on 2023/8/8.
//

import UIKit

// MARK: - 操作 `Toast`,通用方法
public extension UIView {
    func makeToast<T>(_ item: T) -> JJToastDSL<T> where T: JJToastItemable {
        JJToastDSL(view: self, item: item)
    }
}
