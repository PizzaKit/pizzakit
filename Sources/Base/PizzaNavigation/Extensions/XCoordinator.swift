import UIKit
import XCoordinator
import PizzaCore

public extension Transition {

    static func presentFullScreen(_ presentable: Presentable, animation: Animation? = nil) -> Transition {
        presentable.viewController?.modalPresentationStyle = .fullScreen
        return .present(presentable, animation: animation)
    }

    static func dismissAll() -> Transition {
        return Transition(presentables: [], animationInUse: nil) { rootViewController, options, completion in
            guard let presentedViewController = rootViewController.presentedViewController else {
                completion?()
                return
            }
            presentedViewController.dismiss(animated: options.animated) {
                Transition.dismissAll()
                    .perform(on: rootViewController, with: options, completion: completion)
            }
        }
    }

}

extension XCoordinator.Transition where RootViewController: PizzaRootViewController {

    public static func pizzaRoot(
        _ presentable: Presentable,
        animated: Bool
    ) -> XCoordinator.Transition<RootViewController> {
        Transition(
            presentables: [presentable],
            animationInUse: nil
        ) { rootViewController, options, completion in
            rootViewController.setCurrentPresentable(
                presentable.viewController,
                animated: animated,
                completion: {
                    presentable.presented(from: rootViewController)
                    completion?()
                }
            )
        }
    }

}
