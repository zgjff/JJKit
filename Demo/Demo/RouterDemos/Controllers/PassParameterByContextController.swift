//
//  PassParameterByContextController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class PassParameterByContextController: UIViewController, ShowMatchRouterable {
    private var result: JJRouter.MatchResult?
    private var pid = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .jRandom()
        title = "PassParameterByContext"
        showMatchResult(result)
    }
}

extension PassParameterByContextController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        self.result = result
        if let pid = result.context as? Int {
            self.pid = pid
        }
        sourceController.navigationController?.pushViewController(self, animated: true)
    }
}
