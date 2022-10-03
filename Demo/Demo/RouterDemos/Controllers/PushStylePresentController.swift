//
//  PushStylePresentController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class PushStylePresentController: UIViewController, JJPushPopStylePresentDelegate, ShowMatchRouterable {
    private var result: JJRouter.MatchResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .jRandom()
        title = "PushPop Style Present"
        jj.addScreenPanGestureDismiss()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onClickClose))
        showMatchResult(result)
    }
    
    @IBAction private func onClickClose() {
        jj.popStyleDismiss(completion: nil)
    }
}

extension PushStylePresentController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        self.result = result
        let navi = UINavigationController(rootViewController: self)
        navi.modalPresentationStyle = .fullScreen
        navi.transitioningDelegate = pushPopStylePresentDelegate
        sourceController.present(navi, animated: true)
    }
}
