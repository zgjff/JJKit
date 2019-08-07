import UIKit

class ViewController: UIViewController, SwipePresentDelegate {
    
    private lazy var imageView = UIImageView()
    private lazy var label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let b = UIButton()
        b.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        b.frame = CGRect(x: 0, y: 0, width: view.jj.width - 100, height: 40)
        b.center = view.center
        b.addTarget(self, action: #selector(c(_:)), for: .primaryActionTriggered)
        view.addSubview(b)
    }
    
    @IBAction private func c(_ sender: UIButton) {
        navigationController?.pushViewController(SecondController(), animated: true)
    }
}
