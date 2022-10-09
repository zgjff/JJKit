//
//  ShapeImageDemoController.swift
//  Demo
//
//  Created by zgjff on 2022/10/8.
//

import UIKit

class ShapeImageDemoController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension ShapeImageDemoController {
    func setup() {
        title = "形状图片"
        view.backgroundColor = .black
        
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
        
        let iv1 = UIImageView()
        iv1.frame = CGRect(x: 20, y: 0, width: 40, height: 40)
        iv1.image = UIImage.shape(.circle(4), size: 40)
        scrollView.addSubview(iv1)
        
        let iv2 = UIImageView()
        iv2.frame = iv1.frame.offsetBy(dx: iv1.jj.width + 20, dy: 0)
        iv2.image = UIImage.shape(.circleFill, size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv2)
        
        let iv3 = UIImageView()
        iv3.frame = iv2.frame.offsetBy(dx: iv2.jj.width + 20, dy: 0)
        iv3.image = UIImage.shape(.plus(4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv3)
        
        let iv4 = UIImageView()
        iv4.frame = iv3.frame.offsetBy(dx: iv3.jj.width + 20, dy: 0)
        iv4.image = UIImage.shape(.plusCircle(4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv4)
        
        let iv5 = UIImageView()
        iv5.frame = iv4.frame.offsetBy(dx: iv3.jj.width + 20, dy: 0)
        iv5.image = UIImage.shape(.plusCircleFill(4, .jRandom()), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv5)
        
        let iv6 = UIImageView()
        iv6.frame = iv1.frame.offsetBy(dx: 0, dy: iv1.jj.height + 20)
        iv6.image = UIImage.shape(.minus(4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv6)
        
        let iv7 = UIImageView()
        iv7.frame = iv6.frame.offsetBy(dx: iv6.jj.width + 20, dy: 0)
        iv7.image = UIImage.shape(.minusCircle(4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv7)
        
        let iv8 = UIImageView()
        iv8.frame = iv7.frame.offsetBy(dx: iv6.jj.width + 20, dy: 0)
        iv8.image = UIImage.shape(.minusCircleFill(4, .jRandom()), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv8)
        
        let iv9 = UIImageView()
        iv9.frame = iv8.frame.offsetBy(dx: iv6.jj.width + 20, dy: 0)
        iv9.image = UIImage.shape(.multiply(4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv9)
        
        let iv10 = UIImageView()
        iv10.frame = iv9.frame.offsetBy(dx: iv6.jj.width + 20, dy: 0)
        iv10.image = UIImage.shape(.multiplyCircle(4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv10)
        
        let iv11 = UIImageView()
        iv11.frame = iv6.frame.offsetBy(dx: 0, dy: iv6.jj.height + 20)
        iv11.image = UIImage.shape(.multiplyCircleFill(4, .jRandom()), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv11)
        
        let iv12 = UIImageView()
        iv12.frame = iv11.frame.offsetBy(dx: iv11.jj.width + 20, dy: 0)
        iv12.image = UIImage.shape(.equal(4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv12)
        
        let iv13 = UIImageView()
        iv13.frame = iv12.frame.offsetBy(dx: iv11.jj.width + 20, dy: 0)
        iv13.image = UIImage.shape(.equalCircle(4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv13)
        
        let iv14 = UIImageView()
        iv14.frame = iv13.frame.offsetBy(dx: iv11.jj.width + 20, dy: 0)
        iv14.image = UIImage.shape(.equalCircleFill(4, .jRandom()), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv14)
        
        let iv15 = UIImageView()
        iv15.frame = iv11.frame.offsetBy(dx: 0, dy: iv11.jj.height + 20)
        iv15.image = UIImage.shape(.chevron(.left, 4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv15)
        
        let iv16 = UIImageView()
        iv16.frame = iv15.frame.offsetBy(dx: iv11.jj.width + 20, dy: 0)
        iv16.image = UIImage.shape(.chevronCircle(.left, 4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv16)
        
        let iv17 = UIImageView()
        iv17.frame = iv16.frame.offsetBy(dx: iv11.jj.width + 20, dy: 0)
        iv17.image = UIImage.shape(.chevronCircleFill(.left, 4, .jRandom()), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv17)
        
        let iv18 = UIImageView()
        iv18.frame = iv15.frame.offsetBy(dx: 0, dy: iv11.jj.height + 20)
//        iv18.frame = iv15.frame
        iv18.image = UIImage.shape(.chevron(.right, 4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv18)
        
        let iv19 = UIImageView()
        iv19.frame = iv18.frame.offsetBy(dx: iv11.jj.width + 20, dy: 0)
        iv19.image = UIImage.shape(.chevronCircle(.right, 4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv19)
        
        let iv20 = UIImageView()
        iv20.frame = iv19.frame.offsetBy(dx: iv11.jj.width + 20, dy: 0)
        iv20.image = UIImage.shape(.chevronCircleFill(.right, 4, .jRandom()), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv20)
        
        let iv21 = UIImageView()
        iv21.frame = iv18.frame.offsetBy(dx: 0, dy: iv11.jj.height + 20)
        iv21.image = UIImage.shape(.chevron(.up, 4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv21)

        let iv22 = UIImageView()
        iv22.frame = iv21.frame.offsetBy(dx: iv11.jj.width + 20, dy: 0)
        iv22.image = UIImage.shape(.chevronCircle(.up, 4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv22)

        let iv23 = UIImageView()
        iv23.frame = iv22.frame.offsetBy(dx: iv11.jj.width + 20, dy: 0)
        iv23.image = UIImage.shape(.chevronCircleFill(.up, 4, .jRandom()), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv23)
        
        let iv24 = UIImageView()
        iv24.frame = iv21.frame.offsetBy(dx: 0, dy: iv11.jj.height + 20)
        iv24.image = UIImage.shape(.chevron(.down, 4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv24)

        let iv25 = UIImageView()
        iv25.frame = iv24.frame.offsetBy(dx: iv11.jj.width + 20, dy: 0)
        iv25.image = UIImage.shape(.chevronCircle(.down, 4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv25)

        let iv26 = UIImageView()
        iv26.frame = iv25.frame.offsetBy(dx: iv11.jj.width + 20, dy: 0)
        iv26.image = UIImage.shape(.chevronCircleFill(.down, 4, .jRandom()), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv26)
        
        let iv27 = UIImageView()
        iv27.frame = iv24.frame.offsetBy(dx: 0, dy: iv11.jj.height + 20)
        iv27.image = UIImage.shape(.arrow(.left, 4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv27)

        let iv28 = UIImageView()
        iv28.frame = iv27.frame.offsetBy(dx: iv11.jj.width + 20, dy: 0)
        iv28.image = UIImage.shape(.arrowCircle(.left, 4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv28)

        let iv29 = UIImageView()
        iv29.frame = iv28.frame.offsetBy(dx: iv11.jj.width + 20, dy: 0)
        iv29.image = UIImage.shape(.arrowCircleFill(.left, 4, .jRandom()), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv29)
        
        let iv30 = UIImageView()
        iv30.frame = iv27.frame.offsetBy(dx: 0, dy: iv11.jj.height + 20)
        iv30.image = UIImage.shape(.arrow(.right, 4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv30)

        let iv31 = UIImageView()
        iv31.frame = iv30.frame.offsetBy(dx: iv11.jj.width + 20, dy: 0)
        iv31.image = UIImage.shape(.arrowCircle(.right, 4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv31)
//
        let iv32 = UIImageView()
        iv32.frame = iv31.frame.offsetBy(dx: iv11.jj.width + 20, dy: 0)
        iv32.image = UIImage.shape(.arrowCircleFill(.left, 4, .jRandom()), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv32)
        
        let iv33 = UIImageView()
        iv33.frame = iv30.frame.offsetBy(dx: 0, dy: iv11.jj.height + 20)
        iv33.image = UIImage.shape(.arrow(.up, 4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv33)

        let iv34 = UIImageView()
        iv34.frame = iv33.frame.offsetBy(dx: iv11.jj.width + 20, dy: 0)
        iv34.image = UIImage.shape(.arrowCircle(.up, 4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv34)

        let iv35 = UIImageView()
        iv35.frame = iv34.frame.offsetBy(dx: iv11.jj.width + 20, dy: 0)
        iv35.image = UIImage.shape(.arrowCircleFill(.left, 4, .jRandom()), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv35)
        
        let iv36 = UIImageView()
        iv36.frame = iv33.frame.offsetBy(dx: 0, dy: iv11.jj.height + 20)
        iv36.image = UIImage.shape(.arrow(.down, 4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv36)

        let iv37 = UIImageView()
        iv37.frame = iv36.frame.offsetBy(dx: iv11.jj.width + 20, dy: 0)
        iv37.image = UIImage.shape(.arrowCircle(.down, 4), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv37)

        let iv38 = UIImageView()
        iv38.frame = iv37.frame.offsetBy(dx: iv11.jj.width + 20, dy: 0)
        iv38.image = UIImage.shape(.arrowCircleFill(.left, 4, .jRandom()), size: 40, tintColor: .jRandom())
        scrollView.addSubview(iv38)
    }
}
