import PizzaCore

public class PizzaCardPopupCloseFireWrapper {

    private var closeType: PizzaCardPopupCloseType = .swiped
    private var completions: [PizzaClosure<PizzaCardPopupCloseType>] = []

    public init(completion: PizzaClosure<PizzaCardPopupCloseType>? = nil) {
        self.completions = [completion].compactMap { $0 }
    }

    public func add(completion: @escaping PizzaClosure<PizzaCardPopupCloseType>) {
        completions.append(completion)
    }

    public func fill(closeType: PizzaCardPopupCloseType) {
        self.closeType = closeType
    }

    public func callCompletionJustOnce() {
        completions.forEach { $0(closeType) }
        completions = []
    }

}
