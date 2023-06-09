//
//  SystemPushController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class SystemPushController: UIViewController, ShowMatchRouterable, JJRouterDestination {

    private var result: JJRouter.MatchResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "System Push"
        view.backgroundColor = .jRandom()
        showMatchResult(result)
    }
}
