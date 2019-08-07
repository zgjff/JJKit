import Foundation

public class LayoutBuilder {
    internal let view: LayoutViewStyle
    internal var describes: [LayoutBuilderDescribe] = []
    internal init(style: LayoutViewStyle) {
        self.view = style
    }
}

public extension LayoutBuilder {
    var width: LayoutCGFloatBuilder {
        return newBuilder(for: .width)
    }
    var height: LayoutCGFloatBuilder {
        return newBuilder(for: .height)
    }
    var top: LayoutCGFloatBuilder {
        return newBuilder(for: .top)
    }
    var left: LayoutCGFloatBuilder {
        return newBuilder(for: .left)
    }
    var right: LayoutCGFloatBuilder {
        return newBuilder(for: .right)
    }
    var bottom: LayoutCGFloatBuilder {
        return newBuilder(for: .bottom)
    }
    var centerX: LayoutCGFloatBuilder {
        return newBuilder(for: .centerX)
    }
    var centerY: LayoutCGFloatBuilder {
        return newBuilder(for: .centerY)
    }
    var center: LayoutBuilderPoint {
        return newBuilder(for: .center)
    }
    var size: LayoutBuilderSize {
        return newBuilder(for: .size)
    }
    var edges: LayoutBuilderRect {
        return newBuilder(for: .frame)
    }
}

extension LayoutBuilder {
    internal func build(from callFrom: (String, Int)) {
        guard !describes.isEmpty else { return }
        var resultex = LayoutResultExtendable()
        var iter = describes.makeIterator()
        while let desc = iter.next() {
            resultex.setValue(with: desc)
        }
        let result = resultex.frameResultWith(originalSize: view.size, from: callFrom)
        result.calculateFrame(for: view)
    }
    
    private func newBuilder<T>(for item: LayoutItem) -> T where T: LayoutBuilderExtendable {
        let builder = T.init(view: view, item: item)
        describes.append(builder.describe)
        return builder
    }
}
