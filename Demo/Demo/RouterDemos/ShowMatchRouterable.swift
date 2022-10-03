//
//  ShowMatchRouterable.swift
//  Demo
//
//  Created by zgjff on 2022/8/27.
//

import UIKit

protocol ShowMatchRouterable: UIViewController {
    func showMatchResult(_ result: JJRouter.MatchResult?)
}

extension ShowMatchRouterable {
    func showMatchResult(_ result: JJRouter.MatchResult?) {
        guard let result = result else {
            return
        }
        let l = UILabel()
        l.numberOfLines = 0
        l.text = result.description
        let size = l.sizeThatFits(CGSize(width: view.bounds.width - 50, height: view.bounds.height))
        l.frame = CGRect(x: (view.frame.width - size.width) * 0.5, y: 88 , width: size.width, height: size.height)
        view.addSubview(l)
    }
}
