//
//  IdeaController.swift
//  Demo
//
//  Created by zgjff on 2022/10/25.
//

import UIKit
/// 想法、思路演示
class IdeaController: UIViewController {
    private lazy var textView = UITextView()
}

extension IdeaController: JJRouterDestination {
    func showDetail(withMatchRouterResult result: JJRouter.MatchResult, from sourceController: UIViewController) {
        let navi = UINavigationController(rootViewController: self)
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
    
        textView.frame = CGRect(x: 30, y: 80, width: 300, height: 50)
        textView.delegate = self
        view.addSubview(textView)
    }
     
    func startShow() {
        
    }
}
