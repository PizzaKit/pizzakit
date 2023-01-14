import Foundation

/// Alert for showing
open class PizzaAlert {

    // MARK: - Nested Types

    public enum Style {
        case alert, actionSheet
    }

    // MARK: - Properties

    private(set) var title: String?
    private(set) var description: String?
    private(set) var style: Style

    private(set) var actions: [PizzaAlertAction] = []

    var cancelAction: PizzaAlertAction? {
        return actions.first {
            $0.style == .cancel
        }
    }

    var nonCancelActions: [PizzaAlertAction] {
        return actions.filter {
            $0.style != .cancel
        }
    }

    // MARK: - Initialization

    public init(
        title: String? = nil,
        description: String? = nil,
        actions: [PizzaAlertAction] = [],
        style: Style? = nil
    ) {
        self.title = title
        self.description = description
        self.actions = actions
        self.style = style ?? .alert
    }

    // MARK: - Public methods

    @discardableResult
    open func add(action: PizzaAlertAction) -> PizzaAlert {
        actions.append(action)
        return self
    }

    @discardableResult
    open func add(actions: [PizzaAlertAction]) -> PizzaAlert {
        self.actions.append(contentsOf: actions)
        return self
    }

    @discardableResult
    open func title(_ title: String?) -> PizzaAlert {
        self.title = title
        return self
    }

    @discardableResult
    open func description(_ description: String?) -> PizzaAlert {
        self.description = description
        return self
    }

    @discardableResult
    open func style(_ style: Style) -> PizzaAlert {
        self.style = style
        return self
    }

    open func build() -> PizzaBuildedAlert {
        assert(
            actions.filter { $0.isPreferred }.count <= 1,
            "multiple preferred actions is not allowed"
        )
        let alertController = PizzaAlertConfiguration.factory.produce(with: self)
        return .init(alertController: alertController)
    }

}
