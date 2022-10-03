//
//  AddCloseNaviItemToDismissable.swift
//  Demo
//
//  Created by zgjff on 2022/10/3.
//

import UIKit
protocol AddCloseNaviItemToDismissable: UIViewController {
    func addCloseNaviItem()
}

extension AddCloseNaviItemToDismissable {
    func addCloseNaviItem() {
        if #available(iOS 13.0, *) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, handler: { [unowned self] item in
                self.dismiss(animated: true)
            })
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, handler: { [unowned self] item in
                self.dismiss(animated: true)
            })
        }
    }
}
