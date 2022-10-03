//
//  PassParameterByUrlController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class PassParameterByUrlController: UIViewController, ShowMatchRouterable {
    private var result: JJRouter.MatchResult?
    private var parameters: [String: String] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PassParameterByUrl"
        view.backgroundColor = .jRandom()
        print("parameters: ", parameters)
        showMatchResult(result)
    }
}

extension PassParameterByUrlController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        self.result = result
        parameters = result.parameters
        sourceController.navigationController?.pushViewController(self, animated: true)
    }
}
