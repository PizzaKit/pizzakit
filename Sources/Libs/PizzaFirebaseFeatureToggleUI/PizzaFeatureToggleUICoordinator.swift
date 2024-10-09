import PizzaKit
import SPIndicator
import XCoordinator
import UIKit

public enum PizzaFeatureToggleUIRoute: Route {
    case open(anyFeatureToggle: PizzaAnyFeatureToggle)
    case edit(
        anyFeatureToggle: PizzaAnyFeatureToggle,
        anyFeatureToggleOverrideValue: PizzaAnyFeatureToggleOverrideValue
    )
    case initial
}

public class PizzaDesignSystemUICoordinator: NavigationCoordinator<PizzaFeatureToggleUIRoute> {

    private let featureToggleService: PizzaFeatureToggleService

    public init(featureToggleService: PizzaFeatureToggleService) {
        self.featureToggleService = featureToggleService
        let navController = UINavigationController().do {
            $0.apply(style: .allStyles.largeTitle)
        }
        super.init(rootViewController: navController, initialRoute: .initial)
    }

    public override func prepareTransition(for route: PizzaFeatureToggleUIRoute) -> NavigationTransition {
        switch route {
        case .open(let anyFeatureToggle):
            let presenter = TogglePresenter(
                featureToggleService: featureToggleService,
                router: weakRouter,
                featureToggle: anyFeatureToggle
            )
            let controller = ComponentTableController(presenter: presenter)
            return .push(controller)
        case .edit(let anyFeatureToggle, let anyFeatureToggleOverrideValue):
                guard let presenter = FeatureToggleValuePresenterFactory.producePresenter(
                    anyFeatureToggle: anyFeatureToggle,
                    anyFeatureToggleOverrideValue: anyFeatureToggleOverrideValue
                ) else {
                    SPIndicator.present(title: "Unsupported type \(anyFeatureToggle.valueType)", preset: .error)
                    return .none()
                }
                presenter.onNeedSaveValue = { [weak self] newValue in
                    self?.featureToggleService.setAnyOverride(
                        forAnyFeatureToggle: anyFeatureToggle,
                        anyOverrideValue: .init(
                            value: newValue,
                            valueType: anyFeatureToggleOverrideValue.valueType,
                            isOverrideEnabled: anyFeatureToggleOverrideValue.isOverrideEnabled
                        )
                    )
                }
                let controller = presenter.createController()
            return .push(controller)
        case .initial:
            let presenter = TogglesListPresenter(
                featureToggleService: featureToggleService,
                router: weakRouter
            )
            let controller = ComponentTableController(presenter: presenter)
            return .push(controller)
        }
    }

}
