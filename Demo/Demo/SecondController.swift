//
//  SecondController.swift
//  Demo
//
//  Created by 郑桂杰 on 2019/7/30.
//  Copyright © 2019 郑桂杰. All rights reserved.
//

import UIKit

class SecondController: UIViewController {
    private lazy var imageView = UIImageView()
    
}

extension SecondController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        imageView.jj.layout { make in
            make.width.equalTo(300)
            make.height.equalTo(40)
            make.centerX.equalTo(view)
            make.top.equalTo(100)
        }
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.addSubview(imageView)
        
        let b = UIButton()
        b.jj.setBackgroundColor(UIColor.cyan, for: [])
        b.jj.layout { make in
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.left.equalTo(imageView)
            make.top.equalTo(imageView.jj.bottom).offsetBy(30)
        }
    }
}
