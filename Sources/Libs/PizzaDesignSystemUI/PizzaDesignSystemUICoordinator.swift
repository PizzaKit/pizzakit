import PizzaKit
import XCoordinator
import UIKit

public enum PizzaDesignSystemUIRoute: Route {
    case openComponents
    case openLabelStyles
    case openColors
    case openButtons
    case openPopups

    case initial
}

public class PizzaDesignSystemUICoordinator: NavigationCoordinator<PizzaDesignSystemUIRoute> {

    public init() {
        let navController = UINavigationController().do {
            $0.apply(style: .allStyles.largeTitle)
        }
        super.init(rootViewController: navController, initialRoute: .initial)
    }

    public override func prepareTransition(for route: PizzaDesignSystemUIRoute) -> NavigationTransition {
        switch route {
        case .openComponents:
            let presenter = ComponentsPresenter()
            let controller = ComponentTableController(presenter: presenter)
            return .push(controller)
        case .openLabelStyles:
            let presenter = LabelStylesPresenter()
            let controller = ComponentTableController(presenter: presenter)
            return .push(controller)
        case .openColors:
            let presenter = ColorsPresenter()
            let controller = ComponentTableController(presenter: presenter)
            return .push(controller)
        case .openButtons:
            let presenter = ButtonsPresenter()
            let controller = ComponentTableController(presenter: presenter)
            return .push(controller)
        case .openPopups:
            let presenter = PopupPresenter()
            let controller = ComponentTableController(presenter: presenter)
            return .push(controller)
        case .initial:
            let presenter = MenuPresenter(router: weakRouter)
            let controller = ComponentTableController(presenter: presenter)
            return .push(controller)
        }
    }

}
