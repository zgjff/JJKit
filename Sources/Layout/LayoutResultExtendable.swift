import CoreGraphics

internal struct LayoutResultExtendable {
    private var minX = Result.none
    private var maxX = Result.none
    private var centerX = Result.none
    private var width = Result.none
    
    private var minY = Result.none
    private var maxY = Result.none
    private var centerY = Result.none
    private var height = Result.none
}

private extension LayoutResultExtendable {
    enum Result {
        case none
        case value(CGFloat)
    }
    
    enum ResultError: Error {
        case reason(String)
    }
}

extension LayoutResultExtendable {
    /// 根据LayoutBuilderDescribe来设置LayoutResultExtendable对应的值
    ///
    /// - Parameter desc: 界面元素的相关描述
    mutating func setValue(with desc: LayoutBuilderDescribe) {
        switch desc.target {
        case .none:
            return
        case .point(let pt):
            configWithPointTarget(source: desc.source, target: pt, releation: desc.releation)
        case .size(let st):
            configWithSizeTarget(st, releation: desc.releation)
        case .frame(let ft):
            configWithRectTarget(source: desc.source, target: ft, releation: desc.releation)
        case .float(let ft):
            configWithCGFloat(for: desc.items, source: desc.source, target: ft, releation: desc.releation)
        }
    }
    
    private mutating  func configWithPointTarget(source: LayoutViewStyle, target: LayoutPointTargetable, releation: LayoutTargetRelation.Style) {
        let point = target.value(.center, source)
        var x = point.x
        var y = point.y
        switch releation {
        case .equal:
            break
        case .multiplied(let v):
            x *= v
            y *= v
        case let .transform(offx, offy, _, _):
            x += offx
            y += offy
        }
        centerX = .value(x)
        centerY = .value(y)
    }
    
    private mutating  func configWithSizeTarget(_ target: LayoutSizeTargetable, releation: LayoutTargetRelation.Style) {
        let size = target.value(.size)
        var w = size.width
        var h = size.height
        switch releation {
        case .equal:
            break
        case .multiplied(let v):
            w *= v
            h *= v
        case let .transform(offw, offh, _, _):
            w += offw
            h += offh
        }
        width = .value(w)
        height = .value(h)
    }
    
    private mutating  func configWithRectTarget(source: LayoutViewStyle, target: LayoutRectTargetable, releation: LayoutTargetRelation.Style) {
        let frame = target.value(.frame, source)
        var x = frame.minX
        var y = frame.minY
        var w = frame.width
        var h = frame.height
        switch releation {
        case .equal, .multiplied:
            break
        case let .transform(offx, offy, offw, offh):
            x += offx
            y += offy
            w += offw
            h += offh
        }
        minX = .value(x)
        minY = .value(y)
        width = .value(w)
        height = .value(h)
    }
    
    private mutating  func configWithCGFloat(for items: Set<LayoutItem>, source: LayoutViewStyle, target: LayoutCGFloatTargetable, releation: LayoutTargetRelation.Style) {
        if items.contains(.left) {
            minX = .value(changeItemValue(target.value(.left, source), with: releation))
        }
        if items.contains(.right) {
            maxX = .value(changeItemValue(target.value(.right, source), with: releation))
        }
        if items.contains(.centerX) {
            centerX = .value(changeItemValue(target.value(.centerX, source), with: releation))
        }
        if items.contains(.top) {
            minY = .value(changeItemValue(target.value(.top, source), with: releation))
        }
        if items.contains(.bottom) {
            maxY = .value(changeItemValue(target.value(.bottom, source), with: releation))
        }
        if items.contains(.centerY) {
            centerY = .value(changeItemValue(target.value(.centerY, source), with: releation))
        }
        if items.contains(.width) {
            let w = changeItemValue(target.value(.width, source), with: releation)
            if w < 0 {
                fatalError("👿👿👿: width不能小于0")
            } else {
                width = .value(w)
            }
        }
        if items.contains(.height) {
            let h = changeItemValue(target.value(.height, source), with: releation)
            if h < 0 {
                fatalError("👿👿👿: height不能小于0")
            } else {
                height = .value(h)
            }
        }
    }
    
    private func changeItemValue(_ value: CGFloat, with releation: LayoutTargetRelation.Style) -> CGFloat {
        switch releation {
        case .equal:
            return value
        case .multiplied(let v):
            return value * v
        case .transform(let off, _, _, _):
            return value + off
        }
    }
}

extension LayoutResultExtendable {
    /// 构建LayoutResult
    ///
    /// - Parameters:
    ///   - originalSize: 界面的原始size大小,为了解决单独设置某些item时，无法确定LayoutResult
    ///
    ///   - 比如:设置有关x和width方便时,只设定right或者centerX,无法确定最终的frame,需要借助于原始size
    ///   - 再比如:设置有关y和height方便时,只设定bottom或者centerY,无法确定最终的frame,需要借助于原始size
    ///
    ///   - callFrom: 最初调用到此函数所在的文件及类型----调用layout(builder: )所在位置
    mutating func frameResultWith(originalSize: CGSize, from callFrom: (String, Int)) -> LayoutResult {
        var result = LayoutResult()
        do {
            try determineXAndWidth(with: originalSize, for: &result)
            try determineYAndHeight(with: originalSize, for: &result)
        } catch ResultError.reason(let err) {
            let filestr = callFrom.0.split(separator: "/").last ?? ""
            fatalError("👿👿👿👿👿\(filestr):\(callFrom.1)👿👿👿👿👿 \(err)👿👿👿👿👿")
        } catch {}
        return result
    }
    
    private mutating func determineXAndWidth(with originalSize: CGSize, for result: inout LayoutResult) throws {
        switch (minX, centerX, maxX, width) {
        case (.none, .none, .none, .none):
            return
        case let (.none, .none, .none, .value(w)):
            result.setWidth(w)
        case let (.none, .none, .value(ax), .value(w)):
            result.setWidth(w)
            result.setX(ax - w)
        case let (.none, .value(cx), .value(ax), .value(w)):
            let xx = cx + w * 0.5
            if xx != ax {
                throw ResultError.reason("同时设定的[centerX, .width, .right]有冲突")
            }
            result.setWidth(w)
            result.setX(ax - w)
        case let (.none, .none, .value(ax), .none):
            result.setX(ax - originalSize.width)
        case let (.none, .value(cx), .none, .none):
            result.setX(cx - originalSize.width * 0.5)
        case let (.none, .value(cx), .value(ax), .none):
            if ax < cx {
                throw ResultError.reason("同时设定【right, centerX]时right不能小于centerX")
            }
            result.setWidth((ax - cx) * 2)
            result.setX(cx * 2 - ax)
        case let (.none, .value(cx), .none, .value(w)):
            result.setWidth(w)
            result.setX(cx - w * 0.5)
        case let (.value(ix), .value(cx), .value(ax), .value(w)):
            if (w != (ax - ix)) {
                throw ResultError.reason("同时设定的[width, left, right]有冲突")
            }
            if (cx * 2 != (ax + ix)) {
                throw ResultError.reason("同时设定的[centerX, left, right]有冲突")
            }
            result.setX(ix)
            result.setWidth(w)
        case let (.value(ix), .value(cx), .value(ax), .none):
            if (cx * 2 != (ax + ix)) {
                throw ResultError.reason("同时设定的[centerX, left, right]有冲突")
            }
            result.setX(ix)
            result.setWidth(ax - ix)
        case let (.value(ix), .value(cx), .none, .value(w)):
            if cx < ix {
                throw ResultError.reason("同时设定的[centerX, left]时,centerX不能小于left")
            }
            if (w != (cx - ix) * 2) {
                throw ResultError.reason("同时设定的[centerX, left, wdith]有冲突")
            }
            result.setX(ix)
            result.setWidth(w)
        case let (.value(ix), .value(cx), .none, .none):
            if cx < ix {
                throw ResultError.reason("同时设定的[centerX, left]时,centerX不能小于left")
            }
            result.setX(ix)
            result.setWidth((cx - ix) * 2)
        case let (.value(ix), .none, .value(ax), .value(w)):
            if (w != (ax - ix)) {
                throw ResultError.reason("同时设定的[width, left, right]有冲突")
            }
            result.setX(ix)
            result.setWidth(w)
        case let (.value(ix), .none, .none, .none):
            result.setX(ix)
        case let (.value(ix), .none, .value(ax), .none):
            if ax < ix {
                throw ResultError.reason("同时设定的[right, left]时,right不能小于left")
            }
            result.setX(ix)
            result.setWidth(ax - ix)
        case let (.value(ix), .none, .none, .value(w)):
            result.setWidth(w)
            result.setX(ix)
        }
    }
    
    private mutating func determineYAndHeight(with originalSize: CGSize, for result: inout LayoutResult) throws {
        switch (minY, centerY, maxY, height) {
        case (.none, .none, .none, .none):
            return
        case let (.none, .none, .none, .value(h)):
            result.setHeight(h)
        case let (.none, .none, .value(ay), .value(h)):
            result.setHeight(h)
            result.setY(ay - h)
        case let (.none, .value(cy), .value(ay), .value(h)):
            let yy = cy + h * 0.5
            if yy != ay {
                throw ResultError.reason("同时设定的[centerY, .height, .bottom]有冲突")
            }
            result.setHeight(h)
            result.setY(ay - h)
        case let (.none, .none, .value(ay), .none):
            result.setY(ay - originalSize.height)
        case let (.none, .value(cy), .none, .none):
            result.setY(cy - originalSize.height * 0.5)
        case let (.none, .value(cy), .value(ay), .none):
            if ay < cy {
                throw ResultError.reason("同时设定[bottom, centerY]时right不能小于centerX")
            }
            result.setHeight((ay - cy) * 2)
            result.setY(cy * 2 - ay)
        case let (.none, .value(cy), .none, .value(h)):
            result.setHeight(h)
            result.setY(cy - h * 0.5)
        case let (.value(iy), .value(cy), .value(ay), .value(h)):
            if (h != (ay - iy)) {
                throw ResultError.reason("同时设定的[height, top, bottom]有冲突")
            }
            if (cy * 2 != (ay + iy)) {
                throw ResultError.reason("同时设定的[centerY, top, bottom]有冲突")
            }
            result.setY(iy)
            result.setHeight(h)
        case let (.value(iy), .value(cy), .value(ay), .none):
            if (cy * 2 != (ay + iy)) {
                throw ResultError.reason("同时设定的[centerY, top, bottom]有冲突")
            }
            result.setY(iy)
            result.setHeight(ay - iy)
        case let (.value(iy), .value(cy), .none, .value(h)):
            if (cy < iy) {
                throw ResultError.reason("同时设定的[centerY, top]时,centerY不能小于top")
            }
            if (h != (cy - iy) * 2) {
                throw ResultError.reason("同时设定的[centerY, top, height]有冲突")
            }
            result.setY(iy)
            result.setHeight(h)
        case let (.value(iy), .value(cy), .none, .none):
            if (cy < iy) {
                throw ResultError.reason("同时设定的[centerY, top]时,centerY不能小于top")
            }
            result.setY(iy)
            result.setHeight((cy - iy) * 2)
        case let (.value(iy), .none, .value(ay), .value(h)):
            if (h != (ay - iy)) {
                throw ResultError.reason("同时设定的[height, top, bottom]有冲突")
            }
            result.setY(iy)
            result.setHeight(h)
        case let (.value(iy), .none, .none, .none):
            result.setY(iy)
        case let (.value(iy), .none, .value(ay), .none):
            if ay < iy {
                throw ResultError.reason("同时设定的[top, bottom]时,bottom不能小于top")
            }
            result.setY(iy)
            result.setHeight(ay - iy)
        case let (.value(iy), .none, .none, .value(h)):
            result.setHeight(h)
            result.setY(iy)
        }
    }
}
