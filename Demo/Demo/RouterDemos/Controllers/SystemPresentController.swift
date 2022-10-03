//
//  SystemPresentController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class SystemPresentController: UIViewController, ShowMatchRouterable {

    private var result: JJRouter.MatchResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SystemPresent"
        view.backgroundColor = .jRandom()
        showMatchResult(result)
    }
}

extension SystemPresentController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        self.result = result
        sourceController.present(self, animated: true)
    }
}
