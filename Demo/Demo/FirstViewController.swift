//
//  FirstViewController.swift
//  Demo
//
//  Created by zgjff on 2022/11/1.
//

import UIKit

class FirstViewController: UIViewController {

}

extension FirstViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        preferredContentSize = CGSize(width: view.bounds.width, height: 300)
        let a = Result<Int, Error>.success(1)
        
    }
}
