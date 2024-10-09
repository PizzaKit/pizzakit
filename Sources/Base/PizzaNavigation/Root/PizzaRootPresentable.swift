import PizzaCore

public protocol PizzaRootPresentable: PizzaPresentable {
    /// Current presentable item
    var currentPresentable: PizzaPresentable? { get }

    /// Method for settings new presentable
    /// (first time must be called without animation)
    func setCurrentPresentable(
        _ presentable: PizzaPresentable,
        animated: Bool,
        completion: PizzaEmptyClosure?
    )
}
