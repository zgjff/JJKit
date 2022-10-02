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
        view.backgroundColor = .jRandom()
        let a = UINavigationController()
        let iv1 = UIImageView()
        iv1.backgroundColor = .jRandom()
        iv1.frame = CGRect(x: 50, y: 100, width: 200, height: 200)
        view.addSubview(iv1)
        let img1 = UIImage.shape(.plus(10), size: 200)
        iv1.image = img1
        
        let iv = UIImageView()
        iv.backgroundColor = .jRandom()
        iv.frame = CGRect(x: 50, y: 400, width: 200, height: 200)
        view.addSubview(iv)
        let img = UIImage.shape(.plus(10), size: 200)
        iv.image = img
    }
}
