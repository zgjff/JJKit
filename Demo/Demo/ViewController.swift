import UIKit

class ViewController: UIViewController, SwipePresentDelegate {
    
    private lazy var l = CALayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(c(_:)))
        let b = UIButton()
        b.jj.setBackgroundColor(.cyan, for: [])
        b.frame = CGRect(x: 0, y: 0, width: view.jj.width - 100, height: 50)
        b.jj.layout { make in
            make.centerY.equalTo(view).offsetBy(-100)
            make.centerX.equalTo(view)
        }
        view.addSubview(b)
        b.addTarget(self, action: #selector(bp(_:)), for: .primaryActionTriggered)
        
        l.backgroundColor = UIColor.purple.cgColor
        
        l.jj.layout { make in
            make.width.height.equalTo(30)
            make.top.equalTo(80)
        }
        l.cornerRadius = 15
        view.layer.addSublayer(l)
    }
    
    @IBAction private func c(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(SecondController(), animated: true)
    }
    
    @IBAction private func bp(_ sender: UIButton) {
//        let animator = CAKeyframeAnimation(keyPath: "position")
//        animator.duration = 1
//        let start = CGPoint(x: 15, y: 95)
//        let final = CGPoint(x: view.jj.width - 15, y: view.jj.height - 15)
//        animator.setValues(from: start, to: final, using: .BounceEaseOut)
//        l.position = final
//        l.add(animator, forKey: "lkeyframe")

        let nextVc = ThirdViewController()
        let g = AlertPresentationController(show: nextVc, from: self) { ctx in
            ctx.touchedCorverDismiss = false
            ctx.frameOfPresentedViewInContainerView = AlertPresentationContext.Default.bottomFrameOfPresentedView
            ctx.belowCoverView = AlertPresentationContext.Default.blurBelowCoverView
            ctx.willPresentAnimatorForBelowCoverView = AlertPresentationContext.Default.blurBelowCoverViewAnimator(true)
            ctx.willDismissAnimatorForBelowCoverView = AlertPresentationContext.Default.blurBelowCoverViewAnimator(false)
            ctx.transitionAnimator = AlertPresentationContext.Default.bottomTransitionAnimator
        }
        nextVc.transitioningDelegate = g
        present(nextVc, animated: true, completion: nil)
    }
}
