import UIKit
import PizzaCore

open class PizzaBaseRouter: PizzaRouter {

    // MARK: - Private Properties

    private var topViewController: UIViewController? {
        return UIApplication.topViewController(getWindow()?.rootViewController)
    }
    private var navigationController: UINavigationController? {
        var topController = topViewController
        if let topNavigation = topViewController as? UINavigationController {
            return topNavigation
        }
        while topController?.navigationController == nil {
            topController = topController?.parent ?? topController?.presentingViewController
        }
        return topController?.navigationController
    }

    public init() {}

    // MARK: - PRouter

    public func top() -> PizzaPresentable? {
        topViewController
    }

    public func root() -> PizzaPresentable? {
        getWindow()?.rootViewController as? PizzaPresentable
    }

    public func present(
        module: PizzaPresentable?,
        animated: Bool,
        completion: PizzaEmptyClosure?
    ) {
        guard let controller = module?.toPresent() else { return }
        topViewController?.present(
            controller,
            animated: animated,
            completion: completion
        )
    }

    public func dismiss(
        animated: Bool,
        completion: PizzaEmptyClosure?
    ) {
        topViewController?.dismiss(
            animated: animated,
            completion: completion
        )
    }

    public func push(
        module: PizzaPresentable?,
        animated: Bool
    ) {
        guard let controller = module?.toPresent() else { return }
        navigationController?.pushViewController(
            controller,
            animated: animated
        )
    }

    public func popModule(animated: Bool) {
        navigationController?.popViewController(animated: animated)
    }

    public func popToRoot(animated: Bool) {
        navigationController?.popToRootViewController(animated: animated)
    }

    public func setRoot(
        module: PizzaPresentable?,
        animated: Bool,
        completion: PizzaEmptyClosure?
    ) {
        /// case with custom root controller
        if
            let root = getWindow()?.rootViewController as? PizzaRootPresentable,
            let module
        {
            root.setCurrentPresentable(
                module,
                animated: animated,
                completion: completion
            )
            return
        }

        /// case when there is no custom root controller
        let keyWindow = getWindow()
        keyWindow?.rootViewController = module?.toPresent()
        keyWindow?.makeKeyAndVisible()
    }

    public func setNavigationRoot(module: PizzaPresentable?) {
        navigationController?
            .setViewControllers(
                [module?.toPresent()].compactMap { $0 },
                animated: false
            )
    }

    // MARK: - Public Methods

    open func getWindow() -> UIWindow? {
        UIApplication.keyWindow
    }

}

fileprivate extension UIApplication {

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
