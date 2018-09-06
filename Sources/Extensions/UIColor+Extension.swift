import UIKit

extension UIColor {
    public convenience init?(hexString: String) {
        var hex = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        if hex.hasPrefix("#") {
            let h = hex.suffix(from: String.Index.init(encodedOffset: 1))
            hex = String(h)
        } else if hex.hasPrefix("0X") {
            let h = hex.suffix(from: String.Index.init(encodedOffset: 2))
            hex = String(h)
        }
        guard let c = Int(hex, radix: 16) else { return nil }
        switch hex.count {
        case 3: //RGB
            let r = (c >> 8 & 0xf) | (c >> 4 & 0x0f0)
            let g = (c >> 4 & 0xf) | (c & 0xf0)
            let b = ((c & 0xf) << 4) | (c & 0xf)
            self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
        case 4: //ARGB
            let r = c >> 16 & 0xff
            let g = c >> 8 & 0xff
            let b = c & 0xff
            let a = c >> 24 & 0xff
            self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 100.0)
        case 6: //RRGGBB
            let r = c >> 16 & 0xff
            let g = c >> 8 & 0xff
            let b = c & 0xff
            self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
        case 8: //RRGGBBAA
            let r = c >> 24 & 0xff
            let g = c >> 16 & 0xff
            let b = c >> 8 & 0xff
            let a = c & 0xff
            self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 100.0)
        default:
            return nil
        }
    }
}
