import CoreGraphics

public extension CGRect {

    /// Method for setting `maxX`
    mutating func setMaxX(_ value: CGFloat) {
        origin.x = value - width
    }

    /// Method for setting `maxY`
    mutating func setMaxY(_ value: CGFloat) {
        origin.y = value - height
    }

    /// Method for setting width
    mutating func setWidth(_ width: CGFloat) {
        if width == self.width { return }
        self = CGRect.init(x: origin.x, y: origin.y, width: width, height: height)
    }

    /// Method for setting height
    mutating func setHeight(_ height: CGFloat) {
        if height == self.height { return }
        self = CGRect.init(x: origin.x, y: origin.y, width: width, height: height)
    }

    /// Initialization with given center and size
    init(center: CGPoint, size: CGSize) {
        let origin = CGPoint(
            x: center.x - size.width / 2.0,
            y: center.y - size.height / 2.0
        )
        self.init(origin: origin, size: size)
    }

}
