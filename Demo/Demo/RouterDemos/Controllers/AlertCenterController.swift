//
//  AlertCenterController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class AlertCenterController: UIViewController, ShowMatchRouterable {
    private var result: JJRouter.MatchResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .jRandom()
        preferredContentSize = CGSize(width: view.bounds.width - 100, height: 300)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        showMatchResult(result)
    }
}

extension AlertCenterController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        self.result = result
        let pd = JJAlertPresentationController(show: self, from: sourceController) { ctx in
            ctx.usingBlurBelowCoverAnimators(style: .dark)
            ctx.presentingControllerTriggerAppearLifecycle = .all
//            ctx.belowCoverView = nil
        }
        transitioningDelegate = pd
        sourceController.present(self, animated: true) {
            let _ = pd
        }
    }
}
