//
//  IdeaController.swift
//  Demo
//
//  Created by zgjff on 2022/10/25.
//

import UIKit

class IdeaController: UIViewController {

    deinit {
        print("IdeaController  deinit")
    }
}

extension IdeaController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        let navi = UINavigationController(rootViewController: self)
        sourceController.present(navi, animated: true)
    }
}

extension IdeaController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Idea"
        view.backgroundColor = .jRandom()
        
        let b = UIButton()
        b.backgroundColor = .jRandom()
        b.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        b.center = view.center
        view.addSubview(b)
        b.jj.handler({ [unowned self] control in
            self.dismiss(animated: true)
        }, for: .primaryActionTriggered)
    }
}
