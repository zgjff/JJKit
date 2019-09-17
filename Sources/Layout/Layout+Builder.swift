import Foundation

extension JJLayout {
    public class Builder {
        internal let view: JJLayout.ViewStyle
        internal var describes: [JJLayout.Builder.Describe] = []
        internal init(style: JJLayout.ViewStyle) {
            self.view = style
        }
    }
}

public extension JJLayout.Builder {
    var width: JJLayout.Builder.Extendable.CGFloat {
        return newBuilder(for: .width)
    }
    var height: JJLayout.Builder.Extendable.CGFloat {
        return newBuilder(for: .height)
    }
    var top: JJLayout.Builder.Extendable.CGFloat {
        return newBuilder(for: .top)
    }
    var left: JJLayout.Builder.Extendable.CGFloat {
        return newBuilder(for: .left)
    }
    var right: JJLayout.Builder.Extendable.CGFloat {
        return newBuilder(for: .right)
    }
    var bottom: JJLayout.Builder.Extendable.CGFloat {
        return newBuilder(for: .bottom)
    }
    var centerX: JJLayout.Builder.Extendable.CGFloat {
        return newBuilder(for: .centerX)
    }
    var centerY: JJLayout.Builder.Extendable.CGFloat {
        return newBuilder(for: .centerY)
    }
    var center: JJLayout.Builder.Extendable.Point {
        return newBuilder(for: .center)
    }
    var size: JJLayout.Builder.Extendable.Size {
        return newBuilder(for: .size)
    }
    var edges: JJLayout.Builder.Extendable.Rect {
        return newBuilder(for: .frame)
    }
}

extension JJLayout.Builder {
    internal func build(from callFrom: (String, Int)) {
        guard !describes.isEmpty else { return }
        var resultex = JJLayout.Result.Extendable()
        var iter = describes.makeIterator()
        while let desc = iter.next() {
            resultex.setValue(with: desc)
        }
        let result = resultex.frameResultWith(originalSize: view.size, from: callFrom)
        result.calculateFrame(for: view)
    }
    
    private func newBuilder<T>(for item: JJLayout.Item) -> T where T: JJLayout.Builder.Extendable {
        let builder = T.init(view: view, item: item)
        describes.append(builder.describe)
        return builder
    }
}
