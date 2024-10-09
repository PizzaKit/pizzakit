import UIKit

/// Factory for native alert style
open class PizzaNativeAlertFactory: PizzaAlertFactory {

    // MARK: - Private properties

    private var viewController = UIAlertController(
        title: nil,
        message: nil,
        preferredStyle: .alert
    )

    // MARK: - Initialization

    public init() {}

    // MARK: - AlertModuleConfiguratorAbstract

    open func produce(with alert: PizzaAlert) -> UIViewController {
        viewController = .init(
            title: alert.title,
            message: alert.description,
            preferredStyle: style(fromAlertStyle: alert.style)
        )

        alert.actions.forEach {
            addAction($0)
        }

        if alert.cancelAction == nil && alert.style == .actionSheet {
            addAction(.cancel())
        }

        if
            alert.actions.filter({ $0.isPreferred }).count <= 1,
            let preferredActionIndex = alert.actions.firstIndex(where: { $0.isPreferred })
        {
            viewController.preferredAction = viewController.actions[preferredActionIndex]
        }

        return viewController
    }

    // MARK: - Private methods

    private func style(fromAlertStyle style: PizzaAlert.Style) -> UIAlertController.Style {
        switch style {
        case .alert:
            return .alert
        case .actionSheet:
            return .actionSheet
        }
    }

    private func add(title: String?, description: String?) {
        viewController.title = title
        viewController.message = description
    }

    private func addAction(_ action: PizzaAlertAction) {
        let style: UIAlertAction.Style
        switch action.style {
        case .cancel:
            style = .cancel
        case .default:
            style = .default
        case .destructive:
            style = .destructive
        }
        let uiAction = UIAlertAction(
            title: action.title,
            style: style
        ) { _ in
            action.handler?()
        }
        viewController.addAction(uiAction)
    }

}
