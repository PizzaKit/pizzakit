import PizzaCore

public protocol PresentedAnchor {
    func dismiss(animated: Bool, completion: PizzaEmptyClosure?)
}

public extension PresentedAnchor {
    func dismiss(animated: Bool) {
        dismiss(animated: animated, completion: nil)
    }
}

public extension PresentedAnchor {
    func dismiss() {
        dismiss(animated: true, completion: nil)
    }
}

class _PresentedAnchorImpl: PresentedAnchor {
    let onNeedDismiss: PizzaClosure<(animated: Bool, completion: PizzaEmptyClosure?)>?
    init(
        onNeedDismiss: PizzaClosure<(animated: Bool, completion: PizzaEmptyClosure?)>?
    ) {
        self.onNeedDismiss = onNeedDismiss
    }
    func dismiss(animated: Bool, completion: PizzaEmptyClosure?) {
        onNeedDismiss?((animated: animated, completion: completion))
    }
}
