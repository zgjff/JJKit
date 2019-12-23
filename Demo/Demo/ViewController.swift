import UIKit

class ViewController: UIViewController, SwipePresentDelegate {
    
    private lazy var l = CALayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(c(_:)))
        let b = UIButton()
        b.jj.setBackgroundColor(.cyan, for: [])
        b.jj.layout { make in
            make.height.equalTo(50)
            make.width.equalTo(view).offsetBy(-100)
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
    }
    
    @IBAction private func c(_ sender: UIBarButtonItem) {
        self.navigationController?.pushViewController(SecondController(), animated: true)
    }
    
    @IBAction private func bp(_ sender: UIButton) {
        let filter = CIFilter(name: "CIColorBlendMode")!
        print(filter.attributes)
    }
}
