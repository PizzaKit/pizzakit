import UIKit

public extension UIApplication {

    class func topViewController(_ controller: UIViewController?) -> UIViewController? {

        if let root = controller as? PizzaRootPresentable {
            return topViewController((root.currentPresentable ?? root).toPresent())
        }

        if
            let navigationController = controller as? UINavigationController,
            let visible = navigationController.visibleViewController
        {
            return topViewController(visible)
        }

        if
            let tabController = controller as? UITabBarController,
            let selected = tabController.selectedViewController
        {
            return topViewController(selected)
        }

        if let presented = controller?.presentedViewController, !(presented is UISearchController) {
            return topViewController(presented)
        }

        return controller
    }

}
