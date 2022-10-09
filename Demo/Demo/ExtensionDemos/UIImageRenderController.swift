//
//  UIImageRenderController.swift
//  Demo
//
//  Created by zgjff on 2022/10/8.
//

import UIKit

class UIImageRenderController: UITabBarController {

}

extension UIImageRenderController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        sourceController.navigationController?.pushViewController(self, animated: true)
    }
}

extension UIImageRenderController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Render Image"
        view.backgroundColor = .black
        tabBar.tintColor = .red
        
        let vc1 = ColorImageDemoController()
        vc1.tabBarItem.title = "颜色"
        vc1.tabBarItem.image = UIImage.shape(.arrow(.up, 2), size: 22, tintColor: .jRandom())
        vc1.tabBarItem.selectedImage = UIImage.shape(.arrowCircleFill(.up, 2, .jRandom()), size: 22, tintColor: .jRandom())?.withRenderingMode(.alwaysOriginal)
        
        
        let vc2 = FilterImageDemoController()
        vc2.tabBarItem.title = "滤镜"
        vc2.tabBarItem.image = UIImage.shape(.chevron(.up, 2), size: 22, tintColor: .jRandom())
        vc2.tabBarItem.selectedImage = UIImage.shape(.chevronCircleFill(.up, 2, .jRandom()), size: 22, tintColor: .jRandom())?.withRenderingMode(.alwaysOriginal)
        
        let vc3 = ShapeImageDemoController()
        vc3.tabBarItem.title = "图形"
        vc3.tabBarItem.image = UIImage.shape(.plus(2), size: 22, tintColor: .jRandom())
        vc3.tabBarItem.selectedImage = UIImage.shape(.plusCircleFill(2, .jRandom()), size: 22, tintColor: .jRandom())?.withRenderingMode(.alwaysOriginal)
        
        viewControllers = [vc1, vc2, vc3]
    }
}
