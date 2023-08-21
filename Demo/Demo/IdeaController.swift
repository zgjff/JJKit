//
//  IdeaController.swift
//  Demo
//
//  Created by zgjff on 2022/10/25.
//

import UIKit
/// 想法、思路演示
class IdeaController: UIViewController {}

extension IdeaController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        let navi = UINavigationController(rootViewController: self)
        navi.modalPresentationStyle = .fullScreen
        sourceController.present(navi, animated: true)
    }
}

extension IdeaController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.jj.shouldChangeCharactersWithReplacementString(text, range: range, maxCount: 20)
    }
}

extension IdeaController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Idea"
        view.backgroundColor = .jRandom()
        
        let b = UIButton()
        b.backgroundColor = .jRandom()
        b.frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        b.center = view.center
        view.addSubview(b)
        b.jj.handler({ [unowned self] _ in
            self.startShow()
        }, for: .primaryActionTriggered)
        
        let c = UIButton()
        c.backgroundColor = .jRandom()
        c.frame = b.frame.offsetBy(dx: 0, dy: 80)
        view.addSubview(c)
        c.jj.handler({ [unowned self] _ in
            self.dismiss(animated: true)
        }, for: .primaryActionTriggered)
    }
    
    func startShow() {

    }
}
