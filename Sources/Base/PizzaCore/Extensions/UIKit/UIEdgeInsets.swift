import UIKit

public extension UIEdgeInsets {

    /// Initialization with horizontal and vertical
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }

    /// Initialization with side value
    init(side: CGFloat) {
        self.init(top: side, left: side, bottom: side, right: side)
    }

}
