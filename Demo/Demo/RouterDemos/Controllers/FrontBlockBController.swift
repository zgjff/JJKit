//
//  FrontBlockBController.swift
//  Demo
//
//  Created by zgjff on 2022/7/29.
//

import UIKit

class FrontBlockBController: UIViewController, ShowMatchRouterable {
    private var router: JJRouter.MatchResult?
    private lazy var button = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "B"
        view.backgroundColor = .jRandom()
        button.backgroundColor = .jRandom()
        button.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 160, height: 44)
        button.center = view.center
        button.addTarget(self, action: #selector(onClick), for: .primaryActionTriggered)
        view.addSubview(button)
        showMatchResult(router)
    }
    
    @IBAction private func onClick() {
        let block: (Int) -> () = { [weak self] data in
            self?.button.setTitle("\(data)", for: [])
        }
        router?.perform(blockName: "onNeedGetNewestData", withObject: block)
    }
}

extension FrontBlockBController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        router = result
        sourceController.navigationController?.pushViewController(self, animated: true)
    }
}
