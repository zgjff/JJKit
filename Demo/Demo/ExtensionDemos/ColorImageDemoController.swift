//
//  ColorImageDemoController.swift
//  Demo
//
//  Created by zgjff on 2022/10/8.
//

import UIKit

class ColorImageDemoController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension ColorImageDemoController {
    func setup() {
        title = "颜色图片"
        
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .jRandom()
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
        
        let iv1 = UIImageView()
        iv1.image = UIImage(color: .red)
        iv1.frame = CGRect(x: 20, y: 30, width: 100, height: 100)
        scrollView.addSubview(iv1)
        
        let iv2 = UIImageView()
        iv2.image = UIImage(color: .orange, size: CGSize(width: 100, height: 100), cornerRadius: 15)
        iv2.frame = CGRect(x: iv1.jj.right + 20, y: iv1.jj.top, width: 100, height: 100)
        scrollView.addSubview(iv2)
        
        let iv3 = UIImageView()
        iv3.image = UIImage(linearColors: { size in
            return [
                (.blue, 0),
                (.green, 0.5),
                (.red, 1)
            ]
        }, size: CGSize(width: 100, height: 100))
        iv3.frame = CGRect(x: iv1.jj.left, y: iv1.jj.bottom + 50, width: 100, height: 100)
        scrollView.addSubview(iv3)
        
        let iv4 = UIImageView()
        iv4.image = UIImage(linearColors: { size in
            return [
                (.blue, 0),
                (.green, 0.5),
                (.red, 1)
            ]
        }, size: CGSize(width: 100, height: 100), end: CGPoint(x: 1, y: 1))
        iv4.frame = CGRect(x: iv2.jj.left, y: iv3.jj.top, width: 100, height: 100)
        scrollView.addSubview(iv4)
        
        let iv5 = UIImageView()
        iv5.image = UIImage(linearColors: { size in
            return [
                (.blue, 1),
                (.green, 0.5),
                (.red, 0)
            ]
        }, size: CGSize(width: 100, height: 100), end: CGPoint(x: 1, y: 1))
        iv5.frame = CGRect(x: iv4.jj.right + 20, y: iv3.jj.top, width: 100, height: 100)
        scrollView.addSubview(iv5)
        
        let iv6 = UIImageView()
        iv6.image = UIImage(radialColors: { size in
            return [
                (.blue, 0),
                (.green, 0.5),
                (.red, 1)
            ]
        }, size: CGSize(width: 100, height: 100), radius: 50)
        iv6.frame = CGRect(x: iv3.jj.left, y: iv3.jj.bottom + 50, width: 100, height: 100)
        scrollView.addSubview(iv6)
    }
}
