//
//  CarouselTabbarController.swift
//  Demo
//
//  Created by zgjff on 2022/10/3.
//

import UIKit

/// 为了测试,选中其它selectedIndex时,暂停轮播
class CarouselTabbarController: UITabBarController, AddCloseNaviItemToDismissable {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        tabBar.tintColor = .red
        addCloseNaviItem()
        let vc1 = CarouselController()
        vc1.title = "轮播"
        
        let vc2 = UIViewController()
        vc2.title = "空白"
        viewControllers = [vc1, vc2]
    }
}
