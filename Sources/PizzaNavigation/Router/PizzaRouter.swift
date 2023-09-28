import PizzaCore

/// Protocol for describing router entity
public protocol PizzaRouter {
    /// Returns topmost presentable controller.
    /// Topmost as a rule means deepest controller in hierarchy.
    func top() -> PizzaPresentable?
    /// Returns root presentable controller.
    /// Root controller means that controller, that nested in window.
    func root() -> PizzaPresentable?

    /// Method for presenting new presentable over topmost
    func present(
        module: PizzaPresentable?,
        animated: Bool,
        completion: PizzaEmptyClosure?
    )
    /// Method for dismissing current presentable
    func dismiss(
        animated: Bool,
        completion: PizzaEmptyClosure?
    )

    /// Method for pushing new presentable inside topmost navigation
    func push(module: PizzaPresentable?, animated: Bool)
    /// Method for popping presentable from topmost navigation
    func popModule(animated: Bool, completion: PizzaEmptyClosure?)
    /// Method for popping up to root at topmost navigation
    func popToRoot(animated: Bool)
    /// Method for dismissing all popups and popping up to root
    func dismissAndPopToRoot()
    /// Method for dismissing all
    func dismissToRoot(completion: PizzaEmptyClosure?)

    /// Method for settings root presentable
    func setRoot(
        module: PizzaPresentable?,
        animated: Bool,
        completion: PizzaEmptyClosure?
    )
    /// Method for setting root for topmost navigation
    func setNavigationRoot(module: PizzaPresentable?)
}

public extension PizzaRouter {

    func present(
        module: PizzaPresentable?,
        animated: Bool
    ) {
        present(
            module: module,
            animated: animated,
            completion: nil
        )
    }

    func present(
        module: PizzaPresentable?
    ) {
        present(
            module: module,
            animated: true,
            completion: nil
        )
    }

    func dismiss(
        animated: Bool
    ) {
        dismiss(
            animated: animated,
            completion: nil
        )
    }

    func dismiss() {
        dismiss(animated: true, completion: nil)
    }

    func push(module: PizzaPresentable?) {
        push(module: module, animated: true)
    }

    func popModule() {
        popModule(animated: true, completion: nil)
    }

    func popToRoot() {
        popToRoot(animated: true)
    }

    func dismissToRoot() {
        dismissToRoot(completion: nil)
    }

    func setRoot(
        module: PizzaPresentable?,
        animated: Bool
    ) {
        setRoot(module: module, animated: animated, completion: nil)
    }

    func setRoot(
        module: PizzaPresentable?
    ) {
        setRoot(module: module, animated: true, completion: nil)
    }

}
