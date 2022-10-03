//
//  PassParameterByUrlWithQueryController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class PassParameterByUrlWithQueryController: UIViewController, ShowMatchRouterable {
    private var parameters: [String: String] = [:]
    private var result: JJRouter.MatchResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .jRandom()
        title = "PassParameterByUrlWithQuery"
        showMatchResult(result)
    }
}

extension PassParameterByUrlWithQueryController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        self.result = result
        parameters = result.parameters
        sourceController.navigationController?.pushViewController(self, animated: true)
    }
}
