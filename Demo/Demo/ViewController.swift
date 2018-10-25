import UIKit

class ViewController: UIViewController, SwipePresentDelegate {
    
    private lazy var imageView = UIImageView()
    private lazy var label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        imageView.center = view.center
        view.addSubview(imageView)
        
        label.frame = CGRect(x: 50, y: 100, width: view.bounds.width - 100, height: 50)
        label.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
        view.addSubview(label)
        
        let b = UIButton()
        b.frame = CGRect(x: 50, y: view.bounds.height - 80, width: view.bounds.width - 100, height: 50)
        b.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        view.addSubview(b)
        b.addTarget(self, action: #selector(c(_:)), for: .primaryActionTriggered)
    }
    
    @IBAction private func c(_ sender: UIButton) {
        swipePresentDelegate.targetEdge = .right
        present(UINavigationController(rootViewController: SecondViewController()), animated: true, completion: nil)
    }
}


