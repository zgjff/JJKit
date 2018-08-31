//
//  ViewController.swift
//  Demo
//
//  Created by 郑桂杰 on 2018/5/8.
//  Copyright © 2018年 郑桂杰. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    private lazy var imageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.jj.size = CGSize(width: 200, height: 200)
        imageView.jj.center = view.jj.center
        view.addSubview(imageView)
        let img1 = UIImage.fromColor(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
        imageView.image = img1
        let b = UIButton()
        b.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        b.jj.height(is: 50)
        .width(is: view.jj.width - 100)
        .left(is: 50)
        .bottom(is: view.jj.bottom - 50)
        b.addTarget(self, action: #selector(change(_:)), for: .primaryActionTriggered)
        view.addSubview(b)
    }
    
    @IBAction private func change(_ sender: UIButton) {
        sender.jj.setBackgroundColor(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), radius: 25, for: [])
    }
}


