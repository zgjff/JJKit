//
//  FirstController.swift
//  Demo
//
//  Created by 郑桂杰 on 2022/9/30.
//

import UIKit

class FirstController: UIViewController, JJPushPopStylePresentDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .jRandom()
        self.jj.addScreenPanGestureDismiss()
        
        let b = UIButton()
        b.backgroundColor = .jRandom()
        b.jj.handler({ [weak self] control in
            self?.dismiss(animated: true)
        }, for: .primaryActionTriggered)
        
        b.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        b.center = view.center
        view.addSubview(b)
    }
}
