import UIKit

public extension NSDirectionalEdgeInsets {

    /// Initialization with horizontal and vertical
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(
            top: vertical,
            leading: horizontal,
            bottom: vertical,
            trailing: horizontal
        )
    }

    /// Initialization with side value
    init(side: CGFloat) {
        self.init(
            top: side, 
            leading: side, 
            bottom: side, 
            trailing: side
        )
    }

    init(insets: NSDirectionalEdgeInsets, multiplier: CGFloat) {
        self.init(
            top: insets.top * multiplier,
            leading: insets.leading * multiplier,
            bottom: insets.bottom * multiplier,
            trailing: insets.trailing * multiplier
        )
    }

    func convertToUIEdgeInsets() -> UIEdgeInsets {
        let direction = UIApplication.shared.userInterfaceLayoutDirection
        return .init(
            top: top,
            left: direction == .leftToRight ? leading : trailing,
            bottom: bottom,
            right: direction == .leftToRight ? trailing : leading
        )
    }

}
