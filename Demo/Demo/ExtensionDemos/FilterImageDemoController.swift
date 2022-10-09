//
//  FilterImageDemoController.swift
//  Demo
//
//  Created by zgjff on 2022/10/8.
//

import UIKit

class FilterImageDemoController: UIViewController {
    private lazy var originalImage = UIImage(named: "a-3.jpeg")!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension FilterImageDemoController {
    func setup() {
        title = "滤镜"
        view.backgroundColor = .jRandom()
        
        let originalImageView = UIImageView()
        originalImageView.image = originalImage
        originalImageView.backgroundColor = .jRandom()
        originalImageView.frame = CGRect(x: view.jj.width * 0.5 - 100, y: 100, width: 200, height: originalImage.size.height * 200 / originalImage.size.width)
        view.addSubview(originalImageView)
        
        let filterImageView = UIImageView()
        filterImageView.frame = originalImageView.frame.offsetBy(dx: 0, dy: originalImageView.jj.height + 30)
        DispatchQueue.global().async {
            let img = self.originalImage.jj.applyFilter(UIImage.JJFilter.colorInvert)
            DispatchQueue.main.async {
                filterImageView.image = img
            }
        }
        view.addSubview(filterImageView)
        
        var qrImageView = UIImageView()
        qrImageView.jj.size = CGSize(width: 200, height: 200)
        qrImageView.jj.centerX = filterImageView.jj.centerX
        qrImageView.jj.top = filterImageView.jj.bottom + 40
        qrImageView.backgroundColor = .jRandom()
        DispatchQueue.global().async {
            let data = "FilterImageDemoController".data(using: .utf8)!
            let img = self.originalImage.jj.applyFilter(UIImage.JJFilter.qrGenerator(data)(.h, 200))
            DispatchQueue.main.async {
                qrImageView.image = img
            }
        }
        view.addSubview(qrImageView)
    }
}
