import CoreGraphics

public extension CGSize {

    /// Constant with both width and height set to 1
    static var one: CGSize {
        return .init(side: 1)
    }

    /// Initialization with side value
    init(side: CGFloat) {
        self.init(width: side, height: side)
    }

    /// Returns aspect ratio `width/height`
    var aspectRatio: CGFloat {
        guard height != 0 else { return 0 }
        return width / height
    }

    /// Returns max value between width and height
    var maxDimension: CGFloat {
        return max(width, height)
    }

    /// Returns min value between width and height
    var minDimension: CGFloat {
        return min(width, height)
    }

}
