import CoreGraphics

public extension CGAffineTransform {

    /// Initialization with given scale for both dimensions
    init(scale: CGFloat) {
        self.init(scaleX: scale, y: scale)
    }
}
