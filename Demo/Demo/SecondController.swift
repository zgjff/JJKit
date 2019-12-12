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
    private let originalImage = UIImage(named: "tower1.jpg")!
    deinit {
        print("SecondController  deinit")
    }
}

extension SecondController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        imageView.jj.layout { make in
            make.width.equalTo(view).offsetBy(-100)
            make.height.equalTo(200)
            make.centerX.equalTo(view)
            make.top.equalTo(100)
        }
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        imageView.image = originalImage
        view.addSubview(imageView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, handler: { [unowned self] _ in
            self.imageView.image = self.originalImage
        })
        let b = UIButton()
        b.jj.setBackgroundColor(UIColor.cyan, for: [])
        b.jj.layout { make in
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.left.equalTo(imageView)
            make.top.equalTo(imageView.jj.bottom).offsetBy(30)
        }
        b.jj.addBlockHandler(for: .primaryActionTriggered) { [unowned self] _ in
            self.imageView.image = self.originalImage.jj.resized(maxSize: self.imageView.jj.width)
        }
        view.addSubview(b)
    }
}
