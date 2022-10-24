//
//  HelpForHashController.swift
//  Demo
//
//  Created by zgjff on 2022/10/24.
//

import UIKit

/// hash路由
class HelpForHashController: UIViewController, ShowMatchRouterable {
    private var result: JJRouter.MatchResult?
}

extension HelpForHashController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        self.result = result
        sourceController.navigationController?.pushViewController(self, animated: true)
    }
}

extension HelpForHashController {
    override func viewDidLoad() {
        title = "匹配Hash路由"
        view.backgroundColor = .jRandom()
        showMatchResult(result)
    }
}
