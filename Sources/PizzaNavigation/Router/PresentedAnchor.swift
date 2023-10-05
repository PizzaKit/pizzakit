import PizzaCore

public protocol PresentedAnchor {
    func dismiss(animated: Bool)
}

public extension PresentedAnchor {
    func dismiss() {
        dismiss(animated: true)
    }
}

class _PresentedAnchorImpl: PresentedAnchor {
    let onNeedDismiss: PizzaClosure<Bool>?
    init(onNeedDismiss: PizzaClosure<Bool>?) {
        self.onNeedDismiss = onNeedDismiss
    }
    func dismiss(animated: Bool) {
        onNeedDismiss?(animated)
    }
}
