//
//  PassParameterMixUrlAndContextController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class PassParameterMixUrlAndContextController: UIViewController, ShowMatchRouterable {
    private var parameters: [String: String] = [:]
    private var result: JJRouter.MatchResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .jRandom()
        title = "PassParameterMixUrlAndContext"
        showMatchResult(result)
    }
}

extension PassParameterMixUrlAndContextController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        guard let needShow = result.context as? Bool, needShow else {
            return
        }
        self.result = result
        parameters = result.parameters
        sourceController.navigationController?.pushViewController(self, animated: true)
    }
}
