//
//  MapBlockController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class MapBlockController: UIViewController, ShowMatchRouterable {
    private var result: JJRouter.MatchResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "映射"
        view.backgroundColor = .jRandom()
        showMatchResult(result)
    }
}

extension MapBlockController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        self.result = result
        sourceController.present(self, animated: true)
    }
}
