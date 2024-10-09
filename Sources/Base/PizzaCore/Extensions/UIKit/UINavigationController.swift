import UIKit

public extension UINavigationController {

    /// Method for popping view controller with completion
    func popViewController(
        animated: Bool = true,
        _ completion: PizzaEmptyClosure?
    ) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }

    /// Method for pushing view controller with completion
    func pushViewController(
        _ viewController: UIViewController,
        completion: PizzaEmptyClosure?
    ) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: true)
        CATransaction.commit()
    }
}
