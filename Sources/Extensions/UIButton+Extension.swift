import UIKit

extension JJ where Original: UIButton {
    func setBackgroundColor(_ color: UIColor, radius: CGFloat = 0, for state: UIControlState) {
        var img: UIImage?
        if radius <= 0.1 {
            img = UIImage.fromColor(color)
        } else {
            img = UIImage.fromColor(color, size: size)?.apply(radius: radius)
        }
        original.setBackgroundImage(img, for: state)
    }
}
