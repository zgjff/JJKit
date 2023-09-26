//
//  IdeaController.swift
//  Demo
//
//  Created by zgjff on 2022/10/25.
//

import UIKit
/// 想法、思路演示
class IdeaController: UIViewController {
    
    deinit {
        print("IdeaController   deinit")
    }
}

extension IdeaController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        let navi = UINavigationController(rootViewController: self)
        navi.modalPresentationStyle = .fullScreen
        sourceController.present(navi, animated: true)
    }
}

extension IdeaController: AddCloseNaviItemToDismissable {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Idea"
        view.backgroundColor = .jRandom()
        addCloseNaviItem()
        
        let b = UIButton()
        b.backgroundColor = .jRandom()
        b.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        b.center = view.center
        view.addSubview(b)
        b.jj.handler({ [unowned self] _ in
            self.startShow()
        }, for: .primaryActionTriggered)
        
        let c = UIButton()
        c.backgroundColor = .jRandom()
        c.frame = b.frame.offsetBy(dx: 0, dy: 80)
        view.addSubview(c)
        c.jj.handler({  _ in
            
        }, for: .primaryActionTriggered)
    }
    
    func startShow() {
        
    }
}
