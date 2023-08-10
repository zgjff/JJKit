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
        let item: UIBarButtonItem.SystemItem
        if #available(iOS 13.0, *) {
            item = .close
        } else {
            item = .cancel
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: item, handler: { [unowned self] item in
            self.dismiss(animated: true)
        })
    }
}
