//
//  SecondController.swift
//  Demo
//
//  Created by 郑桂杰 on 2019/7/30.
//  Copyright © 2019 郑桂杰. All rights reserved.
//

import UIKit

class SecondController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let v = UIView()
        v.backgroundColor = .cyan
        v.jj.layout { make in
            make.width.equalTo(view).offsetBy(-100)
            make.height.equalTo(200)
            make.center.equalTo(view)
        }
        v.clipsToBounds = true
        view.addSubview(v)
        let iv = UIImageView()
        iv.backgroundColor = .green
        v.addSubview(iv)
        iv.jj.layout { make in
            make.edges.equalTo(v)
        }
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(color: .red, size: CGSize(width: iv.jj.width + 200, height: iv.jj.height + 100))
    }
}
