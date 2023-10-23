import UIKit

public extension UIView {

    /// Initialization with background color
    convenience init(backgroundColor color: UIColor) {
        self.init()
        backgroundColor = color
    }

    /// Returns nearest viewController
    var viewController: UIViewController? {
        weak var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }

    /// Method for adding multiple subviews
    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach { addSubview($0) }
    }

    /// Method for removing all subviews
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    /// Returns `UIImage` with current content of `UIView`
    var screenshot: UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    /// Method for adding shadow to view
    func addShadow(
        ofColor color: UIColor,
        radius: CGFloat,
        offset: CGSize,
        opacity: Float
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }

    func addBorder(color: UIColor, width: CGFloat) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }

    /// Method for running animation block (if needed)
    /// - Parameters:
    ///   - duration: duration of animation
    ///   - needAnimate: bool flag if need animate
    ///   - animationBlock: block with animation
    static func animateIfNeeded(
        duration: TimeInterval,
        needAnimate: Bool,
        options: UIView.AnimationOptions = [],
        animationBlock: @escaping PizzaEmptyClosure
    ) {
        if needAnimate {
            UIView.animate(
                withDuration: duration,
                delay: 0,
                options: options,
                animations: animationBlock
            )
        } else {
            animationBlock()
        }
    }

    /// Method for pinning constraints to superview
    func pinToSuperview() {
        guard let superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }

    func traverseAndFindClass<T: UIView>() -> T? {
        var currentView = self
        while let sv = currentView.superview {
            if let result = sv as? T {
                return result
            }
            currentView = sv
        }
        return nil
    }

    func onTap(completion: PizzaEmptyClosure?) {
        let tapRecogniser = ClickListener(
            target: self,
            action: #selector(onViewClicked(sender:))
        )
        tapRecogniser.onClick = completion
        isUserInteractionEnabled = completion != nil
        if let old = gestureRecognizers?.first(where: { $0 is ClickListener }) {
            self.removeGestureRecognizer(old)
        }
        self.addGestureRecognizer(tapRecogniser)
    }

    @objc
    private func onViewClicked(sender: ClickListener) {
        if let onClick = sender.onClick {
            onClick()
        }
    }

}

fileprivate class ClickListener: UITapGestureRecognizer {
    var onClick : PizzaEmptyClosure? = nil
}
