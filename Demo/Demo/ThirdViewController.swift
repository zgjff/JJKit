//
//  ThirdViewController.swift
//  Demo
//
//  Created by 郑桂杰 on 2019/8/17.
//  Copyright © 2019 郑桂杰. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    private lazy var b = UIButton()
}

extension ThirdViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        preferredContentSize = CGSize(width: view.jj.width, height: 300)
        b.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        b.addTarget(self, action: #selector(dis), for: .primaryActionTriggered)
        view.addSubview(b)
        b.jj.layout { make in
            make.height.equalTo(40)
        }
    }
    
    @IBAction private func dis() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        b.jj.layout { make in
            make.width.equalTo(view).offsetBy(-100)
            make.center.equalTo(view)
        }
    }
}
