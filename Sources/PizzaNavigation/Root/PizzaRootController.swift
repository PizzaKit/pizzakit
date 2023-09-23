import UIKit
import PizzaCore
import PizzaDesign

public protocol PizzaRootViewControllerTransitionProvider {
    func performTransition(
        rootController: UIViewController,
        from fromViewController: UIViewController,
        to toViewController: UIViewController,
        animated: Bool,
        completion: PizzaEmptyClosure?
    )
}

open class PizzaRootViewControllerTransitionProviderFade: PizzaRootViewControllerTransitionProvider {
    public let fadeDuration: Double
    public init(fadeDuration: Double) {
        self.fadeDuration = fadeDuration
    }
    public func performTransition(
        rootController: UIViewController,
        from fromViewController: UIViewController,
        to toViewController: UIViewController,
        animated: Bool,
        completion: PizzaEmptyClosure?
    ) {
        fromViewController.willMove(toParent: nil)

        rootController.addChild(toViewController)
        rootController.view.addSubview(toViewController.view)
        toViewController.view.pinToSuperview()

        let block: PizzaClosure<Bool> = { [weak fromViewController, weak toViewController, weak rootController] _ in
            fromViewController?.view.removeFromSuperview()
            fromViewController?.removeFromParent()
            toViewController?.didMove(toParent: rootController)
            completion?()
        }

        if animated {
            toViewController.view.alpha = 0
            toViewController.view.layoutIfNeeded()
            UIView.animate(
                withDuration: fadeDuration,
                delay: 0.1,
                options: .curveEaseInOut,
                animations: {
                    toViewController.view.alpha = 1
                    fromViewController.view.alpha = 0
                },
                completion: block
            )
        } else {
            block(true)
        }
    }
}

/// Such viewController, that can display any other viewController
/// (diplaying may be with any animation, for example fade)
open class PizzaRootViewController: PizzaController, PizzaRootPresentable {

    // MARK: - PRootPresentable

    public var currentPresentable: PizzaPresentable? {
        currentViewController
    }

    public func setCurrentPresentable(
        _ presentable: PizzaPresentable,
        animated: Bool,
        completion: PizzaEmptyClosure?
    ) {
        animateFadeTransition(
            to: presentable.toPresent(),
            animated: animated,
            completion: completion
        )
    }

    // MARK: - Private Properties

    private var currentViewController: UIViewController? {
        return viewControllerNew ?? viewControllerOld
    }

    private var viewControllerNew: UIViewController?
    private var viewControllerOld: UIViewController?
    private let transitionProvider: PizzaRootViewControllerTransitionProvider

    // MARK: - Initialization

    public init(transitionProvider: PizzaRootViewControllerTransitionProvider) {
        self.transitionProvider = transitionProvider
        super.init()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController

    open override func viewDidLoad() {
        super.viewDidLoad()

        if let viewControllerOld, viewControllerOld.parent == nil {
            setInitial(viewController: viewControllerOld)
        }
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return currentViewController?.supportedInterfaceOrientations ?? .portrait
    }

    open override var childForStatusBarHidden: UIViewController? {
        return currentViewController
    }

    open override var childForStatusBarStyle: UIViewController? {
        return currentViewController
    }

    open override var childForHomeIndicatorAutoHidden: UIViewController? {
        return currentViewController
    }

    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }

    // MARK: - Methods

    // MARK: - Private Methods

    private func setInitial(viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.pinToSuperview()
        viewController.didMove(toParent: self)
    }

    private func animateFadeTransition(
        to newViewController: UIViewController,
        animated: Bool,
        completion: PizzaEmptyClosure?
    ) {
        guard isViewLoaded else {
            viewControllerOld = newViewController
            return
        }

        guard let viewControllerOld else {
            viewControllerOld = newViewController
            setInitial(viewController: newViewController)
            return
        }

        viewControllerNew = newViewController

        transitionProvider.performTransition(
            rootController: self,
            from: viewControllerOld,
            to: newViewController,
            animated: animated,
            completion: { [weak self] in
                self?.viewControllerOld = newViewController
                self?.viewControllerNew = nil
                completion?()
            }
        )
    }

}
