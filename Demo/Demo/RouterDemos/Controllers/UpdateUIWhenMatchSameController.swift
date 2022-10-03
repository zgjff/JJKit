//
//  UpdateUIWhenMatchSameController.swift
//  Demo
//
//  Created by zgjff on 2022/7/30.
//

import UIKit

class UpdateUIWhenMatchSameController: UIViewController, ShowMatchRouterable {
    private var pid = 0
    private var result: JJRouter.MatchResult?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UpdateUIWhenMatchSame \(pid)"
        view.backgroundColor = .jRandom()
        let b = UIButton()
        b.backgroundColor = .jRandom()
        b.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 160, height: 44)
        b.center = view.center
        b.addTarget(self, action: #selector(onClick), for: .primaryActionTriggered)
        view.addSubview(b)
        showMatchResult(result)
    }
    
    @IBAction private func onClick() {
        let pid = Int.random(in: 1..<1000)
        (try? JJRouter.default.open("/app/updateUIMatchedSame/\(pid)"))?.jump(from: self)
    }
}

extension UpdateUIWhenMatchSameController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        self.result = result
        pid = parseId(from: result.parameters)
        let navi = UINavigationController(rootViewController: self)
        sourceController.present(navi, animated: true)
    }
    
    func actionWhenMatchedRouterDestinationSameToCurrent(withNewMatchRouterResult result: JJRouter.MatchResult) -> JJRouter.MatchedSameRouterDestinationAction {
        return .update
    }
    
    func updateWhenRouterIdentifierIsSame(withNewMatchRouterResult result: JJRouter.MatchResult) {
        pid = parseId(from: result.parameters)
        title = "UpdateUIWhenMatchSame \(pid)"
        view.subviews.filter({ $0 is UILabel}).first?.removeFromSuperview()
        showMatchResult(result)
    }
    
    private func parseId(from parameters: [String: String]) -> Int {
        let idstr = parameters["id"] ?? ""
        let numberFormatter = NumberFormatter()
        let id = numberFormatter.number(from: idstr)?.intValue
        return id ?? 0
    }
}
