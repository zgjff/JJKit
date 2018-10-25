import UIKit

extension JJ where Original: UIButton {
    public func setBackgroundColor(_ color: UIColor, radius: CGFloat = 0, for state: UIControl.State) {
        var img: UIImage?
        if radius <= 1 {
            img = UIImage(color: color)
        } else {
            img = UIImage(color: color, size: size)?.jj.apply(radius: radius)
        }
        original.setBackgroundImage(img, for: state)
    }
}
