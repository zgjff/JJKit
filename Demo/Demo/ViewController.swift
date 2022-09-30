//
//  ViewController.swift
//  Demo
//
//  Created by 郑桂杰 on 2022/9/30.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let b = UIButton()
        b.backgroundColor = .jRandom()
        b.jj.handler({ control in
            let v = FirstController()
            v.transitioningDelegate = v.pushPopStylePresentDelegate
//            v.modalPresentationStyle = .custom
            self.present(v, animated: true)
        }, for: .primaryActionTriggered)
        b.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        b.center = view.center
        view.addSubview(b)
    }
}
