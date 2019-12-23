import UIKit

extension JJ where Object: UIButton {
    public func setBackgroundColor(_ color: UIColor, cornerRadius: CGFloat = 0, for state: UIControl.State) {
        var img: UIImage?
        if cornerRadius <= 1 {
            img = UIImage(color: color)
        } else {
            img = UIImage(color: color, size: size, cornerRadius: cornerRadius)
        }
        object.setBackgroundImage(img, for: state)
    }
}
