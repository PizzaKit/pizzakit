import UIKit

public extension UIStackView {

    /// Method for adding multiple arrange subviews at once
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach { addArrangedSubview($0) }
    }

    /// Method for removing all arranged subviews
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}
