import UIKit
import PizzaCore

open class PizzaBaseRouter: PizzaRouter {

    // MARK: - Private Properties

    private var topViewController: UIViewController? {
        return UIApplication.topViewController(getWindow()?.rootViewController)
    }
    private var navigationController: UINavigationController? {
        var topController = topViewController
        if topController == nil {
            return nil
        }
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

    open func top() -> PizzaPresentable? {
        topViewController
    }

    open func root() -> PizzaPresentable? {
        getWindow()?.rootViewController as? PizzaPresentable
    }

    open func present(
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

    open func dismiss(
        animated: Bool,
        completion: PizzaEmptyClosure?
    ) {
        topViewController?.dismiss(
            animated: animated,
            completion: completion
        )
    }

    open func push(
        module: PizzaPresentable?,
        animated: Bool
    ) {
        guard let controller = module?.toPresent() else { return }
        navigationController?.pushViewController(
            controller,
            animated: animated
        )
    }

    open func popModule(animated: Bool, completion: PizzaEmptyClosure?) {
        navigationController?.popViewController(animated: animated, completion)
    }

    open func popToRoot(animated: Bool) {
        navigationController?.popToRootViewController(animated: animated)
    }

    open func dismissAndPopToRoot() {
        root()?.toPresent().dismiss(animated: true, completion: {
            self.navigationController?.popToRootViewController(animated: true)
        })
    }

    open func setRoot(
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

    open func setNavigationRoot(module: PizzaPresentable?) {
        // TODO: при handle(deeplink) вдруг произойдет, что не засеттится
        // дефолтный таббар контроллер - подумать как обойти это
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
