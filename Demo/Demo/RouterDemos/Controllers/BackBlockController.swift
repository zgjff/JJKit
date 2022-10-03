//
//  BackBlockController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class BackBlockController: UIViewController, ShowMatchRouterable {
    private var router: JJRouter.MatchResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .jRandom()
        title = "back block"
        let b = UIButton()
        b.backgroundColor = .jRandom()
        b.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 160, height: 44)
        b.center = view.center
        b.addTarget(self, action: #selector(onClick), for: .primaryActionTriggered)
        view.addSubview(b)
        showMatchResult(router)
    }
    
    @IBAction private func onClick() {
        dismiss(animated: true) { [weak self] in
            self?.router?.perform(blockName: "onSend", withObject: 5)
        }
    }
}

extension BackBlockController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        router = result
        sourceController.present(self, animated: true)
    }
}
