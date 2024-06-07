import UIKit
import SnapKit

public extension UIStackView {

    /// Method for adding multiple arrange subviews at once
    func addArrangedSubviews(_ subviews: [UIView]) {
        subviews.forEach { addArrangedSubview($0) }
    }

    /// Method for removing all arranged subviews
    func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    func addSeparator(height: CGFloat) {
        addArrangedSubview(UIView().do {
            $0.snp.makeConstraints { make in
                make.height.equalTo(height)
            }
        })
    }

    func addSeparator(width: CGFloat) {
        addArrangedSubview(UIView().do {
            $0.snp.makeConstraints { make in
                make.width.equalTo(width)
            }
        })
    }

}
