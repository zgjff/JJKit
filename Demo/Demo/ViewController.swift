import UIKit

class ViewController: UIViewController, SwipePresentDelegate {
    
    private lazy var l = CALayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(c(_:)))
        let b = UIButton()
        b.backgroundColor = UIColor.cyan
        b.jj.layout { make in
            make.width.equalTo(view).offsetBy(-100)
            make.height.equalTo(50)
            make.center.equalTo(view)
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
        print(l.position)
    }
    
    @IBAction private func c(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(SecondController(), animated: true)
    }
    
    @IBAction private func bp(_ sender: UIButton) {
        let animator = CAKeyframeAnimation(keyPath: "position")
        animator.duration = 2
        let start = CGPoint(x: 15, y: 95)
        let final = CGPoint(x: view.jj.width - 15, y: view.jj.height - 15)
        animator.setValues(from: start, to: final, using: .SineEaseInOut)
        l.position = final
        l.add(animator, forKey: "lkeyframe")
        
//        animator.setValues(from: 0, to: 100, using: .easeInOutBack)
    }
}
