//
//  SecondViewController.swift
//  Demo
//
//  Created by 123 on 2018/10/15.
//  Copyright © 2018 郑桂杰. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, SwipePresentDelegate {

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 70)
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 0
       let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .white
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        collectionView.frame = view.bounds
        view.addSubview(collectionView)
        
        collectionView.registerCell(Cell.self)
        collectionView.registerSupplementaryView(Re.self, forkind: .header)
        
        collectionView.jj.dataSourceDelegate?
            .numberOfSections({ () -> Int in
                return 2
            })
        .numberOfItemsInSection({ section -> Int in
            switch section {
            case 0: return 5
            case 1: return 30
            default: return 0
            }
        })
            .cellForItem({ (c, ip) -> UICollectionViewCell in
                let c: Cell = c.dequeueReusableCell(for: ip)
                return c
            })
            .viewForSupplementaryElement({ (c, k, ip) -> UICollectionReusableView? in
                if ip.section == 0 {
                    return UICollectionReusableView()
                }
                let cv: Re = c.dequeueSupplementaryView(for: k, indexPath: ip)
                return cv
            })
            .referenceSizeForHeader({ (c, s) -> CGSize in
                if s == 0 {
                    return .zero
                }
                return CGSize(width: UIScreen.main.bounds.height, height: 40)
            })
//            .sizeForItem({ (_, ip) -> CGSize in
//                switch ip.section {
//                case 0: return CGSize(width: UIScreen.main.bounds.width, height: <#T##CGFloat#>)
//                }
//            })
        
        .bind()
    }
    deinit {
        print("&SecondViewController deinit")
    }
}

class Cell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Re: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
